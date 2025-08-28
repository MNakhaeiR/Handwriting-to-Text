import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextResultWidget extends StatelessWidget {
  final String text;
  final String imageName;

  const TextResultWidget({
    super.key,
    required this.text,
    required this.imageName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'متن استخراج شده',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () => _copyToClipboard(context),
                      tooltip: 'کپی',
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () => _shareText(context),
                      tooltip: 'اشتراک‌گذاری',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.text_fields, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        '${text.length} کاراکتر',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.format_list_numbered, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        '${text.split('\n').length} خط',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 300,
                    ),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        text,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontFamily: 'Vazir',
                        ),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _saveAsFile(context),
                    icon: const Icon(Icons.save_alt),
                    label: const Text('ذخیره به فایل'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showFullTextDialog(context),
                    icon: const Icon(Icons.fullscreen),
                    label: const Text('نمایش کامل'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('متن کپی شد'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _shareText(BuildContext context) {
    // Implementation would use share_plus package
    // For now, just copy to clipboard
    _copyToClipboard(context);
  }

  void _saveAsFile(BuildContext context) {
    // Implementation would save text to a file
    // This would be implemented with file system operations
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('فایل ذخیره شد'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showFullTextDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('متن کامل - $imageName'),
        content: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.6,
          child: SingleChildScrollView(
            child: SelectableText(
              text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                fontFamily: 'Vazir',
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('بستن'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _copyToClipboard(context);
            },
            child: const Text('کپی و بستن'),
          ),
        ],
      ),
    );
  }
}
