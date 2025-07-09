#!/bin/zsh
# Abort específico para Orbe (Flutter)
echo "🚨 Ejecutando rutina de limpieza para Orbe (Flutter)..."
pkill -f "flutter run" >/dev/null 2>&1
pkill -f "dart" >/dev/null 2>&1
pkill -f "flutter_tester" >/dev/null 2>&1
echo "✅ Procesos relacionados eliminados (si existían)."
pkill -f "adb" >/dev/null 2>&1
echo "✅ ADB finalizado (si estaba activo)."
pgrep -f "Orbe" | xargs kill -9 2>/dev/null
echo "✅ Limpieza completada." 