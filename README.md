# meow-media-flutter

A beginner-friendly Flutter foundation for local iOS and Android development.

## Current scope

This repository is currently focused on **environment/bootstrap setup only**.
No business features or backend integration have been added yet.

## Project structure

The repository includes these foundational directories:

- `ios/`
- `android/`
- `lib/`
- `test/`
- `integration_test/`
- `assets/`

Inside `lib/`, starter folders are prepared for growth:

- `lib/app/`
- `lib/core/`
- `lib/shared/`
- `lib/features/`

## Install dependencies

```bash
flutter pub get
```

## Verify local Flutter toolchain

```bash
flutter doctor -v
```

## Run on iOS simulator (macOS)

1. Open Simulator (for example from Xcode):
   ```bash
   open -a Simulator
   ```
2. Start the app:
   ```bash
   flutter run -d ios
   ```

## Run on Android emulator

1. Start an Android emulator (from Android Studio Device Manager, or CLI).
2. Confirm a device is available:
   ```bash
   flutter devices
   ```
3. Start the app:
   ```bash
   flutter run -d android
   ```

## Intentionally deferred for later

- Django backend API integration (`django-auth-core`)
- Authentication and business/domain features
- Native signing/release configuration
- Advanced architecture and large refactors
