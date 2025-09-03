#!/bin/bash

echo "🚀 Iniciando stack de monitoreo: Grafana + InfluxDB + Prometheus"

# ====================
# InfluxDB
# ====================
echo "📦 Verificando volumen InfluxDB..."
podman volume inspect influxdb2-data >/dev/null 2>&1 || podman volume create influxdb2-data

echo "🟢 Iniciando InfluxDB..."
podman rm -f influxdb >/dev/null 2>&1
podman run -d \
  --name influxdb \
  -p 8086:8086 \
  -v influxdb2-data:/var/lib/influxdb2 \
  -e DOCKER_INFLUXDB_INIT_MODE=setup \
  -e DOCKER_INFLUXDB_INIT_USERNAME=admin \
  -e DOCKER_INFLUXDB_INIT_PASSWORD=admin123 \
  -e DOCKER_INFLUXDB_INIT_ORG=my-org \
  -e DOCKER_INFLUXDB_INIT_BUCKET=k6 \
  -e DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=secret-token \
  docker.io/influxdb:2.7

# ====================
# Grafana
# ====================
echo "📦 Verificando volumen Grafana..."
podman volume inspect grafana-data >/dev/null 2>&1 || podman volume create grafana-data

echo "🟢 Iniciando Grafana..."
podman rm -f grafana >/dev/null 2>&1
podman run -d \
  --name grafana \
  -p 3000:3000 \
  -v grafana-data:/var/lib/grafana \
  docker.io/grafana/grafana-oss

# ====================
# Prometheus
# ====================
echo "📦 Verificando volumen Prometheus..."
podman volume inspect prometheus-data >/dev/null 2>&1 || podman volume create prometheus-data

# Verificar archivo de configuración
if [ ! -f /home/jjtapia/QA-Scripts/prometheus.yml ]; then
  echo "❌ Archivo /home/jjtapia/QA-Scripts/prometheus.yml no encontrado. Abortando Prometheus."
else
  chmod 644 /home/jjtapia/QA-Scripts/prometheus.yml

  echo "🟢 Iniciando Prometheus..."
  podman rm -f prometheus >/dev/null 2>&1
  podman run -d \
    --name prometheus \
    -p 9090:9090 \
    -v prometheus-data:/prometheus \
    -v /home/jjtapia/QA-Scripts/prometheus.yml:/etc/prometheus/prometheus.yml:ro,z \
    --security-opt label=disable \
    docker.io/prom/prometheus
fi

# ====================
# Resumen
# ====================
sleep 3
echo ""
podman ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "✅ Grafana:     http://localhost:3000 (admin / admin)"
echo "✅ InfluxDB:    http://localhost:8086 (admin / admin123)"
echo "   Bucket:     k6"
echo "   Org:        my-org"
echo "   Token:      secret-token"
echo ""
echo "✅ Prometheus:  http://localhost:9090"
echo ""
echo "📊 Puedes enviar métricas desde k6 con:"
echo "   k6 run basic-test.js --out influxdb=http://admin:secret-token@localhost:8086/k6?org=my-org"
# ====================
# Jaeger
# ====================
echo "🟢 Iniciando Jaeger..."
podman rm -f jaeger >/dev/null 2>&1
podman run -d \
  --name jaeger \
  -e COLLECTOR_ZIPKIN_HTTP_PORT=9411 \
  -p 16686:16686 \
  -p 14268:14268 \
  -p 14250:14250 \
  -p 9411:9411 \
  docker.io/jaegertracing/all-in-one:1.55

# ====================
# SonarQube
# ====================
echo "📦 Verificando volumen SonarQube..."
podman volume inspect sonarqube-data >/dev/null 2>&1 || podman volume create sonarqube-data

echo "🟢 Iniciando SonarQube..."
podman rm -f sonarqube >/dev/null 2>&1
podman run -d \
  --name sonarqube \
  -p 9000:9000 \
  -v sonarqube-data:/opt/sonarqube/data \
  -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
  docker.io/sonarqube:community
