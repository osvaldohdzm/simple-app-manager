#!/bin/zsh

# Título: Generador de Contexto de Código Relevante
# Propósito: Extrae únicamente el código fuente esencial de un proyecto,
#            ignorando dependencias, entornos virtuales y otros archivos irrelevantes.

# 1. Verificar si es un repositorio Git
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "❌ Este directorio no es un repositorio Git. Usa 'git init' primero."
  exit 1
fi

# 2. Definir rutas del proyecto de forma robusta
PROJECT_DIR="$(git rev-parse --show-toplevel)"
PROJECT_NAME=$(basename "$PROJECT_DIR")
OUTPUT_DIR="$PROJECT_DIR/specs"
OUTPUT_FILE="$OUTPUT_DIR/code-context.txt"

# Crear el directorio de salida si no existe
mkdir -p "$OUTPUT_DIR"

echo "🚀 Generando contexto de código relevante para el proyecto: $PROJECT_NAME"
echo "💾 El resultado se guardará en: $OUTPUT_FILE"

# 3. Directorios que se deben ignorar por completo
EXCLUDE_DIRS=(
    ".git"
    "venv"
    "node_modules"
    "__pycache__"
    "specs" # Excluir el propio directorio de salida
    "logs"
    "outputs"
    "backups"
    "gemini-lab/datos_de_usuario_playwright"
    "gemini-lab/node_modules"
    "gemini-lab/venv"
    "test-results"
    ".idea"
    ".vscode"
)

# 4. Patrones de archivo a INCLUIR (solo el código relevante)
INCLUDE_PATTERNS=(
    "*.py"
    "*.sh"
    "*.yaml"
    "*.yml"
    "requirements.txt"
    "README.md"
)

# --- Construcción de argumentos para el comando 'find' ---

# Argumentos para podar (prune) los directorios excluidos
prune_args=()
if [ ${#EXCLUDE_DIRS[@]} -gt 0 ]; then
    for dir in "${EXCLUDE_DIRS[@]}"; do
        prune_args+=(-o -path "*/$dir")
    done
    prune_args=("${prune_args[@]:1}") # Elimina el primer "-o"
fi

# Argumentos para incluir solo los patrones de archivo deseados
include_args=()
if [ ${#INCLUDE_PATTERNS[@]} -gt 0 ]; then
    for pattern in "${INCLUDE_PATTERNS[@]}"; do
        include_args+=(-o -name "$pattern")
    done
    include_args=("${include_args[@]:1}") # Elimina el primer "-o"
fi

# --- Procesamiento Principal ---

# Limpiar y preparar el archivo de salida
echo "===== INICIO DEL CONTEXTO DEL CÓDIGO DEL PROYECTO: $PROJECT_NAME =====\n\n" > "$OUTPUT_FILE"

# Comando 'find' optimizado:
# 1. Poda los directorios excluidos para mayor eficiencia.
# 2. Busca únicamente los archivos que coinciden con los patrones de inclusión.
find "$PROJECT_DIR" \
    \( "${prune_args[@]}" \) -prune \
    -o \
    \( "${include_args[@]}" \) -type f \
    -print0 |
while IFS= read -r -d $'\0' file; do
    # Asegurarse de que el archivo no esté vacío
    if [ -s "$file" ]; then
        rel_path="${file#$PROJECT_DIR/}"
        echo "--- Fichero: $rel_path ---" >> "$OUTPUT_FILE"
        cat "$file" >> "$OUTPUT_FILE"
        printf "\n\n" >> "$OUTPUT_FILE"
    fi
done

echo "\n===== FIN DEL CONTEXTO DEL CÓDIGO DEL PROYECTO: $PROJECT_NAME =====" >> "$OUTPUT_FILE"
echo "✅ ¡Éxito! El contexto con el código relevante se ha escrito en $OUTPUT_FILE"