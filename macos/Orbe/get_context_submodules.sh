#!/bin/bash

# Verificar que estamos en repositorio Git
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "❌ No es un repositorio Git. Ejecuta desde uno."
  exit 1
fi

PROJECT_DIR=$(git rev-parse --show-toplevel)
PROJECT_NAME=$(basename "$PROJECT_DIR")
OUTPUT_FILE="$PROJECT_DIR/specs/code-context.txt"
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Carpetas a excluir globalmente
EXCLUDE_DIRS=("tools" ".git" "build" ".dart_tool" ".idea" ".vscode" "android/.gradle" "ios/Pods" "specs")

# Archivos relevantes Dart + otros (fuera Clarise-Bot)
INCLUDE_EXTS_OUTSIDE_CLARISE=("dart" "js" "ts" "json" "yaml" "yml" "sh" "txt" "md" "html" "css")

# Archivos Python solo dentro de Clarise-Bot
INCLUDE_EXTS_CLARISE=("py")

echo "📦 Generando contexto del proyecto: $PROJECT_NAME"
echo "🧼 Excluyendo carpetas: ${EXCLUDE_DIRS[*]}"
echo "📁 Archivo destino: $OUTPUT_FILE"

# Vaciar archivo salida e imprimir encabezado
echo "===== CONTEXTO DEL PROYECTO: $PROJECT_NAME =====" > "$OUTPUT_FILE"

# Función para find con exclusiones
find_with_excludes() {
  local base_dir="$1"
  shift
  local exts=("$@")

  # Construir exclusiones find args para base_dir
  local find_exclude_args=()
  for d in "${EXCLUDE_DIRS[@]}"; do
    find_exclude_args+=( -path "$base_dir/$d" -prune -o )
  done

  # Construir expresión para extensiones
  local ext_expr=()
  for ext in "${exts[@]}"; do
    ext_expr+=( -iname "*.$ext" -o )
  done
  # Quitar último -o
  unset 'ext_expr[${#ext_expr[@]}-1]'

  # Ejecutar find
  find "$base_dir" "${find_exclude_args[@]}" -type f \( "${ext_expr[@]}" \) -print
}

# --- Primero: Archivos Python dentro Clarise-Bot solo ---
PY_FILES=$(find_with_excludes "$PROJECT_DIR/Clarise-Bot" "${INCLUDE_EXTS_CLARISE[@]}")

# --- Luego: Archivos Dart y otros fuera Clarise-Bot ---
# Pero excluyendo Clarise-Bot para evitar duplicados
OTHER_FILES=$(find_with_excludes "$PROJECT_DIR" "${INCLUDE_EXTS_OUTSIDE_CLARISE[@]}" | grep -v "^$PROJECT_DIR/Clarise-Bot/")

# Escribir contenido Python de Clarise-Bot
while IFS= read -r file; do
  echo -e "\n--- Archivo: ${file#$PROJECT_DIR/} ---" >> "$OUTPUT_FILE"
  cat "$file" >> "$OUTPUT_FILE"
done <<< "$PY_FILES"

# Escribir contenido Dart y otros fuera Clarise-Bot
while IFS= read -r file; do
  echo -e "\n--- Archivo: ${file#$PROJECT_DIR/} ---" >> "$OUTPUT_FILE"
  cat "$file" >> "$OUTPUT_FILE"
done <<< "$OTHER_FILES"

echo -e "\n===== FIN DEL CONTEXTO DEL PROYECTO: $PROJECT_NAME =====" >> "$OUTPUT_FILE"

echo "✅ Contexto generado en: $OUTPUT_FILE"
