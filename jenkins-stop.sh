#!/bin/bash
echo "🛑 Deteniendo Jenkins..."

if podman ps -a --format "{{.Names}}" | grep -q "^jenkins$"; then
  podman rm -f jenkins
  echo "✅ Jenkins detenido y eliminado"
else
  echo "ℹ️ Jenkins no se encuentra en ejecución"
fi
