# Terraform Project PowerShell Automation Script
# Usage: .\scripts\terraform.ps1 -Action <action> -Environment <env>
# Example: .\scripts\terraform.ps1 -Action plan -Environment dev

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("init", "plan", "apply", "destroy", "validate", "fmt", "show", "output", "clean")]
    [string]$Action,
    
    [Parameter(Mandatory=$true)]
    [ValidateSet("dev", "staging", "production")]
    [string]$Environment
)

# Colors for output
$Green = "Green"
$Yellow = "Yellow"
$Red = "Red"

# Environment directory
$TfDir = "environments\$Environment"

# Check if environment directory exists
if (-not (Test-Path $TfDir)) {
    Write-Host "Error: Environment '$Environment' not found!" -ForegroundColor $Red
    Write-Host "Available environments: dev, staging, production" -ForegroundColor $Yellow
    exit 1
}

# Function to execute terraform commands
function Invoke-TerraformCommand {
    param(
        [string]$Command,
        [string]$Directory,
        [bool]$RequireConfirmation = $false
    )
    
    if ($RequireConfirmation) {
        $confirmation = Read-Host "Are you sure you want to continue? (y/N)"
        if ($confirmation -ne "y") {
            Write-Host "Operation cancelled." -ForegroundColor $Yellow
            return
        }
    }
    
    Push-Location $Directory
    try {
        Write-Host "Executing: $Command" -ForegroundColor $Green
        Invoke-Expression $Command
    }
    finally {
        Pop-Location
    }
}

# Main execution logic
switch ($Action) {
    "init" {
        Write-Host "Initializing Terraform for $Environment environment..." -ForegroundColor $Green
        Invoke-TerraformCommand "terraform init" $TfDir
    }
    
    "plan" {
        Write-Host "Creating execution plan for $Environment environment..." -ForegroundColor $Green
        Invoke-TerraformCommand "terraform plan" $TfDir
    }
    
    "apply" {
        Write-Host "WARNING: This will create/modify Azure resources!" -ForegroundColor $Red
        Invoke-TerraformCommand "terraform apply" $TfDir $true
    }
    
    "destroy" {
        Write-Host "WARNING: This will DESTROY all resources in $Environment environment!" -ForegroundColor $Red
        $confirmation = Read-Host "Type 'yes' to continue"
        if ($confirmation -eq "yes") {
            Invoke-TerraformCommand "terraform destroy" $TfDir
        } else {
            Write-Host "Operation cancelled." -ForegroundColor $Yellow
        }
    }
    
    "validate" {
        Write-Host "Validating Terraform configuration for $Environment environment..." -ForegroundColor $Green
        Invoke-TerraformCommand "terraform validate" $TfDir
    }
    
    "fmt" {
        Write-Host "Formatting Terraform files..." -ForegroundColor $Green
        terraform fmt -recursive .
    }
    
    "show" {
        Write-Host "Showing current state for $Environment environment..." -ForegroundColor $Green
        Invoke-TerraformCommand "terraform show" $TfDir
    }
    
    "output" {
        Write-Host "Showing outputs for $Environment environment..." -ForegroundColor $Green
        Invoke-TerraformCommand "terraform output" $TfDir
    }
    
    "clean" {
        Write-Host "Cleaning temporary files for $Environment environment..." -ForegroundColor $Green
        Push-Location $TfDir
        try {
            Remove-Item ".terraform" -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item ".terraform.lock.hcl" -Force -ErrorAction SilentlyContinue
            Remove-Item "terraform.tfstate.backup" -Force -ErrorAction SilentlyContinue
            Write-Host "Cleanup completed." -ForegroundColor $Green
        }
        finally {
            Pop-Location
        }
    }
}

Write-Host "Operation completed." -ForegroundColor $Green