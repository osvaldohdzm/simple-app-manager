#!/bin/zsh
# Despliegue específico para Emerald (React Native)
init_logging() {
  LOG_DIR="$PROJECT_ROOT/logs"
  mkdir -p "$LOG_DIR"
  LOG_FILE="$LOG_DIR/deployment_$(date +%Y%m%d_%H%M%S).log"
}

log_info() { echo "[INFO] $*"; }
log_success() { echo "[SUCCESS] $*"; }
log_error() { echo "[ERROR] $*"; }
log_command() { echo "[CMD] $*"; }

init_logging
log_info "🟢 Despliegue para Emerald iniciado"
log_info "Log: $LOG_FILE"

# Buscar raíz por package.json
current_dir="$PWD"
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

log_info "Instalando dependencias..."
log_command "npm install"
npm install || { log_error "Falló la instalación de dependencias."; exit 1; }

log_info "Limpiando directorio android..."
log_command "rm -rf android"
rm -rf android

log_info "Ejecutando prebuild..."
log_command "npx expo prebuild --platform android"
npx expo prebuild --platform android || { log_error "Error en prebuild."; exit 1; }

log_info "Lanzando aplicación en dispositivo..."
npx expo run:android || { log_error "Error al ejecutar la app."; exit 1; }

log_success "🎉 Despliegue completado para Emerald." 