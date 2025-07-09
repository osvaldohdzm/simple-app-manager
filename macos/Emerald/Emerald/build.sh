#!/bin/zsh
# Build específico para Emerald (React Native)
echo "🟩 [Emerald] Instalando dependencias y compilando APK (React Native)..."
rm -rf node_modules package-lock.json
npm install || { echo "❌ Error: Falló npm install"; exit 1; }
cd android && ./gradlew assembleRelease || { echo "❌ Error: Falló gradlew"; exit 1; }
cd ..
echo "✅ [Emerald] APK compilado." 