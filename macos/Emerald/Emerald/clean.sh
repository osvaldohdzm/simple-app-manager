#!/bin/zsh
# Limpieza específica para Emerald (React Native)
echo "🧹 Limpiando proyecto React Native (Emerald)..."
rm -rf node_modules dist .next build coverage .expo
npm cache clean --force
rm -rf $TMPDIR/react-* $TMPDIR/metro-* $TMPDIR/haste-map-* $TMPDIR/metro-cache
rm -rf logs/* *.log
if [ -d "android" ]; then
  cd android && ./gradlew clean && cd ..
fi
if [ -d "ios" ]; then
  rm -rf ios/build ios/Pods ios/Podfile.lock
fi
echo "✅ Limpieza completada para Emerald." 