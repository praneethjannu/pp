#!/bin/bash
echo Creating Resource Group
az group create --name VNetPeer --location eastus
az network vnet create \
  --name myVNet1 \
  --resource-group VNetPeer \
  --address-prefixes 10.2.0.0/16 \
  --subnet-name Subnet1 \
  --subnet-prefix 10.2.1.0/24
echo creating VNet and Subnet for first VNET
az network vnet create \
  --name myVNet2 \
  --resource-group VNetPeer \
  --address-prefixes 10.3.0.0/16 \
  --subnet-name Subnet2 \
  --subnet-prefix 10.3.1.0/24
echo creating VNet and Subnet for second VNET
echo ############-------------Getting VNet IDs, because using those IDs only one can create peering --------------##################

# Get the id for myVirtualNetwork1.
myVNet1Id=$(az network vnet show \
  --resource-group VNetPeer \
  --name myVNet1 \
  --query id --out tsv)

# Get the id for myVirtualNetwork2
myVNet2Id=$(az network vnet show \
  --resource-group VNetPeer \
  --name myVNet2 \
  --query id \
  --out tsv)
echo ############----Creating Peering ------------##############

az network vnet peering create \
  --name myVNet1-myVNet2 \
  --resource-group VNetPeer \
  --vnet-name myVNet1 \
  --remote-vnet $myVNet2Id \
  --allow-vnet-access

az network vnet peering create \
  --name myVNet2-myVNet1 \
  --resource-group VNetPeer \
  --vnet-name myVNet2 \
  --remote-vnet $myVNet1Id \
  --allow-vnet-access
echo #####--------- Create a VM---------------##########
az vm create \
  --resource-group VNetPeer \
  --name myVm1 \
  --image UbuntuLTS \
  --vnet-name myVNet1 \
  --subnet Subnet1 \
  --admin-username kiran --admin-password "Kiran1234!@#" --size Standard_B1s \
  --no-wait
az vm create \
  --resource-group VNetPeer \
  --name myVm2 \
  --image UbuntuLTS \
  --vnet-name myVNet2 \
  --subnet Subnet2 \
  --admin-username kiran --admin-password "Kiran1234!@#" --size Standard_B1s

###az group delete --name VNetPeer --yes

