#!/usr/bin/env bash
set -euo pipefail

LOCATION="brazilsouth"
RG_NAME="rg-azure-estudo"
STORAGE_ACCOUNT="stterraformadpstate"
CONTAINER_NAME="tfstate"
SUBSCRIPTION_ID="ff067715-1984-46bc-89a8-b48b5a228b01"

echo "==> Definindo subscription..."
az account set --subscription "$SUBSCRIPTION_ID"

echo "==> Registrando providers necessários..."
for ns in Microsoft.Storage Microsoft.DBforPostgreSQL Microsoft.Network \
          Microsoft.App Microsoft.OperationalInsights Microsoft.ContainerRegistry \
          Microsoft.Web; do
  az provider register --namespace "$ns" --output none
  echo "    $ns registrado"
done

echo "==> Criando resource group '$RG_NAME'..."
az group create \
  --name "$RG_NAME" \
  --location "$LOCATION" \
  --output none

echo "==> Criando storage account '$STORAGE_ACCOUNT'..."
az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RG_NAME" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --allow-blob-public-access false \
  --min-tls-version TLS1_2 \
  --output none

echo "==> Criando container '$CONTAINER_NAME'..."
az storage container create \
  --name "$CONTAINER_NAME" \
  --account-name "$STORAGE_ACCOUNT" \
  --auth-mode login \
  --output none

echo ""
echo "Bootstrap concluido!"
echo "  Storage account : $STORAGE_ACCOUNT"
echo "  Container       : $CONTAINER_NAME"
echo "  Resource group  : $RG_NAME"
