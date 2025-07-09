#!/bin/zsh
# Build específico para Zafiro (Flutter)
echo "🟦 [Zafiro] Compilando APK (Flutter)..."
flutter clean
flutter pub get
flutter pub run flutter_launcher_icons
dart run flutter_native_splash:create
flutter build apk --release
echo "✅ [Zafiro] APK compilado." 