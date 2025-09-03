#!/bin/bash

echo "🔍 Verificando funcionalidad del Homelab DevOps..."
echo "--------------------------------------------------"

check_tool() {
    local name=$1
    local test_cmd=$2
    local fix_msg=$3

    echo -n "[🔧] $name: "
    if eval "$test_cmd" &> /dev/null; then
        echo "✅ OK"
    else
        echo "❌ Falla"
        echo "    ➤ Solución sugerida: $fix_msg"
    fi
}

check_tool "Podman" "podman run --rm alpine echo ok | grep -q ok" "Instala con: sudo dnf install -y podman"
check_tool "Buildah" "buildah from scratch &> /dev/null" "Instala con: sudo dnf install -y buildah"
check_tool "Skopeo" "skopeo inspect docker://docker.io/library/nginx | grep -q 'docker.io/library/nginx'" "Instala con: sudo dnf install -y skopeo"
check_tool "Helm" "helm version &> /dev/null" "Instala con: curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash"
check_tool "kubectl" "kubectl version --client &> /dev/null" "Instala con: sudo dnf install -y kubectl"
check_tool "K3s cluster" "kubectl get nodes &> /dev/null" "Reinicia K3s o verifica si está activo: systemctl status k3s"
check_tool "Trivy" "trivy image alpine | grep -q 'alpine'" "Instala con: sudo dnf install -y trivy"
check_tool "Grafana (puerto)" "curl -sI http://localhost:3000 | grep -q '200 OK'" "Verifica si el contenedor está corriendo y usa el puerto 3000"
check_tool "InfluxDB (puerto)" "curl -sI http://localhost:8086 | grep -q '200 OK'" "Verifica si el contenedor está corriendo y usa el puerto 8086"
check_tool "SonarQube (puerto)" "curl -sI http://localhost:9000 | grep -q '200 OK'" "Verifica si el contenedor está corriendo y usa el puerto 9000"
check_tool "K6" "echo 'import http from "k6/http"; export default function () { http.get("http://test.k6.io"); }' | k6 run -q - > /dev/null" "Instala con: sudo dnf install -y k6"
check_tool "ClamAV" "clamscan --version &> /dev/null" "Instala con: sudo dnf install -y clamav && sudo freshclam"
check_tool "Anaconda" "command -v conda &> /dev/null" "Verifica si Anaconda está instalado o exporta el PATH correctamente"

echo "--------------------------------------------------"
echo "🧪 Verificación finalizada."

check_tool "Terraform" "terraform version &> /dev/null" "Instala con: sudo dnf install -y dnf-plugins-core && sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo && sudo dnf install -y terraform"
check_tool "Minikube" "minikube version &> /dev/null" "Instala con: curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm && sudo rpm -Uvh minikube-latest.x86_64.rpm"
check_tool "crictl" "crictl --version &> /dev/null" "Instala con: VERSION='v1.30.0' && curl -LO https://github.com/kubernetes-sigs/cri-tools/releases/download/${VERSION}/crictl-${VERSION}-linux-amd64.tar.gz && sudo tar -C /usr/local/bin -xzvf crictl-${VERSION}-linux-amd64.tar.gz"
check_tool "VS Code CLI (code)" "command -v code &> /dev/null" "Abre Visual Studio Code, presiona Ctrl+Shift+P y ejecuta: Shell Command: Install 'code' command in PATH"
