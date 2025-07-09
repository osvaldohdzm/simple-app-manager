#!/bin/zsh

# --- CONFIGURACIÓN DE LOGGING ---
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/deployment_$(date +%Y%m%d_%H%M%S).log"

# Crear directorio de logs si no existe
mkdir -p "$LOG_DIR"

# Función para logging que muestra en terminal y guarda en archivo
log_message() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local message="[$timestamp] $1"
    echo "$message" | tee -a "$LOG_FILE"
}

# Función para logging de errores
log_error() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local message="[$timestamp] ❌ ERROR: $1"
    echo "$message" | tee -a "$LOG_FILE"
}

# Función para logging de éxito
log_success() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local message="[$timestamp] ✅ $1"
    echo "$message" | tee -a "$LOG_FILE"
}

# Función para logging de información
log_info() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local message="[$timestamp] ℹ️  $1"
    echo "$message" | tee -a "$LOG_FILE"
}

# Función para logging de comandos ejecutados
log_command() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local message="[$timestamp] 🔧 EJECUTANDO: $1"
    echo "$message" | tee -a "$LOG_FILE"
}

# Iniciar el log
log_message "🟢 Iniciando el proceso de despliegue para Emerald..."
log_info "Log file: $LOG_FILE"

# --- 0. CAMBIAR AL DIRECTORIO RAIZ DEL PROYECTO ---
# Buscar el directorio que contiene package.json
PROJECT_ROOT=""
CURRENT_DIR="$(pwd)"

log_info "Buscando directorio raíz del proyecto desde: $CURRENT_DIR"

# Buscar hacia arriba hasta encontrar package.json
while [ "$CURRENT_DIR" != "/" ]; do
    if [ -f "$CURRENT_DIR/package.json" ]; then
        PROJECT_ROOT="$CURRENT_DIR"
        break
    fi
    CURRENT_DIR="$(dirname "$CURRENT_DIR")"
done

if [ -z "$PROJECT_ROOT" ]; then
    log_error "No se pudo encontrar el directorio del proyecto (package.json no encontrado)"
    exit 1
fi

log_success "Directorio del proyecto encontrado: $PROJECT_ROOT"
log_command "cd \"$PROJECT_ROOT\""
cd "$PROJECT_ROOT"

# --- 1. DETECTAR DISPOSITIVO ADB CONECTADO ---
log_info "Detectando dispositivos Android conectados..."

DEVICE_INFO=$(adb devices -l | sed -n '2p')

if [ -z "$DEVICE_INFO" ]; then
    log_error "No se detectó ningún dispositivo Android conectado vía ADB."
    log_info "Comandos útiles para debugging:"
    log_info "  - adb devices"
    log_info "  - adb devices -l"
    log_info "  - Verificar que el dispositivo esté en modo desarrollador"
    log_info "  - Verificar que ADB esté habilitado en el dispositivo"
    exit 1
fi

DEVICE_ID=$(echo "$DEVICE_INFO" | awk '{print $1}')
DEVICE_MODEL=$(echo "$DEVICE_INFO" | sed -nE 's/.*model:([^ ]+).*/\1/p')

if [ -z "$DEVICE_MODEL" ]; then
    log_info "No se pudo obtener el modelo del dispositivo. Lanzando sin parámetro --device."
fi

log_success "Dispositivo detectado: $DEVICE_ID (modelo: $DEVICE_MODEL)"

# --- 2. INSTALAR DEPENDENCIAS ---
log_info "Instalando dependencias con 'npm install'..."
log_command "npm install"

if npm install 2>&1 | tee -a "$LOG_FILE"; then
    log_success "Dependencias instaladas correctamente."
else
    log_error "Falló la instalación de dependencias."
    log_info "Revisar el log completo para más detalles: $LOG_FILE"
    exit 1
fi

# --- 3. LIMPIAR DIRECTORIO ANDROID ---
log_info "Limpiando build anterior de Android..."
log_command "rm -rf android"

if rm -rf android 2>&1 | tee -a "$LOG_FILE"; then
    log_success "Directorio android limpiado correctamente."
else
    log_error "Error al limpiar el directorio android."
    log_info "Continuando de todas formas..."
fi

# --- 4. PREBUILD ---
log_info "Generando archivos nativos con 'expo prebuild'..."
log_command "npx expo prebuild --platform android"

if npx expo prebuild --platform android 2>&1 | tee -a "$LOG_FILE"; then
    log_success "Prebuild completado correctamente."
else
    log_error "Error en el prebuild."
    log_info "Revisar el log completo para más detalles: $LOG_FILE"
    exit 1
fi

# --- 5. EJECUTAR ---
log_info "Lanzando la aplicación en el dispositivo: $DEVICE_MODEL"

if [ -n "$DEVICE_MODEL" ]; then
    log_command "npx expo run:android --device \"$DEVICE_MODEL\""
    if npx expo run:android --device "$DEVICE_MODEL" 2>&1 | tee -a "$LOG_FILE"; then
        log_success "¡La aplicación debería estar ejecutándose en tu dispositivo!"
    else
        log_error "No se pudo lanzar la aplicación en el dispositivo."
        log_info "Verifica que esté desbloqueado y con los permisos ADB activos."
        log_info "Revisar el log completo para más detalles: $LOG_FILE"
        exit 1
    fi
else
    log_command "npx expo run:android"
    if npx expo run:android 2>&1 | tee -a "$LOG_FILE"; then
        log_success "¡La aplicación debería estar ejecutándose en tu dispositivo!"
    else
        log_error "No se pudo lanzar la aplicación en el dispositivo."
        log_info "Verifica que esté desbloqueado y con los permisos ADB activos."
        log_info "Revisar el log completo para más detalles: $LOG_FILE"
        exit 1
    fi
fi

log_message "🎉 Proceso de despliegue completado. Log guardado en: $LOG_FILE"
