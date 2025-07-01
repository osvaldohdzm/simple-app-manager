#!/bin/zsh
# Limpieza específica para Zafiro (Flutter)
echo "🧹 Limpiando proyecto Flutter (Zafiro)..."
adb uninstall com.ohm.zafiro_app || echo "App no encontrada"
cd android && ./gradlew --stop && cd ..
rm -rf android/.gradle
rm -rf ~/.gradle/caches ~/.gradle/daemon ~/.gradle/wrapper/dists
rm -rf .dart_tool build .flutter-plugins .flutter-plugins-dependencies pubspec.lock
flutter clean
rm -rf logs/* *.log
echo "✅ Limpieza completada para Zafiro." 