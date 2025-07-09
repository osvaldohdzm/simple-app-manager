#!/bin/zsh

# --- CONFIGURACIÓN INICIAL ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(git rev-parse --show-toplevel)"
PROJECT_NAME=$(basename "$PROJECT_ROOT")

echo "🔍 Proyecto raíz detectado en: $PROJECT_ROOT"
echo "📦 Nombre del proyecto: $PROJECT_NAME"

# --- LOGGING COMÚN ---
init_logging() {
  LOG_DIR="$PROJECT_ROOT/logs"
  mkdir -p "$LOG_DIR"
  LOG_FILE="$LOG_DIR/deployment_$(date +%Y%m%d_%H%M%S).log"
}

log() {
  local icon="$1"; shift
  local msg="$*"
  local ts=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$ts] $icon $msg" | tee -a "$LOG_FILE"
}

log_info()     { log "ℹ️" "$@"; }
log_success()  { log "✅" "$@"; }
log_error()    { log "❌ ERROR:" "$@"; }
log_command()  { log "🔧 EJECUTANDO:" "$@"; }

# --- UTILIDAD COMÚN: DETECCIÓN DE DISPOSITIVO ADB ---
detect_adb_device() {
  local device_info=$(adb devices -l | sed -n '2p')
  if [ -z "$device_info" ]; then
    log_error "No se detectó ningún dispositivo Android conectado vía ADB."
    return 1
  fi
  DEVICE_ID=$(echo "$device_info" | awk '{print $1}')
  DEVICE_MODEL=$(echo "$device_info" | sed -nE 's/.*model:([^ ]+).*/\1/p')
  log_success "Dispositivo detectado: $DEVICE_ID (modelo: ${DEVICE_MODEL:-desconocido})"
  return 0
}

# --- FLUJO EMERALD ---
deploy_emerald() {
  init_logging
  log_info "🟢 Despliegue para Emerald iniciado"
  log_info "Log: $LOG_FILE"

  # Rebuscar raíz (por package.json)
  local current_dir="$PWD"
  while [ "$current_dir" != "/" ]; do
    if [ -f "$current_dir/package.json" ]; then
      PROJECT_ROOT="$current_dir"
      cd "$PROJECT_ROOT"
      log_success "Raíz del proyecto encontrada: $PROJECT_ROOT"
      break
    fi
    current_dir="$(dirname "$current_dir")"
  done

  if [ -z "$PROJECT_ROOT" ]; then
    log_error "No se encontró package.json"
    exit 1
  fi

  detect_adb_device || exit 1

  log_info "Instalando dependencias..."
  log_command "npm install"
  npm install 2>&1 | tee -a "$LOG_FILE" || {
    log_error "Falló la instalación de dependencias."
    exit 1
  }

  log_info "Limpiando directorio android..."
  log_command "rm -rf android"
  rm -rf android

  log_info "Ejecutando prebuild..."
  log_command "npx expo prebuild --platform android"
  npx expo prebuild --platform android 2>&1 | tee -a "$LOG_FILE" || {
    log_error "Error en prebuild."
    exit 1
  }

  log_info "Lanzando aplicación en dispositivo..."
  if [ -n "$DEVICE_MODEL" ]; then
    npx expo run:android --device "$DEVICE_MODEL" 2>&1 | tee -a "$LOG_FILE" || {
      log_error "Error al ejecutar la app."
      exit 1
    }
  else
    npx expo run:android 2>&1 | tee -a "$LOG_FILE" || {
      log_error "Error al ejecutar la app."
      exit 1
    }
  fi

  log_success "🎉 Despliegue completado para Emerald."
}

# --- FLUJO ZAFIRO ---
deploy_zafiro() {
  init_logging
  log_info "🔷 Despliegue para Zafiro iniciado"
  log_info "Log: $LOG_FILE"

  install_adb() {
    if ! command -v adb &>/dev/null; then
      echo "⚠️  ADB no encontrado. Instalando con Homebrew..."
      if ! command -v brew &>/dev/null; then
        echo "❌ Homebrew es necesario pero no está instalado."
        exit 1
      fi
      brew install android-platform-tools
    else
      echo "✅ ADB ya está instalado."
    fi
  }

  install_adb

  local device_line=$(adb devices | grep -w "device" | head -n 1)
  DEVICE_ID=$(echo "$device_line" | awk '{print $1}')

  if [ -z "$DEVICE_ID" ]; then
    echo "❌ No se encontró ningún dispositivo Android conectado."
    exit 1
  fi

  echo "✅ Dispositivo encontrado: $DEVICE_ID"

  echo "🧹 Limpiando proyecto..."
  ./scripts/clean.sh

  echo "📦 Instalando dependencias..."
  flutter pub get

  echo "🚀 Ejecutando aplicación en dispositivo..."
  flutter run -d "$DEVICE_ID"
}

# --- DESPACHADOR PRINCIPAL ---
case "$PROJECT_NAME" in
  "Emerald")
    deploy_emerald
    ;;
  "Zafiro")
    deploy_zafiro
    ;;
  *)
    echo "⚠️  Proyecto '$PROJECT_NAME' no tiene flujo definido."
    exit 1
    ;;
esac
