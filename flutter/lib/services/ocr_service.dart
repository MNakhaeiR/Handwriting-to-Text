import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;

class OCRService {
  static const String _defaultApiKey = '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';
  static const String _apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static const String _model = 'qwen/qwen2.5-vl-72b-instruct:free';
  
  static const String _persianPrompt = '''
تمام متن فارسی موجود در تصویر را دقیقاً به همان شکل استخراج کن. موارد زیر را رعایت کن:
۱. متن را دقیقاً با همان خط و فاصله‌ها بنویس
۲. حروف و اعداد فارسی را کاملاً حفظ کن
۳. جهت نوشتار راست به چپ را حفظ کن
۴. علائم نگارشی و اعداد عربی را تغییر نده
۵. اگر متن انگلیسی هم وجود دارد، آن را جداگانه مشخص کن
''';

  Future<String> extractText(File imageFile) async {
    try {
      // Get settings
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString('api_key') ?? _defaultApiKey;
      final imageQuality = prefs.getInt('image_quality') ?? 85;
      final maxImageSize = prefs.getInt('max_image_size') ?? 1024;

      // Process image
      final processedImage = await _processImage(imageFile, imageQuality, maxImageSize);
      final base64Image = base64Encode(processedImage);

      // Prepare API request
      final headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      };

      final requestBody = {
        'model': _model,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text': _persianPrompt,
              },
              {
                'type': 'image_url',
                'image_url': {
                  'url': 'data:image/jpeg;base64,$base64Image',
                },
              },
            ],
          },
        ],
      };

      // Make API request
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode != 200) {
        throw Exception('خطای API: ${response.statusCode} - ${response.body}');
      }

      final responseData = jsonDecode(response.body);
      
      if (responseData['choices'] == null || 
          responseData['choices'].isEmpty ||
          responseData['choices'][0]['message'] == null) {
        throw Exception('پاسخ نامعتبر از API');
      }

      String extractedText = responseData['choices'][0]['message']['content'];
      
      // Clean up the extracted text
      extractedText = _cleanExtractedText(extractedText);
      
      if (extractedText.trim().isEmpty) {
        throw Exception('متنی در تصویر یافت نشد');
      }

      return extractedText;
      
    } catch (e) {
      if (e.toString().contains('SocketException') || 
          e.toString().contains('TimeoutException')) {
        throw Exception('خطای اتصال به اینترنت. لطفاً اتصال خود را بررسی کنید.');
      }
      
      if (e.toString().contains('401')) {
        throw Exception('کلید API نامعتبر است. لطفاً در تنظیمات کلید صحیح را وارد کنید.');
      }
      
      if (e.toString().contains('429')) {
        throw Exception('تعداد درخواست‌ها بیش از حد مجاز است. لطفاً کمی صبر کنید.');
      }
      
      throw Exception('خطا در استخراج متن: ${e.toString()}');
    }
  }

  Future<Uint8List> _processImage(File imageFile, int quality, int maxSize) async {
    try {
      // Read image
      final imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);
      
      if (image == null) {
        throw Exception('فرمت تصویر پشتیبانی نمی‌شود');
      }

      // Resize image if necessary
      if (image.width > maxSize || image.height > maxSize) {
        image = img.copyResize(
          image,
          width: image.width > image.height ? maxSize : null,
          height: image.height > image.width ? maxSize : null,
        );
      }

      // Convert to JPEG with specified quality
      final processedBytes = img.encodeJpg(image, quality: quality);
      return Uint8List.fromList(processedBytes);
      
    } catch (e) {
      throw Exception('خطا در پردازش تصویر: ${e.toString()}');
    }
  }

  String _cleanExtractedText(String text) {
    // Remove extra whitespace and clean up the text
    text = text.trim();
    
    // Remove Unicode control characters
    text = text.replaceAll(RegExp(r'[\u200c\u200d]'), '');
    
    // Remove any text before the first Persian character
    final persianMatch = RegExp(r'[\u0600-\u06FF]').firstMatch(text);
    if (persianMatch != null) {
      text = text.substring(persianMatch.start);
    }
    
    // Clean up multiple spaces and newlines
    text = text.replaceAll(RegExp(r'\n\s*\n'), '\n\n');
    text = text.replaceAll(RegExp(r' +'), ' ');
    
    return text.trim();
  }

  // Method to test API connection
  Future<bool> testApiConnection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString('api_key') ?? _defaultApiKey;
      
      final headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      };

      final testBody = {
        'model': _model,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text': 'test',
              },
            ],
          },
        ],
        'max_tokens': 1,
      };

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: headers,
        body: jsonEncode(testBody),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
      
    } catch (e) {
      return false;
    }
  }
}
