#!/bin/zsh

# --- CONFIGURACIÓN GENERAL ---
REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT" || exit 1
PROJECT_NAME=$(basename "$REPO_ROOT")

RCLONE_REMOTE_NAME="gdrive"
GDRIVE_FOLDER_PATH="Z Temporal/apks_releases"

# --- LOG SIMPLE ---
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# --- SUBIDA PARA ZAFIRO (Flutter) ---
upload_zafiro() {
  log "🚀 Subiendo APK de Zafiro..."

  RELEASE_DIR="$REPO_ROOT/build/app/outputs/flutter-apk"
  TARGET_FILENAME="zafiro-release.apk"
  TEMP_FILE="/tmp/$TARGET_FILENAME"

  log "🔍 Buscando archivo .apk más reciente en: $RELEASE_DIR"
  LATEST_FILE=$(ls -t "$RELEASE_DIR"/*.apk 2>/dev/null | head -n 1)

  if [ -z "$LATEST_FILE" ]; then
    log "❌ Error: No se encontró ningún .apk en $RELEASE_DIR"
    exit 1
  fi

  log "✅ Archivo encontrado: $(basename "$LATEST_FILE")"
  cp "$LATEST_FILE" "$TEMP_FILE"

  log "🛰️  Subiendo a Google Drive como: $TARGET_FILENAME → $RCLONE_REMOTE_NAME:$GDRIVE_FOLDER_PATH"
  rclone copy "$TEMP_FILE" "$RCLONE_REMOTE_NAME:$GDRIVE_FOLDER_PATH" -P

  if [ $? -eq 0 ]; then
    log "✅🎉 Éxito: El archivo fue subido como '$TARGET_FILENAME'."
    rm -f "$TEMP_FILE"
  else
    log "❌ Error: Falló la subida con rclone."
  fi
}

# --- EJECUCIÓN DIRECTA SOLO PARA ZAFIRO ---
log "📁 Proyecto detectado: $PROJECT_NAME"
if [ "$PROJECT_NAME" = "Zafiro" ]; then
  upload_zafiro
else
  log "⚠️ Este script solo está configurado para el proyecto Zafiro."
fi
