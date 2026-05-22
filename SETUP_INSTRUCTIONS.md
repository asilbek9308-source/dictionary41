# Flutter Dictionary App - Complete Setup Guide

## Prerequisites
- Flutter SDK (3.16 or higher)
- Android SDK (API level 21+)
- Android Studio or VS Code with Flutter extension
- Git (for GitHub)

## Step 1: Create Flutter Project

```bash
# Create new Flutter project
flutter create personal_dictionary

# Navigate to project directory
cd personal_dictionary

# Remove default code
rm -rf lib/*
```

## Step 2: Update pubspec.yaml

Replace the entire `pubspec.yaml` with the content provided in `pubspec.yaml` file.

Then run:
```bash
flutter pub get
```

## Step 3: Create Project Structure

Create the following folder structure in the `lib/` directory:

```
lib/
├── main.dart
├── models/
│   └── word_model.dart
├── screens/
│   ├── home_screen.dart
│   ├── add_word_screen.dart
│   └── edit_word_screen.dart
├── services/
│   └── storage_service.dart
├── providers/
│   └── word_provider.dart
├── widgets/
│   ├── word_card.dart
│   ├── search_bar.dart
│   └── custom_app_bar.dart
├── constants/
│   └── theme.dart
└── utils/
    └── animations.dart
```

## Step 4: Copy All Code Files

Copy each Dart file from the provided code into the corresponding location above.

## Step 5: Build APK

### Option A: Build APK Locally

```bash
# Navigate to project directory
cd personal_dictionary

# Build release APK
flutter build apk --release

# The APK will be located at:
# build/app/outputs/flutter-apk/app-release.apk

# Copy to desktop or phone
# You can now install it on your Android device:
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Option B: Build APK with Split ABIs (Smaller Size)

```bash
flutter build apk --release --split-per-abi
```

The APKs will be in `build/app/outputs/flutter-apk/` with names like:
- `app-armeabi-v7a-release.apk`
- `app-arm64-v8a-release.apk`
- `app-x86_64-release.apk`

## Step 6: GitHub Setup

1. **Initialize Git Repository:**
```bash
git init
git add .
git commit -m "Initial commit: Personal Dictionary App"
```

2. **Create GitHub Repository:**
   - Go to https://github.com/new
   - Create a new repository named `personal-dictionary`
   - Do NOT initialize with README (you're pushing existing code)

3. **Connect to GitHub:**
```bash
git remote add origin https://github.com/YOUR_USERNAME/personal-dictionary.git
git branch -M main
git push -u origin main
```

## Step 7 (Optional): Automated APK Builds with GitHub Actions

Create `.github/workflows/build.yml` with the content provided in the GitHub Actions workflow file. This will automatically build your APK on each push to main.

## Testing

1. **Run on Emulator:**
```bash
flutter emulators
flutter emulators launch <emulator_name>
flutter run -d <device_id>
```

2. **Run on Physical Device:**
```bash
# Connect Android device and enable USB debugging
adb devices  # Verify connection
flutter run --release
```

## Project Architecture

- **Models**: Define data structures (Word model)
- **Services**: Handle storage operations (Hive database)
- **Providers**: Manage app state (Provider package)
- **Screens**: Full pages (Home, Add, Edit)
- **Widgets**: Reusable UI components
- **Constants**: Theme configuration
- **Utils**: Animation helpers and utilities

## Key Features

✅ Add/Edit/Delete words  
✅ Full-text search with real-time filtering  
✅ Smooth page transitions and animations  
✅ Hero animations for word cards  
✅ Ripple effects on button taps  
✅ Swipe-to-delete functionality  
✅ Local storage with Hive (persistent)  
✅ Clean white/light blue theme  
✅ Responsive design  

## Troubleshooting

**APK Build Fails:**
```bash
flutter clean
flutter pub get
flutter build apk --release
```

**Hot Reload Issues:**
```bash
flutter clean
flutter pub get
flutter run
```

**Hive Box Issues:**
```bash
# In your app, the Hive box is automatically initialized
# If you need to clear data during testing:
# Uncomment in main.dart: await Hive.deleteBoxFromDisk('words');
```

## File Sizes

- **Debug APK**: ~200-250 MB (larger, includes debugging info)
- **Release APK (universal)**: ~45-55 MB
- **Release APK (per ABI)**: ~30-35 MB each

For distribution, use split-per-abi APKs to reduce user download sizes.
