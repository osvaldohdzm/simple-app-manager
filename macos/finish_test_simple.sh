#!/bin/zsh

# --- CONFIGURACIÓN INICIAL ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(git rev-parse --show-toplevel)"
PROJECT_NAME=$(basename "$PROJECT_ROOT")

echo "🛑 Abortando pruebas para el proyecto: $PROJECT_NAME"
echo "📁 Proyecto raíz: $PROJECT_ROOT"

# --- FUNCIÓN LOG SIMPLE ---
log() {
  local ts=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$ts] $1"
}

# --- FINALIZADOR PARA PROYECTO EMERALD (React Native / Expo) ---
abort_emerald() {
  log "🚨 Ejecutando rutina de limpieza para Emerald (React Native / Expo)..."

  # 1. Puerto Metro (8081)
  log "🔧 Cerrando procesos en el puerto 8081 (Metro Bundler)..."
  METRO_PID=$(lsof -t -i:8081)
  if [ -n "$METRO_PID" ]; then
    kill -9 "$METRO_PID"
    log "✅ Proceso en 8081 terminado (PID: $METRO_PID)."
  else
    log "✅ No hay proceso activo en 8081."
  fi

  # 2. Procesos comunes
  log "🔧 Terminando procesos 'expo', 'metro', 'watchman'..."
  pkill -f "expo" >/dev/null 2>&1
  pkill -f "metro" >/dev/null 2>&1
  pkill -f "watchman" >/dev/null 2>&1
  log "✅ Procesos relacionados eliminados (si existían)."

  # 3. Detener daemons de Gradle
  log "🔧 Deteniendo Gradle daemons (si aplica)..."
  if [ -f "$PROJECT_ROOT/android/gradlew" ]; then
    chmod +x "$PROJECT_ROOT/android/gradlew"
    "$PROJECT_ROOT/android/gradlew" --stop
    log "✅ Gradle detenido correctamente."
  else
    log "⚠️ No se encontró 'gradlew' en /android, omitiendo paso."
  fi

  # 4. Limpieza general por nombre de proyecto
  log "🧹 Matando procesos residuales relacionados a 'Emerald'..."
  pgrep -f "Emerald" | xargs kill -9 2>/dev/null
  log "✅ Limpieza completada."
}

# --- FINALIZADOR PARA PROYECTO ZAFIRO (Flutter) ---
abort_zafiro() {
  log "🚨 Ejecutando rutina de limpieza para Zafiro (Flutter)..."

  # 1. Detener proceso de flutter run
  log "🔧 Terminando procesos 'flutter run', 'dart', 'flutter_tester'..."
  pkill -f "flutter run" >/dev/null 2>&1
  pkill -f "dart" >/dev/null 2>&1
  pkill -f "flutter_tester" >/dev/null 2>&1
  log "✅ Procesos relacionados eliminados (si existían)."

  # 2. Detener ADB si queda colgado
  log "🔧 Verificando procesos adb..."
  pkill -f "adb" >/dev/null 2>&1
  log "✅ ADB finalizado (si estaba activo)."

  # 3. Limpieza por nombre
  log "🧹 Matando procesos residuales relacionados a 'Zafiro'..."
  pgrep -f "Zafiro" | xargs kill -9 2>/dev/null
  log "✅ Limpieza completada."
}

# --- DESPACHADOR ---
case "$PROJECT_NAME" in
  "Emerald")
    abort_emerald
    ;;
  "Zafiro")
    abort_zafiro
    ;;
  *)
    log "⚠️ Proyecto '$PROJECT_NAME' no tiene una rutina de limpieza definida."
    ;;
esac

log "🧯 Finalización forzada de entorno completada."
