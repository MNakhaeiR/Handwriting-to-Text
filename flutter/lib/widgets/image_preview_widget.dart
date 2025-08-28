import 'package:flutter/material.dart';
import 'dart:io';

class ImagePreviewWidget extends StatelessWidget {
  final File imageFile;
  final VoidCallback onRemove;

  const ImagePreviewWidget({
    super.key,
    required this.imageFile,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'تصویر انتخاب شده',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: onRemove,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                imageFile,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade100,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'خطا در نمایش تصویر',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نام فایل: ${imageFile.path.split('/').last}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                FutureBuilder<int>(
                  future: imageFile.length(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final sizeInKB = (snapshot.data! / 1024).round();
                      return Text(
                        'اندازه: ${sizeInKB} KB',
                        style: const TextStyle(fontSize: 12),
                      );
                    }
                    return const Text(
                      'اندازه: محاسبه...',
                      style: TextStyle(fontSize: 12),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
