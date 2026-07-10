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





