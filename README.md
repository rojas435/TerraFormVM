# Terraform Azure VM Project - Modular DevOps Architecture# Provisionar VM Linux en Azure con Terraform



Este proyecto implementa una arquitectura modular de Terraform siguiendo las mejores prácticas de DevOps para el despliegue de máquinas virtuales en Azure. La estructura está diseñada para ser escalable, mantenible y reutilizable.Este proyecto crea una máquina virtual Ubuntu 22.04 LTS en Azure, accesible por **SSH con usuario y contraseña**, e inserta el contenido de `license.txt` dentro de la VM mediante cloud-init (en `/opt/license.txt`).



## 🏗️ Arquitectura del Proyecto## Estructura

```

```main.tf                  # Recursos principales

TerraformVm/variables.tf             # Definición de variables

├── .github/outputs.tf               # Salidas útiles (IP y comando SSH)

│   └── workflows/cloud-init.tpl           # Plantilla cloud-init para inicialización

│       └── terraform.yml                    # CI/CD Pipelinelicense.txt              # Archivo de licencia (contenido embebido)

├── environments/                            # Configuraciones por ambienteterraform.tfvars.example # Ejemplo de variables

│   ├── dev/.gitignore               # Ignora archivos sensibles/estado

│   │   ├── main.tfREADME.md                # Este documento

│   │   ├── variables.tf```

│   │   ├── outputs.tf

│   │   └── terraform.tfvars.example## Prerrequisitos

│   ├── staging/- Azure Subscription (con ID válido)

│   │   ├── main.tf- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) instalada

│   │   ├── variables.tf- [Terraform >= 1.6](https://developer.hashicorp.com/terraform/downloads)

│   │   ├── outputs.tf- Permisos para crear recursos (Resource Group, Networking, VM)

│   │   └── terraform.tfvars.example

│   └── production/## Autenticación en Azure

│       ├── main.tfInicia sesión y selecciona suscripción:

│       ├── variables.tf```powershell

│       ├── outputs.tfaz login

│       └── terraform.tfvars.exampleaz account set --subscription "<SUBSCRIPTION_ID>"

├── modules/                                 # Módulos reutilizables```

│   ├── networking/(El provider usará tus credenciales de Azure CLI.)

│   │   ├── main.tf

│   │   ├── variables.tf## Configurar variables

│   │   └── outputs.tfCopia el archivo de ejemplo:

│   ├── compute/```powershell

│   │   ├── main.tfCopy-Item terraform.tfvars.example terraform.tfvars

│   │   ├── variables.tf```

│   │   └── outputs.tfEdita `terraform.tfvars` y cambia:

│   └── security/- `subscription_id` si es diferente

│       ├── main.tf- `vm_name` si deseas otro nombre base

│       ├── variables.tf- `admin_password` (debe cumplir políticas: mínimo 12 caracteres, mayúscula, minúscula, número y símbolo)

│       └── outputs.tf- (Opcional) `location`, `vm_size`

├── shared/                                  # Recursos compartidos

│   ├── templates/Coloca tu licencia real dentro de `license.txt` (reemplaza el texto placeholder).

│   │   ├── cloud-init.tpl

│   │   └── license.txt## Inicializar y desplegar

│   └── locals/```powershell

│       └── common.tfterraform init

├── scripts/terraform validate

│   └── terraform.ps1                        # Script de automatizaciónterraform plan -out plan.tfplan

├── .gitignoreterraform apply plan.tfplan

├── .pre-commit-config.yaml```

├── Makefile                                 # Automatización Unix/LinuxAl finalizar verás salidas como:

└── README.md```

```public_ip = 20.x.x.x

ssh_command = ssh profesor@20.x.x.x

## 🚀 Características Principales```



### ✅ Arquitectura Modular## Conectarse por SSH (Windows PowerShell)

- **Módulos reutilizables**: Networking, Compute, Security separadosSi tienes OpenSSH instalado:

- **Configuraciones por ambiente**: Dev, Staging, Production```powershell

- **Recursos compartidos**: Templates y configuraciones comunesssh profesor@$(terraform output -raw public_ip)

- **Separación de responsabilidades**: Cada módulo maneja un aspecto específico```

Ingresa la contraseña definida en `terraform.tfvars`.

### ✅ Gestión de Ambientes

- **Desarrollo**: Configuración permisiva para pruebas rápidas## Verificar licencia dentro de la VM

- **Staging**: Configuración intermedia para validaciónYa dentro de la VM:

- **Producción**: Configuración segura y optimizada```bash

cat /opt/license.txt

### ✅ Automatización DevOpscat /opt/bienvenida.txt

- **GitHub Actions**: Pipeline CI/CD automatizado```

