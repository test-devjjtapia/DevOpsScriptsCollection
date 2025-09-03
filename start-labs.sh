#!/bin/bash
echo "🚀 Iniciando y verificando las herramientas DevOps..."

./start-all-monitoring-updated.sh
#./jenkins-start.sh

rm check-homelab-fedora-v3.log
./check-homelab-fedora-v3.sh
