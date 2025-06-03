# Define variables
$resourceGroup = "RG-PS-Automation"
$location = "eastus"
$vmName = "PS-Auto-VM"
$adminUser = "azureuser"
$adminPassword = ConvertTo-SecureString "YourSecurePassword123!" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($adminUser, $adminPassword)

# Create Resource Group (if not exists)
New-AzResourceGroup -Name $resourceGroup -Location $location -Force

# Create VM
New-AzVM -ResourceGroupName $resourceGroup -Name $vmName -Location $location -Image "Ubuntu2204" -Credential $credential -OpenPorts 22
