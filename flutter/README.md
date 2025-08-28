# Persian Handwriting OCR Flutter App

A cross-platform Flutter application for extracting Persian text from handwritten images using AI-powered OCR technology.

## Features

- **Persian Text Recognition**: Specialized OCR for Persian handwriting
- **Multiple Input Sources**: Camera, gallery, and file picker
- **Batch Processing**: Process multiple images at once
- **Cross-Platform**: Android, iOS, Windows, and macOS support
- **Offline Capabilities**: Works with cloud-based OCR service
- **Export Options**: Save results as text files
- **Persian UI**: Right-to-left interface design

## Requirements

- Flutter 3.13.0 or higher
- Dart 3.1.0 or higher
- OpenRouter API key (for OCR service)

## Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd handwriting-to-text/flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Key**
   - Open the app and go to Settings
   - Enter your OpenRouter API key
   - Get your API key from [OpenRouter.ai](https://openrouter.ai)

## Building for Different Platforms

### Android
```bash
flutter build apk --release
# or for App Bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Windows
```bash
flutter build windows --release
```

### macOS
```bash
flutter build macos --release
```

## Usage

1. **Single Image Processing**
   - Select an image using camera, gallery, or file picker
   - Tap "Extract Text" to process
   - View, copy, or save the extracted text

2. **Batch Processing**
   - Go to "Batch Processing" screen
   - Select multiple images
   - Process all images at once
   - View results for each image

3. **Settings**
   - Configure API key
   - Adjust image quality and size
   - Change app language and theme

## API Configuration

The app uses OpenRouter's API with the Qwen2.5-VL model for OCR processing. You'll need to:

1. Sign up at [OpenRouter.ai](https://openrouter.ai)
2. Get your API key
3. Enter it in the app settings

## Permissions

### Android
- Camera access (for taking photos)
- Storage access (for saving files)
- Internet access (for API calls)

### iOS/macOS
- Camera access
- Photo library access
- Document folder access

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/                  # UI screens
│   ├── home_screen.dart
│   ├── batch_processing_screen.dart
│   └── settings_screen.dart
├── services/                 # Business logic
│   ├── ocr_service.dart
│   └── localization_service.dart
├── widgets/                  # Reusable UI components
│   ├── image_preview_widget.dart
│   ├── text_result_widget.dart
│   └── loading_widget.dart
└── models/                   # Data models
    └── batch_result.dart
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on multiple platforms
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- OpenRouter.ai for OCR API
- Flutter team for the amazing framework
- Qwen team for the vision-language model
