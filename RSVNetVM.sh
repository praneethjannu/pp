#!/bin/bash
##### RG and VNet #################
#az account set --subscription <your subscription GUID>
az group create -l eastus -n TST
az network vnet create -g TST -n TST-FirstVnet1 --address-prefix 10.6.0.0/16 
az network vnet subnet create --name TST-Sub1 --vnet-name TST-FirstVnet1 --resource-group TST  --address-prefixes 10.6.1.0/24

##### NSG & Rule availability set#############
az network nsg create -g TST -n TST_NSG1
az network nsg rule create -g TST --nsg-name TST_NSG1 -n TST_NSG1_Rule1 --priority 100 \
--source-address-prefixes '*' --source-port-ranges '*'     --destination-address-prefixes '*' \
--destination-port-ranges '*' --access Allow   --protocol Tcp --description "Allow from specific IP range" 
az vm availability-set	create --name EAST-AVSET1 -g TST --location eastus

######### Create a VM ################

az vm create --resource-group TST --name ShellPOCVM --image UbuntuLTS --vnet-name TST-FirstVnet1 \
--subnet TST-Sub1 --admin-username kiran --admin-password "Kiran1234!@#" --size Standard_B1s \
--availability-set EAST-AVSET1 --nsg TST_NSG1


############ Deleting A RG #################

#az group delete -n <Name of RG> --yes

