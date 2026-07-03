# 🚀 Plataforma de Despliegue GitOps y Orquestación Multinodo

Este proyecto demuestra habilidades avanzadas de ingeniería DevOps mediante el diseño e implementación de un ciclo de vida completo de entrega continua (CI/CD), automatización de infraestructura y orquestación de contenedores en alta disponibilidad, utilizando herramientas de código abierto.

## 🗺️ Arquitectura del Sistema

<img width="1314" height="1197" alt="ChatGPT Image 3 jul 2026, 13_35_56" src="https://github.com/user-attachments/assets/7ee5efc6-7e8b-4ab8-8633-32b7fed857c0" />

---

## 🛠️ Stack Tecnológico Utilizado

*   **Aplicación Base:** Python 3.11 con FastAPI y Uvicorn (servidor asíncrono).
*   **Contenedores:** Docker utilizando *Multi-stage builds* y principios de mínimos privilegios (ejecución sin root).
*   **Automatización CI/CD:** GitHub Actions conectado de forma segura a Docker Hub mediante *Repository Secrets*.
*   **Infraestructura como Código (IaC):** Terraform para el aprovisionamiento de Redes Virtuales (VCN) en Oracle Cloud Infrastructure (OCI).
*   **Gestión de Configuración:** Ansible mediante Playbooks YAML estructurados e idempotentes para la provisión de nodos Linux.
*   **Orquestación:** Clúster multinodo de Kubernetes (K3s/K3d) con políticas de *Rolling Update* y enrutamiento mediante *Ingress Controller*.

---

## 📂 Estructura del Repositorio

```text
├── .github/workflows/
│   └── ci-pipeline.yml     # Pipeline de automatización en GitHub Actions
├── ansible/
│   ├── inventory.ini       # Inventario de servidores objetivo
│   ├── preparar_nodos.yml  # Playbook de actualización y paquetería base
│   └── instalar_k3s.yml    # Playbook de instalación del runtime de Kubernetes
├── infraestructura/
│   ├── providers.tf        # Configuración del proveedor de Oracle Cloud
│   ├── network.tf          # Diseño de Red Virtual (VCN) y subredes públicas
│   └── compute.tf          # Planificación de instancias de cómputo en la nube
├── k8s/
│   ├── k8s-despliegue.yaml # Definición de Deployment (2 Replicas) y Service
│   └── k8s-ingress.yaml    # Configuración del Ingress Controller para tráfico web
├── Dockerfile              # Receta de empaquetado optimizada para Python
├── main.py                 # Código fuente de la API en Python (FastAPI)
├── requirements.txt        # Dependencias del proyecto Python
└── .gitignore              # Protección del repositorio contra binarios pesados
```

---

### 🚀 Guía de Despliegue y Ejecución (Cómo probar el proyecto)

Para validar el funcionamiento completo de este clúster multinodo y la aplicación en alta disponibilidad, sigue estos pasos estructurados en una máquina que disponga de **Docker** y **Git** instalados:

#### 1. Preparación del Entorno
*   **Instalar K3d**: Descarga e instala la herramienta oficial de K3d en el sistema para permitir la simulación del clúster sobre Docker.
*   **Instalar Kubectl**: Descarga e instala el binario oficial de `kubectl` para disponer del mando a distancia de administración de Kubernetes.

#### 2. Creación de la Infraestructura Local
Ejecuta el siguiente comando para instanciar el clúster (1 nodo maestro y 1 nodo trabajador) abriendo el túnel de tráfico hacia el puerto 80 del ordenador:
```bash
k3d cluster create mi-cluster --agents 1 -p "80:80@loadbalancer"
```

#### 3. Despliegue de los Manifiestos de Kubernetes
Desde la raíz del repositorio clonado, aplica de forma secuencial los planos declarativos de la aplicación y las reglas de enrutamiento del Ingress:
```bash
kubectl apply -f k8s/k8s-despliegue.yaml
kubectl apply -f k8s/k8s-ingress.yaml
```

#### 4. Verificación del Estado del Clúster
Asegúrate de que los servidores virtuales y las réplicas de la aplicación se han descargado correctamente desde Docker Hub [A] y se encuentran operativos:
```bash
# Comprobar que el nodo maestro y el agente están listos
kubectl get nodes

# Comprobar que las 2 réplicas (Pods) de Python están en estado 'Running'
kubectl get pods
```

#### 5. Validación del Servicio Web
Tras esperar unos 15 segundos a que los contenedores inicien, realiza una petición de tráfico HTTP para comprobar el balanceo de carga:
```bash
curl http://localhost
```
*Respuesta esperada:* `{"status":"funcionando","message":"¡Proyecto DevOps completado con éxito por Marcos!"}`

#### 🔄 6. Cómo actualizar la aplicación en producción (CI/CD)
Si realizas cualquier modificación en el código fuente (`main.py`), el flujo para actualizar el clúster en caliente sin caída de servicio es:
1. Sube tus cambios a GitHub mediante `git push origin main`. El pipeline de GitHub Actions compilará la nueva imagen y la subirá automáticamente a Docker Hub [A].
2. Una vez que el pipeline termine en verde, ordena a Kubernetes una actualización progresiva ejecutando:
```bash
kubectl rollout restart deployment/api-python-deployment
```

## 🔍 Habilidades Demostradas en este Proyecto

1.  **GitOps & CI/CD Avanzado:** Automatización total de la integración de software separando el código fuente del artefacto final compilado.
2.  **Idempotencia con Ansible:** Provisión de software asegurando que el estado del servidor final sea predecible sin importar cuántas veces se ejecute el Playbook.
3.  **Conceptos Clave de Redes:** Gestión de direccionamiento CIDR, tablas de enrutamiento, mapeo de puertos de contenedores y proxies inversos de capa 7 (Ingress).
4.  **Resiliencia y Alta Disponibilidad:** Orquestación en Kubernetes configurando autorreparación (*self-healing*) de contenedores y balanceo de carga nativo.
5.  **Resolución de Problemas (Troubleshooting):** Capacidad de adaptación técnica ante problemas de stock en la nube pública (*Out of Capacity*) migrando de forma ágil a entornos locales simulados mediante contenedores.

---
👨‍💻 **Desarrollado y mantenido por Marcos**
