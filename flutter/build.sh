#!/bin/bash

# Persian Handwriting OCR - Build Script
# This script helps build the Flutter app for different platforms

echo "==================================="
echo "Persian Handwriting OCR Build Script"
echo "==================================="

# Function to build for Android
build_android() {
    echo "Building Android APK..."
    flutter build apk --release
    echo "Android APK built successfully!"
    echo "Location: build/app/outputs/flutter-apk/app-release.apk"
}

# Function to build Android App Bundle
build_android_bundle() {
    echo "Building Android App Bundle..."
    flutter build appbundle --release
    echo "Android App Bundle built successfully!"
    echo "Location: build/app/outputs/bundle/release/app-release.aab"
}

# Function to build for iOS
build_ios() {
    echo "Building iOS..."
    flutter build ios --release
    echo "iOS build completed!"
    echo "Use Xcode to create IPA file from ios/Runner.xcworkspace"
}

# Function to build for Windows
build_windows() {
    echo "Building Windows..."
    flutter build windows --release
    echo "Windows build completed!"
    echo "Location: build/windows/runner/Release/"
}

# Function to build for macOS
build_macos() {
    echo "Building macOS..."
    flutter build macos --release
    echo "macOS build completed!"
    echo "Location: build/macos/Build/Products/Release/"
}

# Function to build for all platforms
build_all() {
    echo "Building for all platforms..."
    build_android
    echo ""
    build_android_bundle
    echo ""
    if [[ "$OSTYPE" == "darwin"* ]]; then
        build_ios
        echo ""
        build_macos
        echo ""
    fi
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        build_windows
        echo ""
    fi
    echo "All builds completed!"
}

# Function to clean build artifacts
clean_build() {
    echo "Cleaning build artifacts..."
    flutter clean
    flutter pub get
    echo "Clean completed!"
}

# Function to run tests
run_tests() {
    echo "Running tests..."
    flutter test
    echo "Tests completed!"
}

# Main menu
case "$1" in
    "android")
        build_android
        ;;
    "android-bundle")
        build_android_bundle
        ;;
    "ios")
        build_ios
        ;;
    "windows")
        build_windows
        ;;
    "macos")
        build_macos
        ;;
    "all")
        build_all
        ;;
    "clean")
        clean_build
        ;;
    "test")
        run_tests
        ;;
    *)
        echo "Usage: $0 {android|android-bundle|ios|windows|macos|all|clean|test}"
        echo ""
        echo "Options:"
        echo "  android        - Build Android APK"
        echo "  android-bundle - Build Android App Bundle"
        echo "  ios           - Build iOS app"
        echo "  windows       - Build Windows app"
        echo "  macos         - Build macOS app"
        echo "  all           - Build for all available platforms"
        echo "  clean         - Clean build artifacts"
        echo "  test          - Run tests"
        exit 1
        ;;
esac
