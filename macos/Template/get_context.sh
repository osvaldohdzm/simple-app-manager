#!/bin/zsh

# 1. Verificar si es un repositorio Git
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "❌ Este directorio no es un repositorio Git. Usa 'git init' primero."
  exit 1
fi

# 2. Definir rutas del proyecto
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_NAME=$(basename "$SCRIPT_DIR")
PROJECT_DIR="$SCRIPT_DIR"
SPECS_DIR="$(git rev-parse --show-toplevel)/specs"

# 3. Lista de carpetas
main_dirs=(Bugfix Chore Docs Features Hotfix Refactor Test UX-UI)

# 4. Crear estructura y prompts específicos por carpeta
for dir in "${main_dirs[@]}"; do
  mkdir -p "$SPECS_DIR/$dir"
  case $dir in
    Bugfix)
      cat <<'EOF' > "$SPECS_DIR/$dir/Prompt.md"
## Prompt para Bugfix

Actúa como un depurador experto. Tu tarea es detectar y corregir el bug o comportamiento defectuoso en el siguiente fragmento de código o sistema. No reescribas todo: **identifica exactamente la línea o bloque defectuoso y sugiere el cambio mínimo necesario para corregir el error sin afectar otras funcionalidades.** Explica brevemente la causa raíz del problema y por qué tu solución lo resuelve.

Usa esta estructura:

1. **Descripción breve del bug detectado**
2. **Causa raíz técnica**
3. **Línea(s) específica(s) que deben cambiarse**
4. **Código corregido (solo lo que cambia)**

No realices mejoras estilísticas ni refactors generales, a menos que sean estrictamente necesarios para corregir el bug.
EOF
      ;;
    Bugs)
      cat <<'EOF' > "$SPECS_DIR/$dir/Prompt.md"
## Prompt para Bugs

Genera una lista de posibles bugs con base en la descripción del comportamiento del sistema. Cada bug debe incluir una breve hipótesis de causa, su impacto potencial y cómo se podría confirmar con pruebas o logs.

Incluye:

- Componente afectado
- Comportamiento observado
- Posible causa
- Método de verificación
EOF
      ;;
    Chore)
      cat <<'EOF' > "$SPECS_DIR/$dir/Prompt.md"
## Prompt para Chore

Redacta tareas técnicas de mantenimiento o configuración del sistema que no estén directamente relacionadas con nuevas funcionalidades ni correcciones visibles. Pueden incluir limpieza de código, configuración de herramientas, actualización de dependencias, etc.

Usa este formato:

- Tarea: breve descripción
- Justificación: por qué es necesario
- Instrucciones o pasos clave
EOF
      ;;
    Docs)
      cat <<'EOF' > "$SPECS_DIR/$dir/Prompt.md"
## Prompt para Docs

Genera documentación técnica clara y concisa a partir de código o descripciones funcionales. Puedes usar formato Markdown para estructurar secciones como "Descripción", "Parámetros", "Ejemplo de uso" y "Notas adicionales".

Evita lenguaje ambiguo. Sé directo y útil para futuros desarrolladores.
EOF
      ;;
    Features)
      cat <<'EOF' > "$SPECS_DIR/$dir/Prompt.md"
Aplicar los cambios al código técnicos con alta precisión para agentes especializados, garantizando consistencia absoluta en UX/UI y arquitectura de aplicación.

**RESPONSABILIDADES CORE:**

- Analizar requerimientos técnicos complejos preservando design systems existentes
- Diseñar prompts estructurados que mantengan coherencia visual y funcional
- Incluir fragmentos de código, schemas y patrones que respeten la arquitectura actual
- Optimizar para máxima eficiencia sin comprometer la experiencia de usuario

**FORMATO DE SALIDA OBLIGATORIO:**

