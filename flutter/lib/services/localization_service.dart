import 'package:flutter/material.dart';

class LocalizationService {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'Persian Handwriting OCR',
      'select_image': 'Select Image',
      'camera': 'Camera',
      'gallery': 'Gallery',
      'file': 'File',
      'extract_text': 'Extract Text',
      'processing': 'Processing...',
      'settings': 'Settings',
      'batch_processing': 'Batch Processing',
      'save': 'Save',
      'close': 'Close',
      'error': 'Error',
      'success': 'Success',
      'api_settings': 'API Settings',
      'api_key': 'OpenRouter API Key',
      'image_processing_settings': 'Image Processing Settings',
      'image_quality': 'Image Quality',
      'max_image_size': 'Max Image Size',
      'app_settings': 'App Settings',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'about': 'About',
      'version': 'Version',
    },
    'fa': {
      'app_title': 'استخراج متن از دست‌نوشته فارسی',
      'select_image': 'انتخاب تصویر',
      'camera': 'دوربین',
      'gallery': 'گالری',
      'file': 'فایل',
      'extract_text': 'استخراج متن',
      'processing': 'در حال پردازش...',
      'settings': 'تنظیمات',
      'batch_processing': 'پردازش دسته‌ای',
      'save': 'ذخیره',
      'close': 'بستن',
      'error': 'خطا',
      'success': 'موفقیت',
      'api_settings': 'تنظیمات API',
      'api_key': 'کلید API OpenRouter',
      'image_processing_settings': 'تنظیمات پردازش تصویر',
      'image_quality': 'کیفیت تصویر',
      'max_image_size': 'حداکثر اندازه تصویر',
      'app_settings': 'تنظیمات برنامه',
      'dark_mode': 'حالت تیره',
      'language': 'زبان',
      'about': 'درباره',
      'version': 'نسخه',
    },
  };

  static String translate(String key, String languageCode) {
    return _localizedValues[languageCode]?[key] ?? key;
  }

  static Map<String, String> getTranslations(String languageCode) {
    return _localizedValues[languageCode] ?? _localizedValues['en']!;
  }
}
