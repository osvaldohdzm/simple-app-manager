#!/bin/zsh
# Build específico para Orbe (Flutter)
echo "🟦 [Orbe] Compilando APK (Flutter)..."
flutter clean
flutter pub get
flutter pub run flutter_launcher_icons
dart run flutter_native_splash:create
flutter build apk --release
echo "✅ [Orbe] APK compilado." 