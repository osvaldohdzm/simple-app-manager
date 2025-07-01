#!/bin/zsh

echo "🟢 Construyendo APK release..."

# Limpiar cache y dependencias (opcional)
rm -rf node_modules package-lock.json
npm install

if [ $? -ne 0 ]; then
    echo "❌ Error: Falló instalación de dependencias."
    exit 1
fi

# Construir APK release en android
cd android
./gradlew assembleRelease

if [ $? -ne 0 ]; then
    echo "❌ Error: Falló la construcción del APK release."
    exit 1
fi

echo "✅ APK release construido correctamente."

echo "El APK se encuentra en: android/app/build/outputs/apk/release/app-release.apk"
