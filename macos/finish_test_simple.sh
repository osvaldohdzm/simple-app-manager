#!/bin/bash

# --- SCRIPT DE TERMINACIÓN FORZADA (KILL SWITCH) ---
# Nombre: finish_test_simple.sh
#
# Objetivo: Forzar el cierre de TODOS los procesos asociados con la ejecución
#           de pruebas E2E de Expo/React Native que se han quedado colgados.
#
# Uso:
# 1. Si tu prueba está atascada en una terminal, déjala como está.
# 2. Abre una NUEVA terminal.
# 3. Navega a la raíz de tu proyecto (ej: cd ~/Desktop/Emerald).
# 4. Ejecuta este script: ./finish_test_simple.sh

echo "--- 🚨 INTERRUPTOR DE EMERGENCIA ACTIVADO 🚨 ---"
echo "Forzando la terminación de todos los procesos de la prueba..."
echo ""

# 1. Matar el Metro Bundler por su puerto (8081 es el default)
#    lsof -t -i:8081 devuelve solo el PID del proceso que usa ese puerto.
echo "[1/4] Buscando y matando proceso en el puerto 8081 (Metro Bundler)..."
METRO_PID=$(lsof -t -i:8081)
if [ -n "$METRO_PID" ]; then
    echo "   ↳ 🛑 Encontrado Metro Bundler con PID $METRO_PID. Terminando por la fuerza (kill -9)..."
    kill -9 "$METRO_PID"
    echo "   ↳ ✅ Proceso en puerto 8081 terminado."
else
    echo "   ↳ ✅ No se encontró ningún proceso en el puerto 8081."
fi
echo ""

# 2. Usar pkill para matar procesos por el nombre en su línea de comando.
#    La bandera -f busca en toda la línea de comando, es muy efectivo.
echo "[2/4] Usando pkill para eliminar procesos de 'expo', 'metro' y 'watchman'..."
pkill -f "expo run:android"
pkill -f "metro"
pkill -f "watchman"
echo "   ↳ ✅ Comandos pkill ejecutados."
echo ""

# 3. Detener el daemon de Gradle.
#    El build de Android a menudo deja procesos de Gradle en segundo plano.
echo "[3/4] Intentando detener daemons de Gradle..."
if [ -f "./android/gradlew" ]; then
    # Nos aseguramos que tenga permisos de ejecución
    chmod +x ./android/gradlew
    ./android/gradlew --stop
    echo "   ↳ ✅ Comando './android/gradlew --stop' ejecutado."
else
    echo "   ↳ ⚠️ No se encontró './android/gradlew'. Asegúrate de ejecutar este script desde la raíz del proyecto."
fi
echo ""

# 4. Limpieza final: matar cualquier proceso relacionado con el proyecto "Emerald".
#    Esto es muy útil para atrapar cualquier proceso residual.
echo "[4/4] Limpieza final: Matando procesos residuales del directorio 'Emerald'..."
# pgrep busca PIDs que coincidan con el patrón, y xargs los pasa a kill -9.
# Redirigimos la salida de error para no mostrar mensajes si no encuentra nada.
pgrep -f "Emerald" | xargs kill -9 >/dev/null 2>&1
echo "   ↳ ✅ Búsqueda y eliminación de procesos residuales completada."
echo ""

echo "--- ✅ PROCESO DE TERMINACIÓN FORZADA COMPLETADO ---"
echo "Revisa la terminal original. Los procesos deberían haberse detenido."