#!/bin/zsh

echo "🧹 Limpiando proyecto React..."

# Asegúrate de estar en la raíz del repositorio Git
repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root" || exit 1
echo "📁 Directorio raíz del repositorio: $repo_root"

# 1. Eliminar carpetas comunes de dependencias y compilación
echo "🗑️  Eliminando node_modules, dist, .next..."
rm -rf node_modules dist .next build coverage .expo

# 2. Limpiar caché de npm y Metro bundler (React Native)
echo "♻️  Limpiando caché de npm y Metro..."
npm cache clean --force
rm -rf $TMPDIR/react-* $TMPDIR/metro-* $TMPDIR/haste-map-* $TMPDIR/metro-cache

# 3. Eliminar archivos de log
echo "🗂️  Eliminando archivos de log..."
rm -rf logs/* *.log

# 4. Si es React Native, limpiar también Android (y opcionalmente iOS)
if [ -d "android" ]; then
  echo "⚙️  Proyecto React Native detectado: limpiando Android..."
  cd android && ./gradlew clean && cd "$repo_root"
fi

if [ -d "ios" ]; then
  echo "🍏 Limpiando carpeta iOS..."
  rm -rf ios/build ios/Pods ios/Podfile.lock
fi

# 5. Confirmación final
echo "✅ Limpieza completada."
