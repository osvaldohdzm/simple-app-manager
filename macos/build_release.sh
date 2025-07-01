#!/bin/zsh

# --- CONFIGURACIÓN INICIAL ---
repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root" || exit 1
project_name=$(basename "$repo_root")

echo "🚀 Iniciando construcción de APK release para: $project_name"
echo "📁 Proyecto raíz: $repo_root"

# --- FLUJO: ZAFIRO (Flutter) ---
build_emeral() {

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

}

# --- FLUJO: EMERALD (React Native / npm) ---
build_zafiro() {

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

}

# --- DESPACHADOR POR PROYECTO ---
case "$project_name" in
  "Emerald")
    build_emeral
    ;;
  "Zafiro")
    build_zafiro
    ;;
  *)
    echo "⚠️ Proyecto '$project_name' no tiene rutina de build definida."
    ;;
esac
