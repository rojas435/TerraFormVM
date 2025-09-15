# Provisionar VM Linux en Azure con Terraform

Este proyecto crea una máquina virtual Ubuntu 22.04 LTS en Azure, accesible por **SSH con usuario y contraseña**, e inserta el contenido de `license.txt` dentro de la VM mediante cloud-init (en `/opt/license.txt`).

## Estructura
```
main.tf                  # Recursos principales
variables.tf             # Definición de variables
outputs.tf               # Salidas útiles (IP y comando SSH)
cloud-init.tpl           # Plantilla cloud-init para inicialización
license.txt              # Archivo de licencia (contenido embebido)
terraform.tfvars.example # Ejemplo de variables
.gitignore               # Ignora archivos sensibles/estado
README.md                # Este documento
```

## Prerrequisitos
- Azure Subscription (con ID válido)
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) instalada
- [Terraform >= 1.6](https://developer.hashicorp.com/terraform/downloads)
- Permisos para crear recursos (Resource Group, Networking, VM)

## Autenticación en Azure
Inicia sesión y selecciona suscripción:
```powershell
az login
az account set --subscription "<SUBSCRIPTION_ID>"
```
(El provider usará tus credenciales de Azure CLI.)

## Configurar variables
Copia el archivo de ejemplo:
```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
```
Edita `terraform.tfvars` y cambia:
- `subscription_id` si es diferente
- `vm_name` si deseas otro nombre base
- `admin_password` (debe cumplir políticas: mínimo 12 caracteres, mayúscula, minúscula, número y símbolo)
- (Opcional) `location`, `vm_size`

Coloca tu licencia real dentro de `license.txt` (reemplaza el texto placeholder).

## Inicializar y desplegar
```powershell
terraform init
terraform validate
terraform plan -out plan.tfplan
terraform apply plan.tfplan
```
Al finalizar verás salidas como:
```
public_ip = 20.x.x.x
ssh_command = ssh profesor@20.x.x.x
```

## Conectarse por SSH (Windows PowerShell)
Si tienes OpenSSH instalado:
```powershell
ssh profesor@$(terraform output -raw public_ip)
```
Ingresa la contraseña definida en `terraform.tfvars`.

## Verificar licencia dentro de la VM
Ya dentro de la VM:
```bash
cat /opt/license.txt
cat /opt/bienvenida.txt
```

## Destruir recursos
Cuando ya no necesites la infraestructura (evita costos):
```powershell
terraform destroy
```
Confirma con `yes`.

## Notas de seguridad
- No subas `terraform.tfvars` ni estados a repositorios públicos (ya está en `.gitignore`).
- La autenticación por contraseña está habilitada a propósito para el profesor; en producción se recomienda usar claves SSH.
- Puedes agregar una regla de seguridad más estricta limitando el origen de SSH (source_address_prefix) a tu IP pública.

## Personalizaciones rápidas
- Cambiar tamaño de VM: variable `vm_size` (ej: `Standard_B2s`)
- Cambiar paquetes iniciales: editar lista `packages:` en `cloud-init.tpl`
- Agregar scripts: añadir comandos a la sección `runcmd` en `cloud-init.tpl`

## Troubleshooting
- Error de contraseña: asegúrate de política válida (Azure rechaza contraseñas débiles).
- Timeout SSH: verifica que la IP pública esté disponible y que el NSG permita puerto 22.
- Cambios en cloud-init no aplican tras la primera creación: destruir la VM o cambiar el nombre para reprovisionar.

---
