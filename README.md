# MEAN_Terraform

Despliegue automatizado en AWS de la infraestructura para una aplicación **MEAN** (MongoDB, Express, Angular, Node.js) utilizando **Terraform** como herramienta de Infraestructura como Código (IaC).

El proyecto crea una arquitectura de tres capas con subredes públicas y privadas, un Application Load Balancer, instancias EC2 para la aplicación Node.js, una instancia para MongoDB y un NAT Gateway para permitir la salida a internet de los recursos privados sin exponerlos.

---
📖 **English version:** [README_en.md](README_en.md)
## Tabla de Contenidos

- [Arquitectura](#arquitectura)
- [Requisitos Previos](#requisitos-previos)
- [Instalación de Herramientas](#instalación-de-herramientas)
  - [Terraform](#terraform)
  - [AWS CLI v2](#aws-cli-v2)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Uso](#uso)
  - [1. Inicializar Terraform](#1-inicializar-terraform)
  - [2. Validar la Configuración](#2-validar-la-configuración)
  - [3. Desplegar la Infraestructura](#3-desplegar-la-infraestructura)
  - [4. Destruir la Infraestructura](#4-destruir-la-infraestructura)
- [Outputs](#outputs)
- [Notas de Seguridad](#notas-de-seguridad)
- [Licencia](#licencia)

---

## Arquitectura

La infraestructura se organiza en cuatro módulos independientes y reutilizables:

| Módulo | Responsabilidad |
|---|---|
| `vpc` | Red virtual, subredes públicas/privadas, tablas de rutas, Internet Gateway y NAT Gateway |
| `security` | Grupos de seguridad para ALB, instancias Node.js y MongoDB |
| `compute` | Instancias EC2 de Node.js (privadas) y MongoDB (privada) |
| `alb` | Application Load Balancer, listeners y target groups para distribuir tráfico HTTP hacia las instancias Node.js |

**Diseño de seguridad:** solo el ALB es accesible públicamente. Las instancias Node.js y MongoDB residen en subredes privadas sin IP pública, y acceden a internet (para actualizaciones de paquetes) únicamente a través del NAT Gateway.

---

## Requisitos Previos

- Cuenta de AWS con credenciales de acceso (Access Key ID / Secret Access Key)
- Windows 11 (las instrucciones usan PowerShell; en Linux/macOS los comandos de Terraform y AWS CLI son equivalentes)
- Permisos de administrador para modificar variables de entorno

---

## Instalación de Herramientas

### Terraform

1. Descargar el binario oficial `terraform.exe` desde [terraform.io/downloads](https://developer.hashicorp.com/terraform/downloads) y colocarlo en `C:\Terraform`.
2. Agregar la ruta de forma permanente a las variables de entorno del usuario:

   ```powershell
   [Environment]::SetEnvironmentVariable(
     "Path",
     [Environment]::GetEnvironmentVariable("Path", "User") + ";C:\Terraform",
     "User"
   )
   ```

3. Verificar la instalación (reiniciar la terminal antes de este paso):

   ```powershell
   terraform --version
   ```

### AWS CLI v2

1. Instalar el paquete oficial en modo silencioso:

   ```powershell
   Start-Process msiexec.exe -ArgumentList '/i https://awscli.amazonaws.com/AWSCLIV2.msi /qn' -Wait
   ```

2. Refrescar las variables de la sesión activa de PowerShell:

   ```powershell
   $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
               [System.Environment]::GetEnvironmentVariable("Path","User")
   ```

3. Configurar las credenciales de acceso:

   ```powershell
   aws configure
   ```

   Se solicitarán los siguientes datos:

   | Campo | Valor |
   |---|---|
   | AWS Access Key ID | *(tu credencial)* |
   | AWS Secret Access Key | *(tu credencial)* |
   | Default region name | `us-east-1` |
   | Default output format | `json` |

   > ⚠️ **Nunca** compartas ni subas tus credenciales a un repositorio. Ver la sección [Notas de Seguridad](#notas-de-seguridad).

---

## Estructura del Proyecto

```text
Proyecto-MEAN/
│
├── main.tf                  # Orquestación: invoca todos los módulos
├── variables.tf              # Variables globales del proyecto
├── outputs.tf                # Outputs consolidados del despliegue
│
├── modules/
│   ├── vpc/                  # Red, subredes, NAT Gateway
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security/              # Security Groups
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── compute/               # Instancias EC2 (Node.js y MongoDB)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── alb/                   # Application Load Balancer
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
└── README.md
```

Para crear esta estructura desde cero:

```powershell
mkdir C:\Proyecto-MEAN
cd C:\Proyecto-MEAN
mkdir modules\vpc, modules\security, modules\compute, modules\alb

New-Item modules\vpc\main.tf, modules\vpc\variables.tf, modules\vpc\outputs.tf -ItemType File
New-Item modules\security\main.tf, modules\security\variables.tf, modules\security\outputs.tf -ItemType File
New-Item modules\compute\main.tf, modules\compute\variables.tf, modules\compute\outputs.tf -ItemType File
New-Item modules\alb\main.tf, modules\alb\variables.tf, modules\alb\outputs.tf -ItemType File
```

---

## Uso

Todos los comandos se ejecutan desde la raíz del proyecto (`C:\Proyecto-MEAN`).

### 1. Inicializar Terraform

Descarga los proveedores y módulos necesarios:

```powershell
terraform init
```

### 2. Validar la Configuración

Comprueba la sintaxis y las dependencias entre módulos:

```powershell
terraform validate
```

### 3. Desplegar la Infraestructura

Crea los 25 recursos definidos en AWS:

```powershell
terraform apply --auto-approve
```

> 💡 Se recomienda ejecutar primero `terraform plan` para revisar los cambios antes de aplicarlos en un entorno real. La bandera `--auto-approve` se usa aquí por tratarse de un entorno de laboratorio.

### 4. Destruir la Infraestructura

Para evitar costos innecesarios, destruye todos los recursos al finalizar las pruebas:

```powershell
terraform destroy --auto-approve
```

Resultado esperado:

```text
Destroy complete! Resources: 25 destroyed.
```

---

## Outputs

Al finalizar `terraform apply`, se generan los siguientes outputs:

| Output | Descripción |
|---|---|
| `alb_dns_name` | Registro DNS público del Load Balancer, punto de entrada para las peticiones HTTP externas |
| `mongodb_private_ip` | IP privada fija de la instancia MongoDB, usada para la comunicación interna con la aplicación |
| `nat_gateway_public_ip` | IP pública del NAT Gateway, permite la salida a internet de los recursos en subredes privadas |
| `nodejs_private_ips` | IPs privadas de las dos instancias EC2 que ejecutan la aplicación Node.js |
| `nodejs_public_ips` | Vacío por diseño (`""`); confirma que las instancias de aplicación no tienen interfaz pública expuesta |

---

## Notas de Seguridad

- No incluyas credenciales de AWS directamente en archivos `.tf`; usa variables de entorno, `aws configure` o un gestor de secretos.
- Agrega un archivo `.gitignore` que excluya `*.tfstate`, `*.tfstate.backup`, `.terraform/` y cualquier archivo `*.tfvars` con datos sensibles.
- Las instancias Node.js y MongoDB permanecen sin IP pública como parte del diseño de defensa en profundidad; todo el tráfico externo debe pasar por el ALB.

---

## Licencia

Este proyecto se distribuye con fines educativos/de laboratorio. Ajusta esta sección según la licencia que desees aplicar (por ejemplo, MIT).