```
CONTEXTO: [Rol específico del agente + dominio técnico + estado actual de la aplicación]
OBJETIVO: [Meta técnica precisa + criterios de éxito medibles + requisitos de consistencia]
RESTRICCIONES: 
- Técnicas: [Limitaciones de arquitectura, recursos, APIs]
- UX/UI: [Design system, componentes existentes, patrones de interacción]
- Consistencia: [Guías de estilo, nomenclatura, flujos establecidos]
ESPECIFICACIONES:
- Input esperado: [Formato exacto + validaciones + contexto de UI actual]
- Output requerido: [Estructura + tipos de datos + componentes UI reutilizables]
- Dependencias: [APIs, librerías, servicios + design tokens/variables]
- Componentes existentes: [Lista de UI components a reutilizar]
IMPLEMENTACIÓN:
[Código/pseudocódigo/schemas que mantienen patrones establecidos]
CONSISTENCIA UI/UX:
- Componentes: [Reutilización obligatoria de elementos existentes]
- Patrones: [Flujos de navegación y interacción a preservar]
- Tokens: [Colores, tipografía, espaciado, iconografía]
- Estados: [Loading, error, success states consistentes]
```

**PRINCIPIOS DE OPTIMIZACIÓN:**

- Máxima especificidad técnica manteniendo coherencia visual
- Cero ambigüedad en instrucciones + preservación de patrones existentes
- Incluir manejo de edge cases sin romper flujos establecidos
- Proporcionar código que extienda componentes existentes
- Definir criterios de validación que incluyan consistency checks


Responde únicamente con el prompt optimizado. Sin preámbulos, explicaciones o texto adicional.

---

FEATURE A IMPLEMENTAR:
EOF
      ;;
    Hotfix)
      cat <<'EOF' > "$SPECS_DIR/$dir/Prompt.md"
## Prompt para Hotfix

Redacta un cambio urgente que solucione un error crítico en producción. Debe ser lo más mínimo y seguro posible, sin reestructurar el sistema.

Estructura:

- Descripción del fallo crítico
- Alcance del cambio
- Validaciones necesarias
- Plan de reversión en caso de falla
EOF
      ;;
    Refactor)
      cat <<'EOF' > "$SPECS_DIR/$dir/Prompt.md"
## Prompt para Refactor

Reformula una porción del código para mejorar su legibilidad, mantenibilidad o eficiencia **sin cambiar su comportamiento funcional**.

Incluye:

- Razón del refactor (mala práctica, duplicación, etc.)
- Principio de diseño aplicado (ej. DRY, KISS)
- Antes y después del código (solo el fragmento modificado)
EOF
      ;;
    Test)
      cat <<'EOF' > "$SPECS_DIR/$dir/Prompt.md"
## Prompt para Test

Genera casos de prueba automáticos para una función o módulo. Cada prueba debe:

- Cubrir entradas típicas y límites
- Incluir resultado esperado
- Usar lenguaje o framework de testing adecuado (ej. Jest, PyTest, etc.)

Indica también qué técnica de prueba se está aplicando (unitaria, integración, etc.).
EOF
      ;;
    UX-UI)
      cat <<'EOF' > "$SPECS_DIR/$dir/Prompt.md"
## Prompt para UX-UI

Describe una propuesta de mejora visual o de experiencia de usuario. Incluye:

- Pantalla o componente afectado
- Problema detectado (ergonomía, accesibilidad, estética)
- Solución propuesta (texto, layout, color, flujo)
- Referencia visual o ejemplo comparativo (si aplica)
EOF
      ;;
  esac
done

cat <<'EOF' > "$SPECS_DIR/UX-UI Suggestions.md"
## Prompt para UX-UI Suggestions

Analiza todo el código fuente disponible y detecta las funcionalidades actualmente implementadas (features).
Para cada feature existente, realiza lo siguiente:

Describe brevemente su propósito y cómo se implementa actualmente.

Evalúa su diseño, eficiencia, legibilidad y experiencia de uso desde una perspectiva de ingeniería de software moderna.

Propón al menos una mejora por feature. Las mejoras pueden ser:

- Refactorización del código para mayor claridad o eficiencia.
- Reemplazo de librerías obsoletas.
- Cambios en el flujo o experiencia del usuario (UX).
- Mejora en el manejo de errores o validaciones.
- Sugerencias de tests adicionales si los existentes son débiles.

Justifica cada propuesta de mejora con base en buenas prácticas, frameworks comunes o principios como SOLID, DRY, KISS o principios de accesibilidad.

✳️ Si una feature no necesita cambios importantes, indícalo brevemente con una justificación.

