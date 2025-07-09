#!/bin/zsh
# Abort específico para Emerald (React Native)
echo "🚨 Ejecutando rutina de limpieza para Emerald (React Native / Expo)..."
METRO_PID=$(lsof -t -i:8081)
if [ -n "$METRO_PID" ]; then
  kill -9 "$METRO_PID"
  echo "✅ Proceso en 8081 terminado (PID: $METRO_PID)."
else
  echo "✅ No hay proceso activo en 8081."
fi
pkill -f "expo" >/dev/null 2>&1
pkill -f "metro" >/dev/null 2>&1
pkill -f "watchman" >/dev/null 2>&1
echo "✅ Procesos relacionados eliminados (si existían)."
if [ -f "$PROJECT_ROOT/android/gradlew" ]; then
  chmod +x "$PROJECT_ROOT/android/gradlew"
  "$PROJECT_ROOT/android/gradlew" --stop
  echo "✅ Gradle detenido correctamente."
else
  echo "⚠️ No se encontró 'gradlew' en /android, omitiendo paso."
fi
pgrep -f "Emerald" | xargs kill -9 2>/dev/null
echo "✅ Limpieza completada." 