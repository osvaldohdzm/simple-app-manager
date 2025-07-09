#!/bin/zsh
# Publish (subida de APK) para Emerald

RCLONE_REMOTE_NAME="gdrive"
APK_PATH="android/app/build/outputs/apk/release/app-release.apk"
TARGET_FILENAME="emerald-release.apk"
GDRIVE_FOLDER_PATH="Z Temporal/apks_releases"

if ! command -v rclone &>/dev/null; then
  echo "❌ Error: Comando 'rclone' no encontrado. Instálalo y configúralo primero."
  exit 1
fi

if [ ! -f "$APK_PATH" ]; then
  echo "❌ Error: No se encontró el APK en: $APK_PATH"
  exit 1
fi

echo "✅ APK encontrado: $(basename "$APK_PATH")"
TEMP_FILE="/tmp/$TARGET_FILENAME"
cp "$APK_PATH" "$TEMP_FILE"

DESTINATION_PATH="$RCLONE_REMOTE_NAME:$GDRIVE_FOLDER_PATH"
echo "🛰️  Subiendo a Google Drive como: $DESTINATION_PATH"
rclone copy "$TEMP_FILE" "$DESTINATION_PATH" -P

if [ $? -eq 0 ]; then
  echo "✅🎉 ¡Éxito! El archivo fue subido como '$TARGET_FILENAME'."
  rm -f "$TEMP_FILE"
else
  echo "❌ Error: Falló la subida con rclone."
fi 