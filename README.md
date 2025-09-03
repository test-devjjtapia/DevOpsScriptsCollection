# 🚀 Homelab DevOps Scripts Collection

Una colección completa de scripts para configurar y gestionar un laboratorio DevOps en Fedora 42 con Kubernetes, herramientas de monitoreo, y testing.

## 📋 Descripción

Este conjunto de scripts automatiza la configuración y gestión de un entorno de laboratorio DevOps completo que incluye:

- **Contenedores**: Podman, Buildah, Skopeo
- **Orquestación**: Kubernetes (K3s, Minikube), Helm
- **Monitoreo**: Grafana, InfluxDB, Prometheus, Jaeger
- **CI/CD**: Jenkins, ArgoCD
- **Análisis de código**: SonarQube
- **Testing**: K6, JMeter
- **Seguridad**: Trivy, Falco, ClamAV
- **Infraestructura**: Terraform, Azure CLI

## 📁 Estructura de Archivos

```
📦 homelab-scripts/
├── 📄 README.md                           # Este archivo
├── 🔧 Scripts principales
│   ├── start-labs.sh                      # Inicia todo el laboratorio
│   ├── stop-labs.sh                       # Detiene todo el laboratorio
│   ├── check-homelab-fedora-v3.sh         # Verificación completa del sistema
│   └── verify-homelab-functional2.sh      # Pruebas funcionales
├── 📊 Monitoreo
│   ├── start-all-monitoring-updated.sh    # Inicia stack de monitoreo
│   ├── stop-all-monitoring-updated.sh     # Detiene stack de monitoreo
│   └── prometheus.yml                     # Configuración de Prometheus
├── 🏗️ Jenkins
│   ├── jenkins-start.sh                   # Inicia Jenkins
│   └── jenkins-stop.sh                    # Detiene Jenkins
├── 🧪 Testing
│   ├── basic-test.js                      # Test básico K6
│   ├── test.js                           # Test adicional K6
│   └── run_jmeter.sh                     # Ejecutor de JMeter
```

## 🚀 Inicio Rápido

### 1. Descargar los Scripts

```bash
# Crear directorio de trabajo
mkdir -p ~/homelab-scripts
cd ~/homelab-scripts

# Descargar todos los archivos (ajusta las rutas según tu caso)
wget [URL_DE_LOS_SCRIPTS]
# O copia manualmente cada archivo desde el repositorio
```

### 2. Hacer los Scripts Ejecutables

```bash
chmod +x *.sh
```

### 3. Iniciar el Laboratorio Completo

```bash
# Inicia todos los servicios y verifica el estado
./start-labs.sh
```

### 4. Verificar el Estado

```bash
# Verificación completa del sistema
./check-homelab-fedora-v3.sh

# Pruebas funcionales
./verify-homelab-functional2.sh
```

## 🔧 Scripts Principales

### `start-labs.sh`
Script principal que:
- Inicia el stack de monitoreo completo
- Ejecuta verificaciones del sistema
- Genera logs de estado

### `stop-labs.sh`
Detiene todos los servicios del laboratorio de forma ordenada.

### `check-homelab-fedora-v3.sh`
Verificación exhaustiva que incluye:
- ✅ Herramientas base instaladas
- 🔍 Versiones de software
- 📦 Estado de contenedores
- ☸️ Conectividad de Kubernetes
- 📁 Configuraciones requeridas

### `verify-homelab-functional2.sh`
Pruebas funcionales para validar:
- Conectividad de servicios
- Puertos disponibles
- Funcionalidad básica de herramientas

## 📊 Stack de Monitoreo

El stack incluye los siguientes servicios:

| Servicio | Puerto | Credenciales | Descripción |
|----------|--------|--------------|-------------|
| **Grafana** | 3000 | admin/admin | Dashboards y visualizaciones |
| **InfluxDB** | 8086 | admin/admin123 | Base de datos de métricas |
| **Prometheus** | 9090 | - | Recolección de métricas |
| **Jaeger** | 16686 | - | Trazabilidad distribuida |
| **SonarQube** | 9000 | admin/admin | Análisis de calidad de código |

### Iniciar Solo Monitoreo

```bash
./start-all-monitoring-updated.sh
```

### Detener Solo Monitoreo

```bash
./stop-all-monitoring-updated.sh
```

## 🏗️ Jenkins

### Iniciar Jenkins

```bash
./jenkins-start.sh
```

Accede en: http://localhost:8080

### Detener Jenkins

```bash
./jenkins-stop.sh
```

## 🧪 Testing con K6

### Ejecutar Test Básico

```bash
# Test simple
k6 run basic-test.js

# Test con métricas a InfluxDB
k6 run basic-test.js --out influxdb=http://admin:secret-token@localhost:8086/k6?org=my-org
```

### JMeter

```bash
./run_jmeter.sh
```

## 📋 Requisitos Previos

### Sistema Operativo
- Fedora 42 (recomendado)
- Otras distribuciones compatibles con Podman

### Herramientas Requeridas
- Podman
- Buildah
- Skopeo
- kubectl
- Helm
- K3s o Minikube

### Instalación Automática de Dependencias

Los scripts incluyen sugerencias automáticas para instalar herramientas faltantes.

## 🔍 Verificación de Estado

### Log de Verificación
Los scripts generan logs automáticamente:
```bash
# Ver log de la última verificación
cat check-homelab-fedora-v3.log
```

### Símbolos de Estado
- ✅ Herramienta instalada y funcionando
- ❌ Herramienta no instalada o con problemas  
- ⚠️ Advertencia o configuración pendiente

## 📝 Configuración

### Prometheus
Edita `prometheus.yml` para agregar nuevos targets:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  # Agregar más servicios aquí
```

### Rutas Personalizadas
Modifica las rutas en los scripts según tu configuración:
- `/home/jjtapia/QA-Scripts/` → Tu directorio
- `/home/jjtapia/apache-jmeter-5.6.3/` → Tu instalación de JMeter

## 🚨 Solución de Problemas

### Permisos de Contenedores
```bash
# Si hay problemas con SELinux
sudo setsebool -P container_manage_cgroup on
```

### Pods que no Inician
```bash
# Verificar logs de Podman
podman logs <nombre-contenedor>

# Verificar puertos ocupados
ss -tlnp | grep <puerto>
```

### Problemas con Kubernetes
```bash
# Reiniciar K3s
sudo systemctl restart k3s

# Verificar estado
kubectl get nodes
kubectl get pods --all-namespaces
```

## 📚 Comandos Útiles

### Gestión de Contenedores
```bash
# Ver todos los contenedores
podman ps -a

# Ver volúmenes
podman volume ls

# Limpiar contenedores detenidos
podman container prune
```

### Kubernetes
```bash
# Estado del cluster
kubectl cluster-info

# Pods en todos los namespaces
kubectl get pods -A

# Recursos del sistema
kubectl top nodes
```

## 🤝 Contribuir

1. Fork el proyecto
2. Crea tu rama de características (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crea un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 📞 Soporte

Si encuentras problemas:

1. Revisa los logs generados por los scripts
2. Ejecuta `./verify-homelab-functional2.sh` para diagnóstico
3. Consulta la sección de solución de problemas
4. Abre un issue en el repositorio

## 🔄 Actualizaciones

Para mantener tu laboratorio actualizado:

```bash
# Detener servicios
./stop-labs.sh

# Actualizar imágenes de contenedores
podman images --format "{{.Repository}}:{{.Tag}}" | grep -v "<none>" | xargs -I {} podman pull {}

# Reiniciar servicios
./start-labs.sh
```

---

**¡Disfruta tu laboratorio DevOps! 🎉**
