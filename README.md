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

### 🔐 Configuración de Keycloak (Paso a Paso)

Notarás que inicialmente todo el acceso está bloqueado por defecto. Para permitir el flujo de peticiones, debes configurar Keycloak accediendo a `http://localhost:8080` (Credenciales por defecto: `admin` / `admin`):

1. **Crear un Realm**:
   - En el panel izquierdo, despliega el menú de Realms y haz clic en **Create Realm**. Nómbralo (`demo`).
2. **Crear un Client**:
   - Ve a **Clients** -> **Create client**.
   - Asigna un *Client ID* (`demo-apisix`).
   - En *Capability config*, es crucial que actives **Client authentication** y **Authorization**.
   - En *Valid redirect URIs* especifica tu host `http://localhost/*`
3. **Crear Roles**:
   - Ve a **Realm roles** -> **Create role**. Crea los roles necesarios para tu lógica de negocio (`user`, `admin`).
4. **Crear Usuarios**:
   - Ve a **Users** -> **Add user**.
   - En la pestaña *Credentials*, asígnale una contraseña.
   - En la pestaña *Role mapping*, asígnale los roles creados en el paso anterior.
5. **Configurar Autorización (Resources y Permissions)**:
   - Vuelve a tu **Client** y entra en la pestaña **Authorization**.
   - **Resources**: Define los endpoints de tu API que deseas proteger (`/resource-one`, `/resource-two`, `/resource-three`).
   - **Policies**: En la pestaña de políticas, crea una política basada en roles (*Role-based policy*) y asóciala a los roles del paso 3.
   - **Permissions**: Finalmente, crea un permiso basado en recursos (*Resource-based permission*) que vincule tus *Resources* con tus *Policies*.

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
