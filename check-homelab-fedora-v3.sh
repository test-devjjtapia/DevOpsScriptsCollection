#!/usr/bin/env bash

echo "=============================================="
echo "🔍 Verificación del Homelab Kubernetes en Fedora 42 - v3"
echo "=============================================="

# Colores y símbolos
ok="✅"
fail="❌"
warn="⚠️"

# Log a archivo
LOGFILE="check-homelab-fedora-v3.log"
exec > >(tee "$LOGFILE") 2>&1

# Funciones
check_cmd() {
    if command -v "$1" &>/dev/null; then
        echo -e "$ok $2 encontrado"
    else
        echo -e "$fail $2 NO está instalado o en PATH"
    fi
}

check_cmd_with_version() {
    if command -v "$1" &>/dev/null; then
        case "$1" in
            helm)
                version=$("$1" version --short 2>/dev/null | head -n1)
                ;;
            k9s)
                version=$("$1" version 2>/dev/null | head -n1)
                ;;
            trivy)
                version=$("$1" --version 2>/dev/null | grep -i version | head -n1)
                ;;
            az)
                version=$("$1" version | grep -i azure-cli | head -n1)
                ;;
            terraform)
                version=$("$1" version | head -n1)
                ;;
            *)
                version=$("$1" --version 2>/dev/null | head -n1)
                ;;
        esac
        echo -e "$ok $2 encontrado - $version"
    else
        echo -e "$fail $2 NO está instalado"
    fi
}

check_podman_container() {
    if podman ps --format "{{.Names}}" | grep -iq "$1"; then
        echo -e "$ok Contenedor '$1' está corriendo"
    else
        echo -e "$warn Contenedor '$1' no está corriendo"
    fi
}

check_podman_installed_and_active() {
    if ! command -v podman &>/dev/null; then
        echo -e "$fail Podman no instalado"
        return
    fi
    echo -e "$ok Podman instalado"

    if systemctl --user is-active podman.socket &>/dev/null; then
        echo -e "$ok podman.socket (modo rootless) está activo"
    else
        echo -e "$warn podman.socket no está activo (puedes activarlo con: systemctl --user enable --now podman.socket)"
    fi
}

check_kubectl_cluster() {
    if command -v kubectl &>/dev/null; then
        if kubectl cluster-info &>/dev/null; then
            echo -e "$ok Clúster Kubernetes activo"
            kubectl get nodes
        else
            echo -e "$warn Clúster Kubernetes no responde"
        fi
    else
        echo -e "$fail kubectl no instalado"
    fi
}

echo ""
echo "🔧 Herramientas base"
check_podman_installed_and_active
check_cmd_with_version buildah "Buildah"
check_cmd_with_version skopeo "Skopeo"
check_cmd_with_version helm "Helm"
check_cmd_with_version terraform "Terraform"
check_cmd_with_version az "Azure CLI"
check_cmd_with_version trivy "Trivy"
check_cmd_with_version k6 "k6 (carga)"
check_cmd_with_version k9s "K9s (CLI visual)"

# Lens: AppImage o binario GUI
if command -v lens &>/dev/null; then
    echo -e "$ok Lens (GUI) ejecutable encontrado"
elif [[ -f "$HOME/Downloads/Lens" || -f "$HOME/Apps/Lens" ]]; then
    echo -e "$warn Lens AppImage detectado pero no en PATH (verifica permisos de ejecución)"
else
    echo -e "$fail Lens (GUI) NO está instalado"
fi

check_cmd_with_version argocd "ArgoCD CLI"

# Jenkins CLI .jar detection
if [[ -f "$HOME/jenkins-cli.jar" || -f "./jenkins-cli.jar" ]]; then
    echo -e "$ok Jenkins CLI (archivo .jar) detectado"
else
    echo -e "$fail Jenkins CLI .jar NO encontrado (descargar desde tu instancia Jenkins)"
fi

check_cmd_with_version falco "Falco IDS"

echo ""
echo "📦 Contenedores activos"
for c in grafana influxdb prometheus jaeger jenkins; do
    check_podman_container "$c"
done

echo ""
echo "☁️ Kubernetes"
check_cmd minikube "Minikube"
check_cmd k3s "K3s (solo binario)"
check_kubectl_cluster

echo ""
echo "📁 Configuraciones esperadas"
[[ -f "$HOME/.kube/config" ]] && echo "$ok kubeconfig encontrado" || echo "$fail kubeconfig NO encontrado"
[[ -d "/var/lib/containers/storage" ]] && echo "$ok Almacenamiento local de contenedores OK" || echo "$fail Almacenamiento contenedores no hallado"

echo ""
echo "📋 Revisión terminada: revisa los ítems marcados como ❌ o ⚠️"
