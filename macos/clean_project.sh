#!/bin/zsh

# --- CONFIGURACIÓN INICIAL ---
repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root" || exit 1
project_name=$(basename "$repo_root")

echo "🧼 Iniciando limpieza para el proyecto: $project_name"
echo "📁 Directorio raíz: $repo_root"

# --- FLUJO: Emerald (React Native / Expo) ---
clean_emerald() {
  echo "🧹 Limpiando proyecto React Native (Emerald)..."

  # 1. Eliminar carpetas de dependencias y compilación
  echo "🗑️  Eliminando node_modules, dist, .next, .expo..."
  rm -rf node_modules dist .next build coverage .expo

  # 2. Limpiar caché de npm y Metro
  echo "♻️  Limpiando caché de npm y Metro..."
  npm cache clean --force
  rm -rf $TMPDIR/react-* $TMPDIR/metro-* $TMPDIR/haste-map-* $TMPDIR/metro-cache

  # 3. Eliminar archivos de log
  echo "🗂️  Eliminando archivos de log..."
  rm -rf logs/* *.log

  # 4. Limpiar Android y opcionalmente iOS
  if [ -d "android" ]; then
    echo "⚙️  Proyecto React Native detectado: limpiando Android..."
    cd android && ./gradlew clean && cd "$repo_root"
  fi

  if [ -d "ios" ]; then
    echo "🍏 Limpiando carpeta iOS..."
    rm -rf ios/build ios/Pods ios/Podfile.lock
  fi

  echo "✅ Limpieza completada para Emerald."
}

# --- FLUJO: Zafiro (Flutter) ---
clean_zafiro() {
  echo "🧹 Limpiando proyecto Flutter (Zafiro)..."

  #!/bin/bash

adb uninstall com.ohm.zafiro_app || echo "App no encontrada"

cd android
./gradlew --stop
cd ..

rm -rf android/.gradle
rm -rf ~/.gradle/caches
rm -rf ~/.gradle/daemon
rm -rf ~/.gradle/wrapper/dists

  # 1. Eliminar carpetas de dependencias y build
  echo "🗑️  Eliminando .dart_tool, build, .flutter-plugins..."
  rm -rf .dart_tool build .flutter-plugins .flutter-plugins-dependencies pubspec.lock

  # 2. Limpiar caché de Flutter
  echo "♻️  Limpiando caché de Flutter..."
  flutter clean

  # 3. Eliminar archivos de log
  echo "🗂️  Eliminando archivos de log..."
  rm -rf logs/* *.log

  echo "✅ Limpieza completada para Zafiro."
}

# --- DESPACHADOR POR PROYECTO ---
case "$project_name" in
  "Emerald")
    clean_emerald
    ;;
  "Zafiro")
    clean_zafiro
    ;;
  *)
    echo "⚠️  Proyecto '$project_name' no tiene rutina de limpieza definida."
    ;;
esac
