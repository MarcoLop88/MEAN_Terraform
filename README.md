# MEAN_Terraform


# 1. Preparación del Entorno e Instalación Global
Antes de iniciar con la gestión de los archivos de configuración, se realizó la instalación y registro global de las herramientas en el sistema operativo Windows 11.

## 1.1. Instalación y Registro de Terraform
Se descargó el ejecutable oficial terraform.exe y se ubicó en el directorio local C:\Terraform.
Se registró la ruta de forma permanente en las variables de entorno del usuario mediante: 
```powershell
[Environment]::SetEnvironmentVariable("Path", [Environment]::GetEnvironmentVariable("Path", "User") + ";C:\Terraform", "User")
```
Se verificó la correcta asignación global del binario:

```powershell
terraform –version
```
## 1.2. Instalación y Configuración de AWS CLI v2
Se ejecutó el instalador oficial MSI en modo silencioso desde la terminal:
```powershell
Start-Process msiexec.exe -ArgumentList '/i https://awscli.amazonaws.com/AWSCLIV2.msi /qn' -Wait
```
Se actualizaron las variables de la sesión activa de PowerShell para reconocer el comando aws:
```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```
Se realizó el aprovisionamiento de las llaves de acceso temporales proporcionadas por el laboratorio:
```powershell 
aws configure
AWS Access Key ID / Secret Access Key: [Credenciales de acceso asignadas]
Default region name: us-east-1
```
# 2.  Creación de la Estructura de Directorios del Proyecto

Para cumplir con las buenas prácticas de modularización de infraestructura como código (IaC), se ejecutó el siguiente script de PowerShell para limpiar intentos previos y estructurar el espacio de trabajo:

## Limpieza de seguridad del directorio de trabajo
```powershell
Remove-Item -Recurse -Force C:\\Proyecto-MEAN -ErrorAction SilentlyContinue
``` 
## Creación de la carpeta raíz y acceso a la misma
```powershell
mkdir C:\\Proyecto-MEAN
cd C:\\Proyecto-MEAN
```
## Creación de las carpetas correspondientes a los submódulos de la arquitectura
```powershell
mkdir modules\\vpc, modules\\security, modules\\compute, modules\\alb
```
## Generación de la estructura interna de archivos para cada módulo
```powershell
New-Item modules\\vpc\\main.tf, modules\\vpc\\variables.tf, modules\\vpc\\outputs.tf -ItemType File
New-Item modules\\security\\main.tf, modules\\security\\variables.tf, modules\\security\outputs.tf -ItemType File
New-Item modules\\compute\\main.tf, modules\\compute\\variables.tf, modules\\compute\\outputs.tf -ItemType File
New-Item modules\\alb\\main.tf, modules\\alb\\variables.tf, modules\\alb\\outputs.tf -ItemType File
``` 
# 3. Archivos de Configuración de Terraform (Código Limpio HCL)

```text
Proyecto-MEAN/
│
├── main.tf
├── outputs.tf
├── variables.tf
│
├── modules/
│   ├── alb/
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
│   ├── compute/
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
│   ├── security/
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
│   └── vpc/
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
│
└── README.md
```
# 4. Secuencia Operativa del Ciclo de Vida del Despliegue

Con los directorios y archivos, se ejecutaron los siguientes comandos secuenciales desde la raíz C:\Proyecto-MEAN:

## 4.1. Inicialización del entorno, descarga de módulos y proveedores de AWS
```powershell
terraform init
```
## 4.2 Validación de la sintaxis y relaciones de dependencias de los módulos
```powershell
terraform validate
```
## 4.3 Aplicación y construcción automatizada de los 25 recursos en la nube
```powershell
terraform apply --auto-approve
```
### Outputs Estructurados Obtenidos tras el Despliegue Exitoso
alb_dns_name: Registro DNS público generado por AWS para canalizar las peticiones HTTP externas.
 
mongodb_private_ip: Dirección de red local fija para la comunicación interna con la base de datos.
 
nat_gateway_public_ip: IP pública asociada al NAT Gateway, permitiendo la actualización de paquetes a los nodos privados de forma segura.
 
nodejs_private_ips: Direcciones IPs internas asignadas a las dos instancias EC2 de la app.
 
nodejs_public_ips: Bloques de datos vacíos "", lo que valida la correcta aplicación del diseño de seguridad perimetral (las instancias de aplicación carecen de interfaces públicas expuestas).


## 4.4 Desmantelamiento Seguro de Infraestructura (Control de Costos)
Se procedió con la destrucción de la arquitectura: 
```powershell
terraform destroy --auto-approve
```
Métrica final: Destroy complete! Resources: 25 destroyed.