- **Scripts PowerShell**: Automatización local para Windows

- **Makefile**: Automatización para Unix/Linux## Destruir recursos

- **Pre-commit hooks**: Validación automática de códigoCuando ya no necesites la infraestructura (evita costos):

```powershell

### ✅ Seguridadterraform destroy

- **Network Security Groups**: Configuración granular por ambiente```

- **Gestión de secretos**: Variables sensibles protegidasConfirma con `yes`.

- **Validación de código**: Checkov, tflint, terraform validate

## Notas de seguridad

## 📋 Requisitos Previos- No subas `terraform.tfvars` ni estados a repositorios públicos (ya está en `.gitignore`).

- La autenticación por contraseña está habilitada a propósito para el profesor; en producción se recomienda usar claves SSH.

- **Terraform**: >= 1.6.0- Puedes agregar una regla de seguridad más estricta limitando el origen de SSH (source_address_prefix) a tu IP pública.

- **Azure CLI**: Para autenticación

- **PowerShell**: 5.1+ (Windows) o PowerShell Core (multiplataforma)## Personalizaciones rápidas

- **Git**: Para control de versiones- Cambiar tamaño de VM: variable `vm_size` (ej: `Standard_B2s`)

- Cambiar paquetes iniciales: editar lista `packages:` en `cloud-init.tpl`

### Herramientas Opcionales- Agregar scripts: añadir comandos a la sección `runcmd` en `cloud-init.tpl`

- **make**: Para usar Makefile (Unix/Linux)

- **pre-commit**: Para hooks de validación## Troubleshooting

- **terraform-docs**: Para generar documentación- Error de contraseña: asegúrate de política válida (Azure rechaza contraseñas débiles).

- **tflint**: Para linting avanzado- Timeout SSH: verifica que la IP pública esté disponible y que el NSG permita puerto 22.

- **checkov**: Para escaneo de seguridad- Cambios en cloud-init no aplican tras la primera creación: destruir la VM o cambiar el nombre para reprovisionar.



## 🛠️ Configuración Inicial---


### 1. Clonar el Repositorio
```bash
git clone <repository-url>
cd TerraformVm
```

### 2. Configurar Variables de Ambiente
Copiar y configurar las variables para el ambiente deseado:

```bash
# Para desarrollo
cp environments/dev/terraform.tfvars.example environments/dev/terraform.tfvars

# Para staging
cp environments/staging/terraform.tfvars.example environments/staging/terraform.tfvars

# Para producción
cp environments/production/terraform.tfvars.example environments/production/terraform.tfvars
```

### 3. Editar Variables
Edita el archivo `terraform.tfvars` correspondiente:

```hcl
# Azure Configuration
subscription_id = "your-subscription-id"
location        = "chilecentral"

# Project Configuration
project_name = "myproject"
owner        = "team-name"

# VM Configuration
vm_size        = "Standard_B1s"
admin_username = "azureuser"
admin_password = "YourSecurePassword123!"

# Security Configuration
allowed_ssh_sources = ["your-ip/32"]
```

## 🔧 Uso del Proyecto

### Opción 1: Scripts PowerShell (Recomendado para Windows)

```powershell
# Inicializar Terraform
.\scripts\terraform.ps1 -Action init -Environment dev

# Ver plan de ejecución
.\scripts\terraform.ps1 -Action plan -Environment dev

# Aplicar cambios
.\scripts\terraform.ps1 -Action apply -Environment dev

# Destruir recursos
.\scripts\terraform.ps1 -Action destroy -Environment dev
```

### Opción 2: Makefile (Unix/Linux/Mac)

```bash
# Ver ayuda
make help

# Inicializar Terraform
make init ENV=dev

# Ver plan de ejecución
make plan ENV=dev

# Aplicar cambios
make apply ENV=dev

# Destruir recursos
make destroy ENV=dev

# Validar todas las configuraciones
make all-envs-validate
```

### Opción 3: Comandos Terraform Directos

```bash
# Navegar al ambiente
cd environments/dev

# Inicializar
terraform init

# Planificar
terraform plan

# Aplicar
terraform apply

# Destruir
terraform destroy
```

## 🏭 Gestión de Ambientes

### Desarrollo (dev)
- **Propósito**: Desarrollo y pruebas rápidas
- **VM Size**: Standard_B1s (económico)
- **Networking**: 10.0.0.0/16
- **Security**: SSH desde cualquier IP (*)
- **Storage**: Standard_LRS

### Staging (staging)
- **Propósito**: Validación pre-producción
- **VM Size**: Standard_B2s (intermedio)
- **Networking**: 10.1.0.0/16
- **Security**: SSH desde redes privadas
- **Storage**: Standard_LRS

