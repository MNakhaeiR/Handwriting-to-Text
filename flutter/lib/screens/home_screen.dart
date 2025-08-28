import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../services/ocr_service.dart';
import '../widgets/image_preview_widget.dart';
import '../widgets/text_result_widget.dart';
import '../widgets/loading_widget.dart';
import 'batch_processing_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OCRService _ocrService = OCRService();
  final ImagePicker _picker = ImagePicker();
  
  File? _selectedImage;
  String? _extractedText;
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('استخراج متن از دست‌نوشته'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToSettings(),
          ),
          IconButton(
            icon: const Icon(Icons.batch_prediction),
            onPressed: () => _navigateToBatchProcessing(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image selection section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'انتخاب تصویر',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('دوربین'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('گالری'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _pickFile,
                          icon: const Icon(Icons.folder),
                          label: const Text('فایل'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Image preview
            if (_selectedImage != null) ...[
              ImagePreviewWidget(
                imageFile: _selectedImage!,
                onRemove: () => setState(() {
                  _selectedImage = null;
                  _extractedText = null;
                  _errorMessage = null;
                }),
              ),
              const SizedBox(height: 16),
              
              // Process button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _processImage,
                  icon: _isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.text_fields),
                  label: Text(_isProcessing ? 'در حال پردازش...' : 'استخراج متن'),
                ),
              ),
              
              const SizedBox(height: 16),
            ],
            
            // Loading indicator
            if (_isProcessing) const LoadingWidget(),
            
            // Error message
            if (_errorMessage != null) ...[
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Extracted text
            if (_extractedText != null)
              TextResultWidget(
                text: _extractedText!,
                imageName: _selectedImage?.path.split('/').last ?? '',
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _extractedText = null;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'خطا در انتخاب تصویر: ${e.toString()}';
      });
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedImage = File(result.files.single.path!);
          _extractedText = null;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'خطا در انتخاب فایل: ${e.toString()}';
      });
    }
  }

  Future<void> _processImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
      _extractedText = null;
    });

    try {
      final result = await _ocrService.extractText(_selectedImage!);
      setState(() {
        _extractedText = result;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'خطا در استخراج متن: ${e.toString()}';
        _isProcessing = false;
      });
    }
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _navigateToBatchProcessing() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BatchProcessingScreen()),
    );
  }
}
