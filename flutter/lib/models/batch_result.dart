class BatchResult {
  final String fileName;
  final String filePath;
  final bool success;
  final String? extractedText;
  final String? error;
  final DateTime processedAt;

  BatchResult({
    required this.fileName,
    required this.filePath,
    required this.success,
    this.extractedText,
    this.error,
    DateTime? processedAt,
  }) : processedAt = processedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'filePath': filePath,
      'success': success,
      'extractedText': extractedText,
      'error': error,
      'processedAt': processedAt.toIso8601String(),
    };
  }

  factory BatchResult.fromJson(Map<String, dynamic> json) {
    return BatchResult(
      fileName: json['fileName'],
      filePath: json['filePath'],
      success: json['success'],
      extractedText: json['extractedText'],
      error: json['error'],
      processedAt: DateTime.parse(json['processedAt']),
    );
  }

  int get textLength => extractedText?.length ?? 0;
  
  String get statusText {
    if (success) {
      return '$textLength کاراکتر استخراج شد';
    } else {
      return error ?? 'خطای نامشخص';
    }
  }
}
