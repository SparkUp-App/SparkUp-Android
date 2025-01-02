# Project Setup Guide

This guide will walk you through setting up the development environment and running our Flutter project. Please follow each step carefully to ensure a smooth setup process.

## Table of Contents
1. Prerequisites Installation
2. Project Setup
3. Running the Project
4. Troubleshooting

## 1. Prerequisites Installation

### Flutter SDK Setup (Version 3.22.3) From Website
1. Download Flutter SDK 3.22.3
   - Visit: https://docs.flutter.dev/get-started/install
   - Download Flutter 3.22.3 ZIP file
   - Extract to `C:\src\flutter` (recommended path)

2. Set Up Environment Variables
   - Add `C:\src\flutter\bin` to your system's PATH variable
   - Verify setup by running:
     ```bash
     flutter --version
     ```
   - Should show version 3.22.3

### Flutter SDK Setup (Version 3.22.3) From GitHub
1. Get git clone URL
   - Visit: https://github.com/flutter/flutter
   - Clone Flutter SDK from gitrepository
     ```bash
     git clone https://github.com/flutter/flutter
     ```
   - Setting Flutter 3.22.3 version: go to the clonded field
      ```bash
       git branch flutter3.22.3 3.22.3
       git switch flutter3.22.3
      ```
2. Set Up Environment Variables
   - Add `C:\src\flutter\bin` to your system's PATH variable
   - Verify setup by running:
     ```bash
     flutter --version
     ```
   - Should show version 3.22.3
     
### Android Studio Setup
1. Install Android Studio
   - Download from https://developer.android.com/studio
   - Run installer and complete setup wizard
   - Install Android SDK

2. Install Required Plugins
   - Open Android Studio → Settings/Preferences → Plugins
   - Install:
     - Flutter plugin
     - Dart plugin
   - Restart Android Studio

### VSCode Setup (If using VSCode)
1. Install VSCode from https://code.visualstudio.com/
2. Install Extensions:
   - Flutter
   - Dart

## 2. Android Emulator Setup

### Creating a Virtual Device
1. Open Android Studio
2. Click on "Tools" → "Device Manager" or click the "Device Manager" icon in the toolbar
3. Click on "Create Device" button

### Select Hardware Profile
1. Choose a device definition:
   - Recommended: "Pixel 7" or newer for a phone device
   - Select your preferred screen size and resolution
2. Click "Next"

### Select System Image
1. Choose the Android version:
   - Recommended: API 32 (Android 12.0)
   - If not installed, click "Download" next to the system image
   - Wait for download and installation to complete
2. Click "Next"

### Configure Virtual Device
1. Verify the AVD Name and settings
2. Click "Finish"


## 3. Project Setup

### Clone the project
- Clone the project from our repository or donload the zip file and extract it.

### Open the project
- Use VSCode or Android Studio to open the file downloaded

### Install Dependencies
1. Route to the **lib** file
```bash
flutter pub get
```

## 4. Running the Project

### Build and Run
1. Connect a device or start an emulator
2. Run the project:
   ```bash
   flutter run
   ```

### Available Run Configurations
- Release mode:
  ```bash
  flutter run --release
  ```

## 5. Troubleshooting

### Verify Installation
Run the following command and ensure all checks pass:
```bash
flutter doctor
```

### Common Issues and Solutions

1. **SDK Version Mismatch**
   - Error: "Flutter SDK version mismatch"
   - Solution: Ensure you're using Flutter 3.22.3
   ```bash
   flutter --version
   ```

2. **Missing Dependencies**
   - Error: "Running pod install..."
   - Solution: Run
   ```bash
   flutter pub get
   ```

3. **Build Errors**
   - Clean and rebuild:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

4. **Environment Setup Issues**
   - Verify environment variables
   - Check Android Studio and VSCode plugins
   - Ensure Android SDK is properly installed
