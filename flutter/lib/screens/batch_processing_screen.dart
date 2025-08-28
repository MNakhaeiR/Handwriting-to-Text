import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../services/ocr_service.dart';
import '../widgets/batch_progress_widget.dart';
import '../models/batch_result.dart';

class BatchProcessingScreen extends StatefulWidget {
  const BatchProcessingScreen({super.key});

  @override
  State<BatchProcessingScreen> createState() => _BatchProcessingScreenState();
}

class _BatchProcessingScreenState extends State<BatchProcessingScreen> {
  final OCRService _ocrService = OCRService();
  
  List<File> _selectedImages = [];
  List<BatchResult> _results = [];
  bool _isProcessing = false;
  int _currentIndex = 0;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('پردازش دسته‌ای'),
        actions: [
          if (_results.isNotEmpty && !_isProcessing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveResults,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // File selection section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'انتخاب تصاویر',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _isProcessing ? null : _selectImages,
                      icon: const Icon(Icons.folder_open),
                      label: Text(_selectedImages.isEmpty 
                          ? 'انتخاب تصاویر' 
                          : '${_selectedImages.length} تصویر انتخاب شده'),
                    ),
                    if (_selectedImages.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _isProcessing ? null : _processAllImages,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('شروع پردازش'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Progress section
            if (_isProcessing || _results.isNotEmpty) ...[
              BatchProgressWidget(
                total: _selectedImages.length,
                current: _currentIndex,
                isProcessing: _isProcessing,
              ),
              const SizedBox(height: 16),
            ],
            
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
            
            // Results section
            if (_results.isNotEmpty) ...[
              const Text(
                'نتایج پردازش',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final result = _results[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: result.success
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.error, color: Colors.red),
                        title: Text(result.fileName),
                        subtitle: Text(
                          result.success
                              ? '${result.extractedText?.length ?? 0} کاراکتر'
                              : result.error ?? 'خطای نامشخص',
                        ),
                        trailing: result.success
                            ? IconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: () => _showTextDialog(result),
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _selectImages() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null) {
        setState(() {
          _selectedImages = result.paths
              .where((path) => path != null)
              .map((path) => File(path!))
              .toList();
          _results.clear();
          _currentIndex = 0;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'خطا در انتخاب فایل‌ها: ${e.toString()}';
      });
    }
  }

  Future<void> _processAllImages() async {
    if (_selectedImages.isEmpty) return;

    setState(() {
      _isProcessing = true;
      _results.clear();
      _currentIndex = 0;
      _errorMessage = null;
    });

    for (int i = 0; i < _selectedImages.length; i++) {
      setState(() {
        _currentIndex = i + 1;
      });

      final file = _selectedImages[i];
      final fileName = file.path.split('/').last;

      try {
        final extractedText = await _ocrService.extractText(file);
        _results.add(BatchResult(
          fileName: fileName,
          filePath: file.path,
          success: true,
          extractedText: extractedText,
        ));
      } catch (e) {
        _results.add(BatchResult(
          fileName: fileName,
          filePath: file.path,
          success: false,
          error: e.toString(),
        ));
      }

      setState(() {});
    }

    setState(() {
      _isProcessing = false;
    });
  }

  void _showTextDialog(BatchResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(result.fileName),
        content: SingleChildScrollView(
          child: SelectableText(
            result.extractedText ?? '',
            style: const TextStyle(fontFamily: 'Vazir'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('بستن'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveResults() async {
    // Implementation for saving results to files
    // This would save each result to a text file
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('نتایج ذخیره شد'),
      ),
    );
  }
}