📌 Mantente enfocado solo en las funcionalidades que ya están presentes, sin proponer nuevas funcionalidades aún no existentes.

Usa como inspiración las imágenes y encuentra la manera de cómo implementar nuevas cosas y mejoras a partir de lo que veas en las imágenes, como una calculadora auxiliar en transacciones.
EOF

echo "✅ Carpetas y Prompt.md con contenido específico creados."

# Archivo de salida donde se guardará todo el código.
OUTPUT_FILE="$SPECS_DIR/code-context.txt"

# --- Exclusiones Dinámicas por Proyecto ---

echo "Seleccionando configuración de exclusión para el proyecto '$PROJECT_NAME'..."

case "$PROJECT_NAME" in
    "Emerald")
        echo "Usando configuración para 'Emerald'."
        # Directorios a excluir
        EXCLUDE_DIRS=(
            .git node_modules .expo .idea .vscode build dist
            android/.gradle android/app/build ios/Pods ios/build android/build
            coverage flow-typed temp tmp uploads notebook-renderer-react-sample
            scripts/uploads_server/venv311
        )
        # Archivos a excluir por nombre/patrón
        EXCLUDE_FILES=(
            "*.lock" "yarn.lock" "package-lock.json" "*.podspec" "README.md"
            "LICENSE" "code-context.txt" "app.json" "package.json"
            "metro.config.js" "tsconfig.json" "eslint.config.js" "babel.config.js"
            "jest.config.js" "prettier.config.js" "styled.d.ts" ".env*" "Gemfile"
            "Gemfile.lock" "Podfile.lock" "android/gradlew" "android/gradlew.bat"
            "android/gradle/wrapper/gradle-wrapper.jar" "android/app/debug.keystore"
            "android/app/proguard-rules.pro" "android/gradle.properties"
            "android/settings.gradle" "android/build.gradle" "android/app/build.gradle"
            "ios/*.xcodeproj" "ios/*.xcworkspace" "ios/*.xcscheme" "ios/Podfile"
            "ios/Cartfile" "ios/Cartfile.resolved"
        )
        # Extensiones a excluir
        EXCLUDE_EXTENSIONS=(
            jpg png jpeg gif svg webp ico mp4 mov avi mkv log zip tar gz
            otf ttf map db sqlite3 tab keystream bin md py html css xml
            bak tmp swp DS_Store pyc sh keystore jar exe egg
        )
        ;;

    "Zafiro")
        echo "Usando configuración optimizada para Flutter ('Zafiro')."
        
        # --- Directorios a excluir ---
        # Se excluyen carpetas de builds, cache, dependencias y configuraciones de IDE.
        EXCLUDE_DIRS=(
    # Estándar
    .git
    .idea
    .vscode
    build

    # Cache y dependencias de Dart/Flutter
    .dart_tool

    # Plataformas (compilados y dependencias)
    android/.gradle
    android/app/build
    ios/build
    ios/Pods
    ios/Runner.xcworkspace
    linux/build
    macos/build
    windows/build
    web/build

    # Archivos temporales generados por Flutter
    linux/flutter/ephemeral
    macos/Flutter/ephemeral
    windows/flutter/ephemeral

    # Directorios de assets que contienen binarios
    "*.xcassets"
)

# --- Archivos a excluir por nombre/patrón ---
EXCLUDE_FILES=(
    # Archivos de bloqueo de dependencias (NO incluir pubspec.lock)
    "Podfile.lock"
    "package-lock.json"
    "yarn.lock"
    "*.lock"
    "macos/Podfile"

    # Configuración local y de IDE
    "*.iml"
    ".DS_Store"
    "local.properties"
    "*.pbxuser"
    "*.xcscheme"

    # Scripts de wrapper
    "gradlew"
    "gradlew.bat"

    # Archivos generados por Flutter
    ".metadata"
    ".flutter-plugins"
    ".flutter-plugins-dependencies"
    "flutter_export_environment.sh"
    "generated_plugins.cmake"

    # Plugins autogenerados
    "GeneratedPluginRegistrant.java"
    "GeneratedPluginRegistrant.h"
    "GeneratedPluginRegistrant.m"
    "GeneratedPluginRegistrant.swift"
    "GeneratedPluginRegistrant.cc"

    # Bundles y recursos de Xcode
    "*.xcworkspace"
    "*.appiconset"
    "*.imageset"

    # Archivos propios a excluir
    "code-context.txt"

    # Documentación genérica no esencial
    "LICENSE"
    "README.md"
)

