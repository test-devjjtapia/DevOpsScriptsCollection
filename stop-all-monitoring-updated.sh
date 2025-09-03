#!/bin/bash

echo "🛑 Deteniendo stack de monitoreo: Grafana + InfluxDB + Prometheus"

# Función para detener un contenedor si existe
stop_container() {
  NAME=$1
  if podman ps -a --format "{{.Names}}" | grep -q "^$NAME$"; then
    echo "🗑️ Eliminando contenedor $NAME..."
    podman rm -f $NAME
  else
    echo "ℹ️ Contenedor $NAME no está en ejecución."
  fi
}

# Detener contenedores
stop_container influxdb
stop_container grafana
stop_container prometheus
stop_container jaeger
stop_container sonarqube

echo ""
echo "📂 También siguen disponibles:"
echo "   - sonarqube-data"

echo ""
echo "✅ Todos los contenedores fueron detenidos y eliminados."
echo "📂 Los volúmenes persistentes siguen disponibles:"
echo "   - grafana-data"
echo "   - influxdb2-data"
echo "   - prometheus-data"

stop_container jaeger
stop_container sonarqube

echo ""
echo "📂 También siguen disponibles:"
echo "   - sonarqube-data"

echo ""
echo "ℹ️ Usa './start-all-monitoring.sh' para reiniciar todo el stack."