### Producción (production)
- **Propósito**: Cargas de trabajo productivas
- **VM Size**: Standard_D2s_v3 (alto rendimiento)
- **Networking**: 10.2.0.0/16
- **Security**: SSH muy restrictivo
- **Storage**: Premium_LRS con discos de 128GB

## 📊 Módulos Disponibles

### Networking Module
Gestiona la infraestructura de red:
- Virtual Network (VNet)
- Subnet
- Public IP
- Network Interface

### Security Module
Configura la seguridad:
- Network Security Group (NSG)
- Security Rules personalizables
- Asociación NSG-Subnet

### Compute Module
Administra los recursos de cómputo:
- Linux Virtual Machine
- OS Disk configuration
- Custom data (cloud-init)

## 🔄 Pipeline CI/CD

El proyecto incluye un pipeline de GitHub Actions que:

1. **Valida** código Terraform en todos los ambientes
2. **Escanea seguridad** con Checkov
3. **Despliega automáticamente** en dev cuando se hace push a `develop`
4. **Planifica staging** cuando se hace push a `main`
5. **Despliega producción** solo con el mensaje `[deploy-prod]`

### Configuración de Secretos GitHub

```
AZURE_CLIENT_ID      # Service Principal Client ID
AZURE_TENANT_ID      # Azure Tenant ID
AZURE_SUBSCRIPTION_ID # Azure Subscription ID
ADMIN_PASSWORD       # VM Administrator Password
```

## 🛡️ Mejores Prácticas Implementadas

### Seguridad
- ✅ Variables sensibles marcadas como `sensitive = true`
- ✅ Archivos `.tfvars` excluidos del control de versiones
- ✅ Configuración de NSG restrictiva por ambiente
- ✅ Escaneo automático de seguridad con Checkov

### Código
- ✅ Módulos reutilizables y parametrizables
- ✅ Naming conventions consistentes
- ✅ Tags estandarizados en todos los recursos
- ✅ Validación de variables con constraints

### DevOps
- ✅ Separación clara de ambientes
- ✅ Pipeline CI/CD automatizado
- ✅ Scripts de automatización multiplataforma
- ✅ Pre-commit hooks para validación

### Documentación
- ✅ README completo con ejemplos
- ✅ Comentarios descriptivos en código
- ✅ Archivos de ejemplo para variables
- ✅ Documentación de módulos

## 🔍 Comandos Útiles

### Validación y Formato
```bash
# Formatear código
terraform fmt -recursive

# Validar configuración
terraform validate

# Mostrar plan sin aplicar
terraform plan

# Ver estado actual
terraform show

# Listar recursos
terraform state list
```

### Debugging
```bash
# Habilitar logs detallados
export TF_LOG=DEBUG

# Ver outputs
terraform output

# Inspeccionar recurso específico
terraform state show azurerm_linux_virtual_machine.vm
```

## 🆘 Solución de Problemas

### Error de Autenticación Azure
```bash
# Hacer login en Azure CLI
az login

# Verificar suscripción
az account show

# Cambiar suscripción si es necesario
az account set --subscription "subscription-id"
```

### Error de Permisos
Verificar que el Service Principal tenga los permisos:
- Contributor en la suscripción o resource group
- User Access Administrator (si gestiona roles)

### Error de Validación de Región
El proyecto está configurado para regiones específicas. Verificar que `location` sea una de:
- northcentralus
- chilecentral
- centralus
- brazilsouth
- southcentralus

## 📝 Personalización

### Agregar Nuevo Ambiente
1. Crear directorio en `environments/`
2. Copiar archivos base de otro ambiente
3. Ajustar configuraciones específicas
4. Actualizar pipeline CI/CD

### Crear Nuevo Módulo
1. Crear directorio en `modules/`
2. Implementar `main.tf`, `variables.tf`, `outputs.tf`
3. Documentar el módulo
4. Integrar en environments

### Modificar Configuración de Red
Editar en cada ambiente:
- `vnet_address_space`
- `subnet_address_prefixes`
- `custom_security_rules`

## 🤝 Contribución

1. Fork el proyecto
2. Crear feature branch (`git checkout -b feature/nueva-funcionalidad`)
3. Commit cambios (`git commit -m 'Agregar nueva funcionalidad'`)
4. Push branch (`git push origin feature/nueva-funcionalidad`)
5. Crear Pull Request

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver archivo `LICENSE` para más detalles.

## 📞 Soporte

Para soporte y preguntas:
- Crear issue en GitHub
- Contactar al equipo de DevOps
- Revisar documentación de Terraform Azure Provider

---

**Desarrollado siguiendo las mejores prácticas de DevOps e Infrastructure as Code (IaC)**