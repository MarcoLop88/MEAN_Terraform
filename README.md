# MEAN_Terraform


# 1. Preparación del Entorno e Instalación Global
Antes de iniciar con la gestión de los archivos de configuración, se realizó la instalación y registro global de las herramientas en el sistema operativo Windows 11.
##1.1. Instalación y Registro de Terraform
Se descargó el ejecutable oficial terraform.exe y se ubicó en el directorio local C:\Terraform.
Se registró la ruta de forma permanente en las variables de entorno del usuario mediante: 
[Environment]::SetEnvironmentVariable("Path", [Environment]::GetEnvironmentVariable("Path", "User") + ";C:\Terraform", "User")
Se verificó la correcta asignación global del binario:
terraform –version
1.2. Instalación y Configuración de AWS CLI v2
Se ejecutó el instalador oficial MSI en modo silencioso desde la terminal:
