<#
.DESCRIPTION
Creates an Azure VM in Automation Account
#>

param(
    [string]$ResourceGroupName = "RG-PS-Automation",
    [string]$VmName = "PS-Auto-VM",
    [string]$Location = "eastus"
)

# Connect to Azure
try {
    $Conn = Get-AutomationConnection -Name AzureRunAsConnection
    Connect-AzAccount -ServicePrincipal `
        -Tenant $Conn.TenantID `
        -ApplicationId $Conn.ApplicationID `
        -CertificateThumbprint $Conn.CertificateThumbprint
} catch {
    Write-Error "Azure connection failed: $_"
    exit 1
}

# Create Resource Group
if (-not (Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue)) {
    try {
        New-AzResourceGroup -Name $ResourceGroupName -Location $Location
        Write-Output "Created resource group: $ResourceGroupName"
    } catch {
        Write-Error "Failed creating resource group: $_"
        exit 1
    }
}

# VM Configuration
$SecurePassword = ConvertTo-SecureString "YourSecurePassword123!" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ("azureuser", $SecurePassword)

# Create VM
try {
    New-AzVM -ResourceGroupName $ResourceGroupName `
        -Name $VmName `
        -Location $Location `
        -Image "Ubuntu2204" `
        -Credential $Credential `
        -OpenPorts 22 `
        -Verbose
    
    Write-Output "Successfully created VM: $VmName"
} catch {
    Write-Error "VM creation failed: $_"
    exit 1
}
