#!/bin/zsh

flutter clean

# Obtener dependencias de Flutter
echo "📦 Descargando dependencias..."
flutter pub get

# Verificar estado del entorno
echo "🩺 Verificando instalación de Flutter..."
#flutter doctor

flutter pub run flutter_launcher_icons

# Regenerar splash screen
echo "🎨 Regenerando splash screen..."
dart run flutter_native_splash:create

# Compilar APK de Release
echo "🏗️ Compilando APK (Release)..."
flutter build apk --release

echo "--- Compilación finalizada ---"