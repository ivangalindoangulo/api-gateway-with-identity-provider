# 🚀 APISIX & Keycloak - Arquitectura de Seguridad y API Gateway

Este proyecto ilustra la integración de [Apache APISIX](https://apisix.apache.org/) como API Gateway con [Keycloak](https://www.keycloak.org/) para la gestión de identidad, autenticación y autorización (IAM).

El objetivo principal de este repositorio es servir como referencia arquitectónica para implementar patrones de seguridad perimetral (Zero Trust) en microservicios, utilizando herramientas de código abierto de nivel empresarial.

## 🛠️ Tecnologías Utilizadas

*   **[Apache APISIX](https://apisix.apache.org/):** API Gateway dinámico y de alto rendimiento nativo de la nube.
*   **[Keycloak](https://www.keycloak.org/):** Servidor de administración de acceso e identidad (IAM) de código abierto.
*   **[Docker & Docker Compose](https://www.docker.com/):** Orquestación y contenedorización de los servicios.
*   **[PostgreSQL](https://www.postgresql.org/):** Base de datos relacional para el almacenamiento persistente de Keycloak.
*   **Nginx:** Servidor web ligero utilizado para simular los microservicios de backend.
*   **Bash:** Scripting para la automatización segura del despliegue.

## 🔌 Plugins de APISIX Implementados

Para lograr esta integración y gestionar un enrutamiento seguro y dinámico, se han configurado los siguientes plugins del Gateway:

- **`openid-connect`**: Gestiona el flujo de autenticación delegando la validación de identidad a Keycloak.
- **`authz-keycloak`**: Administra la autorización validando roles, recursos y permisos definidos (RBAC/ABAC).
- **`proxy-rewrite`**: Reescribe las URIs de las peticiones en tiempo real para un enrutamiento transparente hacia el backend.
- **`response-rewrite`**: Manipula las cabeceras de respuesta (ej. deshabilitar la caché en respuestas autenticadas por motivos de seguridad).
- **`redirect`**: Redirecciona de forma inteligente las peticiones de la raíz hacia rutas de recursos específicos.
- **`serverless-pre-function`**: Ejecuta lógica personalizada (serverless) en fases tempranas, antes del procesamiento principal de la petición.

## 🏗️ Arquitectura del Sistema

!Demo Setup

![Demo Setup](./doc/images/Demo-Setup.jpg)

El entorno se orquesta completamente utilizando Docker Compose, estructurando la red en los siguientes componentes clave:

- `api-gateway-service`: Instancia de Apache APISIX que actúa como único punto de entrada.
- `iam-service` & `iam-db-service`: Servidor Keycloak respaldado por PostgreSQL.
- `resource-[one|two|three]-service`: Tres microservicios backend de prueba (páginas HTML servidas vía Nginx). Estos recursos simulan endpoints del mundo real como APIs REST, servicios de IA, bases de datos, fuertemente protegidos.

## 🚀 Guía de Despliegue (Quick Start)

### Requisitos Previos
- Docker y Docker Compose instalados en tu máquina. En entornos Windows, se recomienda usar Docker Desktop.
- Un entorno de terminal compatible con bash (Para Windows se aconseja Git Bash).
- ⚠️ **Importante:** Asegúrate de crear un archivo `.env` en la raíz del proyecto antes de ejecutar el entorno, de lo contrario la ejecución se detendrá por seguridad.

### Pasos para Ejecutar la Demo

1. Clona el repositorio y sitúate en la raíz del proyecto.
2. Ejecuta el script de inicialización automatizado:
   ```bash
   ./scripts/start.sh
   ```
3. Una vez que los contenedores estén levantados, acceder al servicio desde `http://localhost`.

> **🔐 Nota sobre el acceso:** 
> Notarás que inicialmente todo el acceso está bloqueado y denegado. Para permitir el flujo de datos, primero debes configurar en Keycloak un *Realm*, registrar un *Client*, y asignar *Roles*, *Usuarios* y *Permisos*. Puedes apoyarte en la Guía de Administración de Servidores de Keycloak.

## 📚 Referencias y Documentación Oficial

* **Apache APISIX**
  * [APISIX Official Documentation](https://apisix.apache.org/docs/)
  * [APISIX OpenID Connect Plugin](https://apisix.apache.org/docs/apisix/plugins/openid-connect/)
  * [APISIX Keycloak Authorization Plugin](https://apisix.apache.org/docs/apisix/plugins/authz-keycloak/)
  * [APISIX Plugins Priority](https://blog.frankel.ch/apisix-plugins-priority-leaky-abstraction/)
* **Keycloak**
  * [Keycloak Official Documentation](https://www.keycloak.org/documentation)
  * [Keycloak Server Administration Guide](https://www.keycloak.org/docs/latest/server_admin/index.html)
  * [Keycloak Authorization Services Guide](https://www.keycloak.org/docs/latest/authorization_services/index.html)

---
*Si este proyecto te ha sido útil, no olvides darle una estrella ⭐ al repositorio.*
