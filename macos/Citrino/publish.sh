#!/bin/bash

echo "DEBUG: \$0 = $0"
echo "DEBUG: dirname \$0 = $(dirname "$0")"
PROJECT_DIR="$(cd "$(dirname "$0")/../../../.." && pwd)"
echo "DEBUG: PROJECT_DIR = $PROJECT_DIR"

# ==============================================================================
#  Script Genérico para Subir el ÚLTIMO Release a Google Drive usando rclone
#
#  Este script detecta automáticamente el nombre del proyecto desde pubspec.yaml,
#  encuentra el archivo de release (.apk) más reciente en la carpeta de build,
#  lo renombra como '[nombre-proyecto]-release.apk' y lo sube a Google Drive.
# ==============================================================================

# --- Configuración ---

# 1. Nombre del "remote" de rclone para tu Google Drive.
RCLONE_REMOTE_NAME="gdrive"

# 2. Carpeta de destino en Google Drive (vacío = raíz "Mi unidad").
GDRIVE_FOLDER_PATH="Z Temporal/apks_releases"

# --- Detección Automática del Proyecto ---

echo "📁 Directorio del proyecto: $PROJECT_DIR"

# Leer el nombre del proyecto desde pubspec.yaml
if [ -f "$PROJECT_DIR/pubspec.yaml" ]; then
    PROJECT_NAME=$(grep "^name:" "$PROJECT_DIR/pubspec.yaml" | sed 's/name: *//' | tr -d ' ')
    echo "📱 Nombre del proyecto detectado: $PROJECT_NAME"
else
    echo "❌ Error: No se encontró pubspec.yaml en el directorio del proyecto."
    exit 1
fi

# Carpeta local donde se generan los archivos de release
RELEASE_SEARCH_DIR="$PROJECT_DIR/build/app/outputs/flutter-apk/"

# --- Lógica del Script ---

echo "🚀 Iniciando proceso de subida a Google Drive..."
echo "-------------------------------------------------"

# 1. Verificar si 'rclone' está instalado
if ! command -v rclone &> /dev/null; then
    echo "❌ Error: Comando 'rclone' no encontrado. Instálalo y configúralo primero."
    exit 1
fi

# 2. Verificar que existe el directorio de builds
if [ ! -d "$RELEASE_SEARCH_DIR" ]; then
    echo "❌ Error: No se encontró el directorio de builds."
    echo "   Ruta esperada: $RELEASE_SEARCH_DIR"
    echo "   Ejecuta 'flutter build apk' primero para generar el archivo de release."
    exit 1
fi

# 3. Encontrar el archivo .apk más reciente
echo "🔍 Buscando el archivo de release más reciente en: $RELEASE_SEARCH_DIR"
LATEST_FILE=$(ls -t "${RELEASE_SEARCH_DIR}"*.apk 2>/dev/null | head -n 1)

if [ -z "$LATEST_FILE" ]; then
    echo "❌ Error: No se encontró ningún archivo .apk en el directorio especificado."
    echo "   Ruta de búsqueda: ${RELEASE_SEARCH_DIR}"
    echo "   Ejecuta 'flutter build apk' primero para generar el archivo de release."
    exit 1
fi

# 4. Mostrar archivo encontrado
FILENAME=$(basename "$LATEST_FILE")
echo "✅ Archivo encontrado: $FILENAME"

# 5. Crear archivo temporal renombrado como [nombre-proyecto]-release.apk
TEMP_FILE="/tmp/${PROJECT_NAME}-release.apk"
cp "$LATEST_FILE" "$TEMP_FILE"

echo ""
echo "ℹ️  Información de la subida:"
echo "    - Proyecto: $PROJECT_NAME"
echo "    - Archivo original: $FILENAME"
echo "    - Archivo temporal: ${PROJECT_NAME}-release.apk"
echo "    - Destino en Drive: $RCLONE_REMOTE_NAME:/$GDRIVE_FOLDER_PATH"
echo ""

# 6. Subir archivo renombrado a Google Drive
echo "🛰️  Subiendo archivo a Google Drive como '${PROJECT_NAME}-release.apk'..."
rclone copy "$TEMP_FILE" "$RCLONE_REMOTE_NAME:$GDRIVE_FOLDER_PATH" -P

# 7. Verificar resultado y limpiar
if [ $? -eq 0 ]; then
    echo "-------------------------------------------------"
    echo "✅🎉 ¡Éxito! El archivo fue subido correctamente como '${PROJECT_NAME}-release.apk'."
    rm -f "$TEMP_FILE"
    echo "📁 Ubicación en Google Drive: $GDRIVE_FOLDER_PATH/${PROJECT_NAME}-release.apk"
else
    echo "-------------------------------------------------"
    echo "❌ Error: Falló la subida con rclone."
    echo "   Revisa el mensaje de error anterior para más detalles."
    rm -f "$TEMP_FILE"
fi