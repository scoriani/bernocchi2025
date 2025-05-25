az group create --name bernocchi2025 --location northeurope

az network vnet create --resource-group bernocchi2025 --name bernocchi2025-vnet --address-prefix 10.0.0.0/22

az network vnet subnet create --resource-group bernocchi2025 --vnet-name bernocchi2025-vnet --name server --address-prefix 10.0.0.0/24

az vm create --resource-group bernocchi2025 --name bernocchi2025-vm --no-public-ip --image Ubuntu2204 --admin-username azureuser --generate-ssh-keys --vnet-name bernocchi2025-vnet --subnet server --size Standard_B1s

az vm open-port --resource-group bernocchi2025 --name bernocchi2025-vm --port 22

# create a bastion host with a public IP address
az network public-ip create --resource-group bernocchi2025 --name bernocchi2025-bastion-ip --sku Standard
az network vnet subnet create --resource-group bernocchi2025 --vnet-name bernocchi2025-vnet --name AzureBastionSubnet --address-prefix 10.0.1.0/24
az network bastion create --resource-group bernocchi2025 --name bernocchi2025-bastion --vnet-name bernocchi2025-vnet --location northeurope --public-ip-address bernocchi2025-bastion-ip --sku Standard


# open a tunnel to the VM
az network bastion tunnel --resource-group bernocchi2025 --name bernocchi2025-bastion --target-resource-id $(az vm show --resource-group bernocchi2025 --name bernocchi2025-vm --query id -o tsv) --port 22 --tunnel-port 5000
# Connect to the VM using the tunnel
ssh -i ~/.ssh/id_rsa azureuser@localhost -p 5000