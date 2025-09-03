#!/bin/bash
echo "🚀 Iniciando Jenkins en contenedor Podman..."

podman run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home:Z \
  docker.io/jenkins/jenkins:lts

echo "✅ Jenkins iniciado en http://localhost:8080"