# --- Extensiones de archivo a excluir ---
EXCLUDE_EXTENSIONS=(
    # Imágenes y assets visuales
    png jpg jpeg gif webp ico svg

    # Fuentes
    ttf otf

    # Binarios, compilados y paquetes
    zip tar gz a so jar dll bin
    apk aar ipa app exe

    # Base de datos local
    db db-journal

    # Archivos de cache/build de plataformas nativas
    prof profm textproto storyboard xib arsc flat
    d dex dic

    # Configuración de entornos Apple/Xcode
    xcconfig plist entitlements pbxproj xcworkspacedata xcsettings

    # Configuración de proyectos multiplataforma
    cmake gradle properties

    # Archivos generados de JS/TS
    cjs mjs d.ts d.mts

    # Archivos de configuración general
    yaml yml json

    # Archivos no útiles para IA
    md txt

    # Scripts auxiliares
    sh py h gitignore cc cpp rc manifest js swift
)
        ;;

    *)
        echo "AVISO: No se encontró una configuración específica para '$PROJECT_NAME'."
        echo "Usando configuración por defecto (similar a 'Emerald')."
        # Configuración por defecto para cualquier otro proyecto
        EXCLUDE_DIRS=(.git node_modules build dist __pycache__ venv)
        EXCLUDE_FILES=("*.lock" "README.md" "LICENSE" "code-context.txt" ".env*")
        EXCLUDE_EXTENSIONS=(jpg png gif svg log zip gz map)
        ;;
esac

echo "El contexto completo del código se guardará en: $OUTPUT_FILE"

# --- Construcción Dinámica de Argumentos para 'find' ---

# 1. Construir argumentos para --prune (excluir directorios completos)
prune_args=()
if [ ${#EXCLUDE_DIRS[@]} -gt 0 ]; then
    for dir in "${EXCLUDE_DIRS[@]}"; do
        prune_args+=(-o -path "*/$dir")
    done
    prune_args=("${prune_args[@]:1}")
fi

# 2. Construir argumentos para archivos a excluir por nombre/patrón
name_args=()
if [ ${#EXCLUDE_FILES[@]} -gt 0 ]; then
    for file in "${EXCLUDE_FILES[@]}"; do
        name_args+=(-o -name "$file")
    done
    name_args=("${name_args[@]:1}")
fi

# 3. Construir argumentos para archivos a excluir por extensión
ext_args=()
if [ ${#EXCLUDE_EXTENSIONS[@]} -gt 0 ]; then
    for ext in "${EXCLUDE_EXTENSIONS[@]}"; do
        ext_args+=(-o -name "*.$ext")
    done
    ext_args=("${ext_args[@]:1}")
fi

# --- Procesamiento Principal ---

# Limpiar/crear el archivo de salida
echo "Generando contexto de código completo..."
echo "===== INICIO DEL CONTEXTO DEL CÓDIGO DEL PROYECTO: $PROJECT_NAME =====\n\n" > "$OUTPUT_FILE"

# Comando 'find' final
find "$PROJECT_DIR" \
    \( "${prune_args[@]}" \) -prune \
    -o \
    -type f \
    ! \( "${name_args[@]}" \) \
    ! \( "${ext_args[@]}" \) \
    -print0 |
while IFS= read -r -d $'\0' file; do
    if [ -s "$file" ]; then
        rel_path="${file#$PROJECT_DIR/}"
        echo "--- Fichero: $rel_path ---" >> "$OUTPUT_FILE"
        cat "$file" >> "$OUTPUT_FILE"
        printf "\n\n" >> "$OUTPUT_FILE"
    fi
done

echo "\n===== FIN DEL CONTEXTO DEL CÓDIGO DEL PROYECTO: $PROJECT_NAME =====" >> "$OUTPUT_FILE"
echo "¡Éxito! El contexto se ha escrito en $OUTPUT_FILE"

# --- Modo de operación ---
MODE="full"
if [ -n "$1" ]; then
  MODE="$1"
fi