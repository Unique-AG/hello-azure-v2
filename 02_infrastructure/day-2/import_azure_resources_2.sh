#!/bin/bash
# Terraform import commands for Day-2 resources (Supplementary Script)
# This script supplements import_azure_resources.sh with additional resources
# Usage: ./import_azure_resources_2.sh test
#        ./import_azure_resources_2.sh dev

set -euo pipefail

SUBSCRIPTION_ID=$(az account show --query id -o tsv 2>/dev/null || echo "")

ENV="${1:-test}"
VAR_CONFIG="../environments/${ENV}/00-config-day-2.auto.tfvars"
VAR_PARAMS="../environments/${ENV}/00-parameters-day-2.auto.tfvars"

# Resource Group Names
RESOURCE_GROUP_CORE_NAME="resource-group-core"
RESOURCE_GROUP_SENSITIVE_NAME="resource-group-sensitive"
RESOURCE_GROUP_VNET_NAME="rg-vnet-002"

# Key Vault Names
KEY_VAULT_SENSITIVE_NAME="hakv2${ENV}v2"
KEY_VAULT_CORE_NAME="hakv1${ENV}v2"

# Resource Names
AUDIT_STORAGE_SA_NAME="helloazureaudit"
AUDIT_STORAGE_IDENTITY_NAME="audit-storage-id"
AKS_WORKLOAD_IDENTITY_NAME="aks-id-${ENV}"
POSTGRESQL_SERVER_NAME="psql-s5xqjn64"
AKS_CLUSTER_NAME="aks-${ENV}"
APPLICATION_GATEWAY_NAME="ha-${ENV}-appgw"

echo "=========================================="
echo "Day-2 Resource Import Script (Supplementary)"
echo "Environment: ${ENV}"
echo "Started at: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="
echo ""
echo "⚠️  IMPORTANT: This is a supplementary script to import_azure_resources.sh"
echo "   Run this AFTER the main import script has completed successfully."
echo ""

if [ -z "${SUBSCRIPTION_ID}" ]; then
  echo "❌ ERROR: Could not get Azure subscription ID"
  echo "   Please ensure you are logged in: az login"
  exit 1
fi

echo "Using Subscription: ${SUBSCRIPTION_ID}"
echo "Using Resource Groups:"
echo "  - Core: ${RESOURCE_GROUP_CORE_NAME}"
echo "  - Sensitive: ${RESOURCE_GROUP_SENSITIVE_NAME}"
echo "  - VNet: ${RESOURCE_GROUP_VNET_NAME}"
echo ""

# ============================================================================
# AUDIT STORAGE RESOURCES (Priority)
# ============================================================================
echo ""
echo "=========================================="
echo "Importing Audit Storage Resources"
echo "=========================================="
echo ""

# Audit Storage User Assigned Identity
echo "Checking azurerm_user_assigned_identity.audit_storage_identity..."
if ! terraform state show azurerm_user_assigned_identity.audit_storage_identity >/dev/null 2>&1; then
  echo "  Importing azurerm_user_assigned_identity.audit_storage_identity..."
  if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_user_assigned_identity.audit_storage_identity \
    "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${AUDIT_STORAGE_IDENTITY_NAME}" 2>&1; then
    echo "  ✓ Imported azurerm_user_assigned_identity.audit_storage_identity"
  else
    echo "  ⚠️  Failed to import azurerm_user_assigned_identity.audit_storage_identity - resource may not exist in Azure"
    echo "      This resource will be created on terraform apply"
  fi
else
  echo "  ✓ azurerm_user_assigned_identity.audit_storage_identity already in state, skipping"
fi

# Audit Storage Account
echo "Checking module.audit_storage.azurerm_storage_account.storage_account..."
if ! terraform state show 'module.audit_storage.azurerm_storage_account.storage_account' >/dev/null 2>&1; then
  echo "  Importing module.audit_storage.azurerm_storage_account.storage_account..."
  if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    'module.audit_storage.azurerm_storage_account.storage_account' \
    "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE_NAME}/providers/Microsoft.Storage/storageAccounts/${AUDIT_STORAGE_SA_NAME}" 2>&1; then
    echo "  ✓ Imported module.audit_storage.azurerm_storage_account.storage_account"
  else
    echo "  ⚠️  Failed to import module.audit_storage.azurerm_storage_account.storage_account - resource may not exist in Azure"
    echo "      This resource will be created on terraform apply"
  fi
else
  echo "  ✓ module.audit_storage.azurerm_storage_account.storage_account already in state, skipping"
fi

# Audit Storage CMK Key
echo "Checking module.audit_storage.azurerm_key_vault_key.storage-account-byok[0]..."
if ! terraform state show 'module.audit_storage.azurerm_key_vault_key.storage-account-byok[0]' >/dev/null 2>&1; then
  KEY_VERSION=$(az keyvault key list-versions --vault-name "${KEY_VAULT_SENSITIVE_NAME}" --name "audit-storage-cmk" --query "[0].kid" -o tsv 2>/dev/null || echo "")
  if [ -n "${KEY_VERSION}" ]; then
    echo "  Importing module.audit_storage.azurerm_key_vault_key.storage-account-byok[0]..."
    terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.audit_storage.azurerm_key_vault_key.storage-account-byok[0]' \
      "${KEY_VERSION}"
    echo "  ✓ Imported module.audit_storage.azurerm_key_vault_key.storage-account-byok[0]"
  else
    echo "  ⚠️  Key 'audit-storage-cmk' not found in vault '${KEY_VAULT_SENSITIVE_NAME}'"
    echo "      This key will be created by Terraform on apply"
  fi
else
  echo "  ✓ module.audit_storage.azurerm_key_vault_key.storage-account-byok[0] already in state, skipping"
fi

# Audit Storage Customer Managed Key Association
echo "Checking module.audit_storage.azurerm_storage_account_customer_managed_key.storage_account_cmk[0]..."
if ! terraform state show 'module.audit_storage.azurerm_storage_account_customer_managed_key.storage_account_cmk[0]' >/dev/null 2>&1; then
  echo "  Importing module.audit_storage.azurerm_storage_account_customer_managed_key.storage_account_cmk[0]..."
  if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    'module.audit_storage.azurerm_storage_account_customer_managed_key.storage_account_cmk[0]' \
    "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE_NAME}/providers/Microsoft.Storage/storageAccounts/${AUDIT_STORAGE_SA_NAME}" 2>&1; then
    echo "  ✓ Imported module.audit_storage.azurerm_storage_account_customer_managed_key.storage_account_cmk[0]"
  else
    echo "  ⚠️  Failed to import module.audit_storage.azurerm_storage_account_customer_managed_key.storage_account_cmk[0] - resource may not exist in Azure"
    echo "      This resource will be created on terraform apply"
  fi
else
  echo "  ✓ module.audit_storage.azurerm_storage_account_customer_managed_key.storage_account_cmk[0] already in state, skipping"
fi

# Audit Storage Management Policy
echo "Checking module.audit_storage.azurerm_storage_management_policy.default[0]..."
if ! terraform state show 'module.audit_storage.azurerm_storage_management_policy.default[0]' >/dev/null 2>&1; then
  echo "  Importing module.audit_storage.azurerm_storage_management_policy.default[0]..."
  if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    'module.audit_storage.azurerm_storage_management_policy.default[0]' \
    "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE_NAME}/providers/Microsoft.Storage/storageAccounts/${AUDIT_STORAGE_SA_NAME}/managementPolicies/default" 2>&1; then
    echo "  ✓ Imported module.audit_storage.azurerm_storage_management_policy.default[0]"
  else
    echo "  ⚠️  Failed to import module.audit_storage.azurerm_storage_management_policy.default[0] - resource may not exist in Azure"
    echo "      This resource will be created on terraform apply"
  fi
else
  echo "  ✓ module.audit_storage.azurerm_storage_management_policy.default[0] already in state, skipping"
fi

# Audit Storage Containers
echo ""
echo "Importing Audit Storage Containers..."
AUDIT_CONTAINERS=(
  "backend-service-app-repository"
  "backend-service-chat"
  "backend-service-configuration"
  "backend-service-ingestion"
  "backend-service-ingestion-worker"
  "backend-service-ingestion-worker-chat"
  "backend-service-scope-management"
)

for CONTAINER in "${AUDIT_CONTAINERS[@]}"; do
  echo "Checking module.audit_storage.azurerm_storage_container.container[\"${CONTAINER}\"]..."
  if ! terraform state show "module.audit_storage.azurerm_storage_container.container[\"${CONTAINER}\"]" >/dev/null 2>&1; then
    echo "  Importing module.audit_storage.azurerm_storage_container.container[\"${CONTAINER}\"]..."
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      "module.audit_storage.azurerm_storage_container.container[\"${CONTAINER}\"]" \
      "https://${AUDIT_STORAGE_SA_NAME}.blob.core.windows.net/${CONTAINER}" 2>&1; then
      echo "  ✓ Imported module.audit_storage.azurerm_storage_container.container[\"${CONTAINER}\"]"
    else
      echo "  ⚠️  Failed to import container '${CONTAINER}' - may not exist in Azure"
    fi
  else
    echo "  ✓ module.audit_storage.azurerm_storage_container.container[\"${CONTAINER}\"] already in state, skipping"
  fi
done

# ============================================================================
# FEDERATED IDENTITY CREDENTIALS
# ============================================================================
echo ""
echo "=========================================="
echo "Importing Federated Identity Credentials"
echo "=========================================="
echo ""

# Get the AKS workload identity ID
AKS_WORKLOAD_IDENTITY_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${AKS_WORKLOAD_IDENTITY_NAME}"

WORKLOAD_IDENTITIES=(
  "assistants-core"
  "backend-service-chat"
  "backend-service-ingestion"
  "backend-service-ingestion-worker"
  "backend-service-ingestion-worker-chat"
  "backend-service-speech"
)

for WORKLOAD in "${WORKLOAD_IDENTITIES[@]}"; do
  echo "Checking azurerm_federated_identity_credential.afic_workloads[\"${WORKLOAD}\"]..."
  if ! terraform state show "azurerm_federated_identity_credential.afic_workloads[\"${WORKLOAD}\"]" >/dev/null 2>&1; then
    echo "  Importing azurerm_federated_identity_credential.afic_workloads[\"${WORKLOAD}\"]..."
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      "azurerm_federated_identity_credential.afic_workloads[\"${WORKLOAD}\"]" \
      "${AKS_WORKLOAD_IDENTITY_ID}/federatedIdentityCredentials/${WORKLOAD}" 2>&1; then
      echo "  ✓ Imported azurerm_federated_identity_credential.afic_workloads[\"${WORKLOAD}\"]"
    else
      echo "  ⚠️  Failed to import federated credential '${WORKLOAD}' - may not exist in Azure"
    fi
  else
    echo "  ✓ azurerm_federated_identity_credential.afic_workloads[\"${WORKLOAD}\"] already in state, skipping"
  fi
done

# ============================================================================
# ROLE ASSIGNMENTS
# ============================================================================
echo ""
echo "=========================================="
echo "Importing Role Assignments"
echo "=========================================="
echo ""

# Get principal IDs needed for role assignments
echo "Retrieving principal IDs..."
AKS_WORKLOAD_IDENTITY_PRINCIPAL_ID=$(az identity show --name "${AKS_WORKLOAD_IDENTITY_NAME}" --resource-group "${RESOURCE_GROUP_CORE_NAME}" --query principalId -o tsv 2>/dev/null || echo "")
AUDIT_STORAGE_IDENTITY_PRINCIPAL_ID=$(az identity show --name "${AUDIT_STORAGE_IDENTITY_NAME}" --resource-group "${RESOURCE_GROUP_SENSITIVE_NAME}" --query principalId -o tsv 2>/dev/null || echo "")

# Get AKS cluster details for AGIC and CSI identities
AKS_CLUSTER_EXISTS=$(az aks show --name "${AKS_CLUSTER_NAME}" --resource-group "${RESOURCE_GROUP_CORE_NAME}" --query id -o tsv 2>/dev/null || echo "")

if [ -n "${AKS_CLUSTER_EXISTS}" ]; then
  AGIC_IDENTITY_OBJECT_ID=$(az aks show --name "${AKS_CLUSTER_NAME}" --resource-group "${RESOURCE_GROUP_CORE_NAME}" --query "ingressApplicationGateway.effectiveApplicationGatewayId" -o tsv 2>/dev/null | xargs -I {} az identity show --ids {} --query principalId -o tsv 2>/dev/null || echo "")
  CSI_IDENTITY_OBJECT_ID=$(az aks show --name "${AKS_CLUSTER_NAME}" --resource-group "${RESOURCE_GROUP_CORE_NAME}" --query "addonProfiles.azureKeyvaultSecretsProvider.identity.objectId" -o tsv 2>/dev/null || echo "")
  KUBELET_IDENTITY_OBJECT_ID=$(az aks show --name "${AKS_CLUSTER_NAME}" --resource-group "${RESOURCE_GROUP_CORE_NAME}" --query "identityProfile.kubeletidentity.objectId" -o tsv 2>/dev/null || echo "")
else
  echo "⚠️  AKS cluster not found. Skipping AKS-related role assignment imports."
  AGIC_IDENTITY_OBJECT_ID=""
  CSI_IDENTITY_OBJECT_ID=""
  KUBELET_IDENTITY_OBJECT_ID=""
fi

# Audit Storage Role Assignments
if [ -n "${AUDIT_STORAGE_IDENTITY_PRINCIPAL_ID}" ]; then
  echo ""
  echo "Importing Audit Storage Role Assignments..."
  
  # Key Vault Secrets Officer
  echo "Checking azurerm_role_assignment.audit_storage_kv_key_reader..."
  if ! terraform state show azurerm_role_assignment.audit_storage_kv_key_reader >/dev/null 2>&1; then
    ROLE_ASSIGNMENT_ID=$(az role assignment list \
      --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE_NAME}/providers/Microsoft.KeyVault/vaults/${KEY_VAULT_SENSITIVE_NAME}" \
      --assignee "${AUDIT_STORAGE_IDENTITY_PRINCIPAL_ID}" \
      --role "Key Vault Secrets Officer" \
      --query "[0].id" -o tsv 2>/dev/null || echo "")
    
    if [ -n "${ROLE_ASSIGNMENT_ID}" ]; then
      echo "  Importing azurerm_role_assignment.audit_storage_kv_key_reader..."
      terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
        azurerm_role_assignment.audit_storage_kv_key_reader \
        "${ROLE_ASSIGNMENT_ID}"
      echo "  ✓ Imported azurerm_role_assignment.audit_storage_kv_key_reader"
    else
      echo "  ⚠️  Role assignment not found, will be created on apply"
    fi
  else
    echo "  ✓ azurerm_role_assignment.audit_storage_kv_key_reader already in state, skipping"
  fi
  
  # Key Vault Secrets User
  echo "Checking azurerm_role_assignment.audit_storage_kv_secrets_reader..."
  if ! terraform state show azurerm_role_assignment.audit_storage_kv_secrets_reader >/dev/null 2>&1; then
    ROLE_ASSIGNMENT_ID=$(az role assignment list \
      --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE_NAME}/providers/Microsoft.KeyVault/vaults/${KEY_VAULT_SENSITIVE_NAME}" \
      --assignee "${AUDIT_STORAGE_IDENTITY_PRINCIPAL_ID}" \
      --role "Key Vault Secrets User" \
      --query "[0].id" -o tsv 2>/dev/null || echo "")
    
    if [ -n "${ROLE_ASSIGNMENT_ID}" ]; then
      echo "  Importing azurerm_role_assignment.audit_storage_kv_secrets_reader..."
      terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
        azurerm_role_assignment.audit_storage_kv_secrets_reader \
        "${ROLE_ASSIGNMENT_ID}"
      echo "  ✓ Imported azurerm_role_assignment.audit_storage_kv_secrets_reader"
    else
      echo "  ⚠️  Role assignment not found, will be created on apply"
    fi
  else
    echo "  ✓ azurerm_role_assignment.audit_storage_kv_secrets_reader already in state, skipping"
  fi
fi

# AKS Workload Identity Role Assignment (Cognitive Services User)
if [ -n "${AKS_WORKLOAD_IDENTITY_PRINCIPAL_ID}" ]; then
  echo ""
  echo "Importing AKS Workload Identity Role Assignments..."
  
  echo "Checking azurerm_role_assignment.aks_workload_identity_cognitive_services_user..."
  if ! terraform state show azurerm_role_assignment.aks_workload_identity_cognitive_services_user >/dev/null 2>&1; then
    ROLE_ASSIGNMENT_ID=$(az role assignment list \
      --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}" \
      --assignee "${AKS_WORKLOAD_IDENTITY_PRINCIPAL_ID}" \
      --role "Cognitive Services User" \
      --query "[0].id" -o tsv 2>/dev/null || echo "")
    
    if [ -n "${ROLE_ASSIGNMENT_ID}" ]; then
      echo "  Importing azurerm_role_assignment.aks_workload_identity_cognitive_services_user..."
      terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
        azurerm_role_assignment.aks_workload_identity_cognitive_services_user \
        "${ROLE_ASSIGNMENT_ID}"
      echo "  ✓ Imported azurerm_role_assignment.aks_workload_identity_cognitive_services_user"
    else
      echo "  ⚠️  Role assignment not found, will be created on apply"
    fi
  else
    echo "  ✓ azurerm_role_assignment.aks_workload_identity_cognitive_services_user already in state, skipping"
  fi
fi

# AGIC Role Assignments
if [ -n "${AGIC_IDENTITY_OBJECT_ID}" ]; then
  echo ""
  echo "Importing AGIC Role Assignments..."
  
  # Reader on Resource Group
  echo "Checking azurerm_role_assignment.application_gateway_ingres_controller_reader_role..."
  if ! terraform state show azurerm_role_assignment.application_gateway_ingres_controller_reader_role >/dev/null 2>&1; then
    ROLE_ASSIGNMENT_ID=$(az role assignment list \
      --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}" \
      --assignee "${AGIC_IDENTITY_OBJECT_ID}" \
      --role "Reader" \
      --query "[0].id" -o tsv 2>/dev/null || echo "")
    
    if [ -n "${ROLE_ASSIGNMENT_ID}" ]; then
      echo "  Importing azurerm_role_assignment.application_gateway_ingres_controller_reader_role..."
      terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
        azurerm_role_assignment.application_gateway_ingres_controller_reader_role \
        "${ROLE_ASSIGNMENT_ID}"
      echo "  ✓ Imported azurerm_role_assignment.application_gateway_ingres_controller_reader_role"
    else
      echo "  ⚠️  Role assignment not found, will be created on apply"
    fi
  else
    echo "  ✓ azurerm_role_assignment.application_gateway_ingres_controller_reader_role already in state, skipping"
  fi
  
  # Contributor on Application Gateway
  echo "Checking azurerm_role_assignment.application_gateway_ingres_controller_contributor_role..."
  if ! terraform state show azurerm_role_assignment.application_gateway_ingres_controller_contributor_role >/dev/null 2>&1; then
    ROLE_ASSIGNMENT_ID=$(az role assignment list \
      --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.Network/applicationGateways/${APPLICATION_GATEWAY_NAME}" \
      --assignee "${AGIC_IDENTITY_OBJECT_ID}" \
      --role "Contributor" \
      --query "[0].id" -o tsv 2>/dev/null || echo "")
    
    if [ -n "${ROLE_ASSIGNMENT_ID}" ]; then
      echo "  Importing azurerm_role_assignment.application_gateway_ingres_controller_contributor_role..."
      terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
        azurerm_role_assignment.application_gateway_ingres_controller_contributor_role \
        "${ROLE_ASSIGNMENT_ID}"
      echo "  ✓ Imported azurerm_role_assignment.application_gateway_ingres_controller_contributor_role"
    else
      echo "  ⚠️  Role assignment not found, will be created on apply"
    fi
  else
    echo "  ✓ azurerm_role_assignment.application_gateway_ingres_controller_contributor_role already in state, skipping"
  fi
  
  # VNet Subnet Access on VNet Resource Group
  echo "Checking azurerm_role_assignment.application_gateway_ingres_controller_vnet_subnet_access..."
  if ! terraform state show azurerm_role_assignment.application_gateway_ingres_controller_vnet_subnet_access >/dev/null 2>&1; then
    ROLE_ASSIGNMENT_ID=$(az role assignment list \
      --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_VNET_NAME}" \
      --assignee "${AGIC_IDENTITY_OBJECT_ID}" \
      --query "[?contains(roleDefinitionName, 'VNet Subnet Access')].id" -o tsv 2>/dev/null | head -1 || echo "")
    
    if [ -n "${ROLE_ASSIGNMENT_ID}" ]; then
      echo "  Importing azurerm_role_assignment.application_gateway_ingres_controller_vnet_subnet_access..."
      terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
        azurerm_role_assignment.application_gateway_ingres_controller_vnet_subnet_access \
        "${ROLE_ASSIGNMENT_ID}"
      echo "  ✓ Imported azurerm_role_assignment.application_gateway_ingres_controller_vnet_subnet_access"
    else
      echo "  ⚠️  Role assignment not found, will be created on apply"
    fi
  else
    echo "  ✓ azurerm_role_assignment.application_gateway_ingres_controller_vnet_subnet_access already in state, skipping"
  fi
fi

# AKS Cluster Role Assignments (Terraform Service Principal)
if [ -n "${AKS_CLUSTER_EXISTS}" ]; then
  echo ""
  echo "Importing AKS Cluster Role Assignments..."
  
  # Get Terraform Service Principal Object ID from tfvars
  TERRAFORM_SP_OBJECT_ID=$(grep "^terraform_service_principal_object_id" "${VAR_PARAMS}" 2>/dev/null | cut -d'"' -f2 || echo "")
  
  if [ -n "${TERRAFORM_SP_OBJECT_ID}" ]; then
    # Azure Kubernetes Service Contributor Role
    echo "Checking azurerm_role_assignment.cluster_user_terraform..."
    if ! terraform state show azurerm_role_assignment.cluster_user_terraform >/dev/null 2>&1; then
      ROLE_ASSIGNMENT_ID=$(az role assignment list \
        --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.ContainerService/managedClusters/${AKS_CLUSTER_NAME}" \
        --assignee "${TERRAFORM_SP_OBJECT_ID}" \
        --role "Azure Kubernetes Service Contributor Role" \
        --query "[0].id" -o tsv 2>/dev/null || echo "")
      
      if [ -n "${ROLE_ASSIGNMENT_ID}" ]; then
        echo "  Importing azurerm_role_assignment.cluster_user_terraform..."
        terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
          azurerm_role_assignment.cluster_user_terraform \
          "${ROLE_ASSIGNMENT_ID}"
        echo "  ✓ Imported azurerm_role_assignment.cluster_user_terraform"
      else
        echo "  ⚠️  Role assignment not found, will be created on apply"
      fi
    else
      echo "  ✓ azurerm_role_assignment.cluster_user_terraform already in state, skipping"
    fi
    
    # Azure Kubernetes Service RBAC Cluster Admin
    echo "Checking azurerm_role_assignment.cluster_rbac_admin_terraform..."
    if ! terraform state show azurerm_role_assignment.cluster_rbac_admin_terraform >/dev/null 2>&1; then
      ROLE_ASSIGNMENT_ID=$(az role assignment list \
        --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.ContainerService/managedClusters/${AKS_CLUSTER_NAME}" \
        --assignee "${TERRAFORM_SP_OBJECT_ID}" \
        --role "Azure Kubernetes Service RBAC Cluster Admin" \
        --query "[0].id" -o tsv 2>/dev/null || echo "")
      
      if [ -n "${ROLE_ASSIGNMENT_ID}" ]; then
        echo "  Importing azurerm_role_assignment.cluster_rbac_admin_terraform..."
        terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
          azurerm_role_assignment.cluster_rbac_admin_terraform \
          "${ROLE_ASSIGNMENT_ID}"
        echo "  ✓ Imported azurerm_role_assignment.cluster_rbac_admin_terraform"
      else
        echo "  ⚠️  Role assignment not found, will be created on apply"
      fi
    else
      echo "  ✓ azurerm_role_assignment.cluster_rbac_admin_terraform already in state, skipping"
    fi
  fi
fi

# CSI Identity Role Assignments (Key Vault Secrets User)
if [ -n "${CSI_IDENTITY_OBJECT_ID}" ]; then
  echo ""
  echo "Importing CSI Identity Role Assignments..."
  
  # Main Key Vault
  echo "Checking azurerm_role_assignment.csi_identity_secret_reader_main_kv..."
  if ! terraform state show azurerm_role_assignment.csi_identity_secret_reader_main_kv >/dev/null 2>&1; then
    ROLE_ASSIGNMENT_ID=$(az role assignment list \
      --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.KeyVault/vaults/${KEY_VAULT_CORE_NAME}" \
      --assignee "${CSI_IDENTITY_OBJECT_ID}" \
      --role "Key Vault Secrets User" \
      --query "[0].id" -o tsv 2>/dev/null || echo "")
    
    if [ -n "${ROLE_ASSIGNMENT_ID}" ]; then
      echo "  Importing azurerm_role_assignment.csi_identity_secret_reader_main_kv..."
      terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
        azurerm_role_assignment.csi_identity_secret_reader_main_kv \
        "${ROLE_ASSIGNMENT_ID}"
      echo "  ✓ Imported azurerm_role_assignment.csi_identity_secret_reader_main_kv"
    else
      echo "  ⚠️  Role assignment not found, will be created on apply"
    fi
  else
    echo "  ✓ azurerm_role_assignment.csi_identity_secret_reader_main_kv already in state, skipping"
  fi
  
  # Sensitive Key Vault
  echo "Checking azurerm_role_assignment.csi_identity_secret_reader..."
  if ! terraform state show azurerm_role_assignment.csi_identity_secret_reader >/dev/null 2>&1; then
    ROLE_ASSIGNMENT_ID=$(az role assignment list \
      --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE_NAME}/providers/Microsoft.KeyVault/vaults/${KEY_VAULT_SENSITIVE_NAME}" \
      --assignee "${CSI_IDENTITY_OBJECT_ID}" \
      --role "Key Vault Secrets User" \
      --query "[0].id" -o tsv 2>/dev/null || echo "")
    
    if [ -n "${ROLE_ASSIGNMENT_ID}" ]; then
      echo "  Importing azurerm_role_assignment.csi_identity_secret_reader..."
      terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
        azurerm_role_assignment.csi_identity_secret_reader \
        "${ROLE_ASSIGNMENT_ID}"
      echo "  ✓ Imported azurerm_role_assignment.csi_identity_secret_reader"
    else
      echo "  ⚠️  Role assignment not found, will be created on apply"
    fi
  else
    echo "  ✓ azurerm_role_assignment.csi_identity_secret_reader already in state, skipping"
  fi
fi

# DNS Contributor Role Assignment (Kubelet Identity)
if [ -n "${KUBELET_IDENTITY_OBJECT_ID}" ]; then
  echo ""
  echo "Importing DNS Contributor Role Assignment..."
  
  # Get DNS Zone name from tfvars
  DNS_ZONE_NAME=$(grep "^dns_zone_name" "${VAR_PARAMS}" 2>/dev/null | cut -d'"' -f2 || echo "")
  
  if [ -n "${DNS_ZONE_NAME}" ]; then
    echo "Checking azurerm_role_assignment.dns_contributor..."
    if ! terraform state show azurerm_role_assignment.dns_contributor >/dev/null 2>&1; then
      ROLE_ASSIGNMENT_ID=$(az role assignment list \
        --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_VNET_NAME}/providers/Microsoft.Network/dnsZones/${DNS_ZONE_NAME}" \
        --assignee "${KUBELET_IDENTITY_OBJECT_ID}" \
        --role "DNS Zone Contributor" \
        --query "[0].id" -o tsv 2>/dev/null || echo "")
      
      if [ -n "${ROLE_ASSIGNMENT_ID}" ]; then
        echo "  Importing azurerm_role_assignment.dns_contributor..."
        terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
          azurerm_role_assignment.dns_contributor \
          "${ROLE_ASSIGNMENT_ID}"
        echo "  ✓ Imported azurerm_role_assignment.dns_contributor"
      else
        echo "  ⚠️  Role assignment not found, will be created on apply"
      fi
    else
      echo "  ✓ azurerm_role_assignment.dns_contributor already in state, skipping"
    fi
  fi
fi

# ============================================================================
# SCOPE MANAGEMENT ENCRYPTION KEY SECRETS
# ============================================================================
echo ""
echo "=========================================="
echo "Importing Scope Management Encryption Key Secrets"
echo "=========================================="
echo ""

echo "NOTE: random_id resources cannot be imported and will show as drift."
echo "      The hex values are deterministic based on keepers, so they will"
echo "      remain stable across terraform runs."
echo ""

# Scope Management Encryption Key 1
echo "Checking azurerm_key_vault_secret.scope_management_encryption_key_1..."
if ! terraform state show azurerm_key_vault_secret.scope_management_encryption_key_1 >/dev/null 2>&1; then
  SECRET_VERSION_ID=$(az keyvault secret show \
    --vault-name "${KEY_VAULT_SENSITIVE_NAME}" \
    --name "scope-management-encryption-key-1" \
    --query id -o tsv 2>/dev/null || echo "")
  
  if [ -n "${SECRET_VERSION_ID}" ]; then
    echo "  Importing azurerm_key_vault_secret.scope_management_encryption_key_1..."
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      azurerm_key_vault_secret.scope_management_encryption_key_1 \
      "${SECRET_VERSION_ID}" 2>&1; then
      echo "  ✓ Imported azurerm_key_vault_secret.scope_management_encryption_key_1"
    else
      echo "  ⚠️  Failed to import scope_management_encryption_key_1"
    fi
  else
    echo "  ⚠️  Secret not found, will be created on apply"
  fi
else
  echo "  ✓ azurerm_key_vault_secret.scope_management_encryption_key_1 already in state, skipping"
fi

# Scope Management Encryption Key 2
echo "Checking azurerm_key_vault_secret.scope_management_encryption_key_2..."
if ! terraform state show azurerm_key_vault_secret.scope_management_encryption_key_2 >/dev/null 2>&1; then
  SECRET_VERSION_ID=$(az keyvault secret show \
    --vault-name "${KEY_VAULT_SENSITIVE_NAME}" \
    --name "scope-management-encryption-key-2" \
    --query id -o tsv 2>/dev/null || echo "")
  
  if [ -n "${SECRET_VERSION_ID}" ]; then
    echo "  Importing azurerm_key_vault_secret.scope_management_encryption_key_2..."
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      azurerm_key_vault_secret.scope_management_encryption_key_2 \
      "${SECRET_VERSION_ID}" 2>&1; then
      echo "  ✓ Imported azurerm_key_vault_secret.scope_management_encryption_key_2"
    else
      echo "  ⚠️  Failed to import scope_management_encryption_key_2"
    fi
  else
    echo "  ⚠️  Secret not found, will be created on apply"
  fi
else
  echo "  ✓ azurerm_key_vault_secret.scope_management_encryption_key_2 already in state, skipping"
fi

# ============================================================================
# OPENAI AND DOCUMENT INTELLIGENCE SECRETS
# ============================================================================
echo ""
echo "=========================================="
echo "Importing OpenAI and Document Intelligence Secrets"
echo "=========================================="
echo ""

# OpenAI Endpoint Secret
echo "Checking module.openai.azurerm_key_vault_secret.endpoint[\"cognitive-account-swedencentral\"]..."
if ! terraform state show 'module.openai.azurerm_key_vault_secret.endpoint["cognitive-account-swedencentral"]' >/dev/null 2>&1; then
  SECRET_VERSION_ID=$(az keyvault secret show \
    --vault-name "${KEY_VAULT_CORE_NAME}" \
    --name "cognitive-account-swedencentral-ep" \
    --query id -o tsv 2>/dev/null || echo "")
  
  if [ -n "${SECRET_VERSION_ID}" ]; then
    echo "  Importing module.openai.azurerm_key_vault_secret.endpoint[\"cognitive-account-swedencentral\"]..."
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.openai.azurerm_key_vault_secret.endpoint["cognitive-account-swedencentral"]' \
      "${SECRET_VERSION_ID}" 2>&1; then
      echo "  ✓ Imported module.openai.azurerm_key_vault_secret.endpoint[\"cognitive-account-swedencentral\"]"
    else
      echo "  ⚠️  Failed to import OpenAI endpoint secret"
    fi
  else
    echo "  ⚠️  Secret not found, will be created on apply"
  fi
else
  echo "  ✓ module.openai.azurerm_key_vault_secret.endpoint[\"cognitive-account-swedencentral\"] already in state, skipping"
fi

# OpenAI Model Version Endpoints
echo "Checking module.openai.azurerm_key_vault_secret.model_version_endpoints[0]..."
if ! terraform state show 'module.openai.azurerm_key_vault_secret.model_version_endpoints[0]' >/dev/null 2>&1; then
  SECRET_VERSION_ID=$(az keyvault secret show \
    --vault-name "${KEY_VAULT_CORE_NAME}" \
    --name "azure-openai-endpoint-definitions" \
    --query id -o tsv 2>/dev/null || echo "")
  
  if [ -n "${SECRET_VERSION_ID}" ]; then
    echo "  Importing module.openai.azurerm_key_vault_secret.model_version_endpoints[0]..."
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.openai.azurerm_key_vault_secret.model_version_endpoints[0]' \
      "${SECRET_VERSION_ID}" 2>&1; then
      echo "  ✓ Imported module.openai.azurerm_key_vault_secret.model_version_endpoints[0]"
    else
      echo "  ⚠️  Failed to import OpenAI model version endpoints secret"
    fi
  else
    echo "  ⚠️  Secret not found, will be created on apply"
  fi
else
  echo "  ✓ module.openai.azurerm_key_vault_secret.model_version_endpoints[0] already in state, skipping"
fi

# Document Intelligence Endpoint Definitions
echo "Checking module.document_intelligence.azurerm_key_vault_secret.azure_document_intelligence_endpoint_definitions[0]..."
if ! terraform state show 'module.document_intelligence.azurerm_key_vault_secret.azure_document_intelligence_endpoint_definitions[0]' >/dev/null 2>&1; then
  SECRET_VERSION_ID=$(az keyvault secret show \
    --vault-name "${KEY_VAULT_CORE_NAME}" \
    --name "azure-document-intelligence-endpoint-definitions" \
    --query id -o tsv 2>/dev/null || echo "")
  
  if [ -n "${SECRET_VERSION_ID}" ]; then
    echo "  Importing module.document_intelligence.azurerm_key_vault_secret.azure_document_intelligence_endpoint_definitions[0]..."
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.document_intelligence.azurerm_key_vault_secret.azure_document_intelligence_endpoint_definitions[0]' \
      "${SECRET_VERSION_ID}" 2>&1; then
      echo "  ✓ Imported module.document_intelligence.azurerm_key_vault_secret.azure_document_intelligence_endpoint_definitions[0]"
    else
      echo "  ⚠️  Failed to import Document Intelligence endpoint definitions secret"
    fi
  else
    echo "  ⚠️  Secret not found, will be created on apply"
  fi
else
  echo "  ✓ module.document_intelligence.azurerm_key_vault_secret.azure_document_intelligence_endpoint_definitions[0] already in state, skipping"
fi

# Document Intelligence Endpoints
echo "Checking module.document_intelligence.azurerm_key_vault_secret.azure_document_intelligence_endpoints[0]..."
if ! terraform state show 'module.document_intelligence.azurerm_key_vault_secret.azure_document_intelligence_endpoints[0]' >/dev/null 2>&1; then
  SECRET_VERSION_ID=$(az keyvault secret show \
    --vault-name "${KEY_VAULT_CORE_NAME}" \
    --name "azure-document-intelligence-endpoints" \
    --query id -o tsv 2>/dev/null || echo "")
  
  if [ -n "${SECRET_VERSION_ID}" ]; then
    echo "  Importing module.document_intelligence.azurerm_key_vault_secret.azure_document_intelligence_endpoints[0]..."
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.document_intelligence.azurerm_key_vault_secret.azure_document_intelligence_endpoints[0]' \
      "${SECRET_VERSION_ID}" 2>&1; then
      echo "  ✓ Imported module.document_intelligence.azurerm_key_vault_secret.azure_document_intelligence_endpoints[0]"
    else
      echo "  ⚠️  Failed to import Document Intelligence endpoints secret"
    fi
  else
    echo "  ⚠️  Secret not found, will be created on apply"
  fi
else
  echo "  ✓ module.document_intelligence.azurerm_key_vault_secret.azure_document_intelligence_endpoints[0] already in state, skipping"
fi

# Document Intelligence Key (Form Recognizer)
echo "Checking module.document_intelligence.azurerm_key_vault_secret.key[\"swedencentral-form-recognizer\"]..."
if ! terraform state show 'module.document_intelligence.azurerm_key_vault_secret.key["swedencentral-form-recognizer"]' >/dev/null 2>&1; then
  SECRET_VERSION_ID=$(az keyvault secret show \
    --vault-name "${KEY_VAULT_CORE_NAME}" \
    --name "swedencentral-form-recognizer-key" \
    --query id -o tsv 2>/dev/null || echo "")
  
  if [ -n "${SECRET_VERSION_ID}" ]; then
    echo "  Importing module.document_intelligence.azurerm_key_vault_secret.key[\"swedencentral-form-recognizer\"]..."
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.document_intelligence.azurerm_key_vault_secret.key["swedencentral-form-recognizer"]' \
      "${SECRET_VERSION_ID}" 2>&1; then
      echo "  ✓ Imported module.document_intelligence.azurerm_key_vault_secret.key[\"swedencentral-form-recognizer\"]"
    else
      echo "  ⚠️  Failed to import Document Intelligence key secret"
    fi
  else
    echo "  ⚠️  Secret not found, will be created on apply"
  fi
else
  echo "  ✓ module.document_intelligence.azurerm_key_vault_secret.key[\"swedencentral-form-recognizer\"] already in state, skipping"
fi

# ============================================================================
# POSTGRESQL MANAGEMENT LOCK
# ============================================================================
echo ""
echo "=========================================="
echo "Importing PostgreSQL Management Lock"
echo "=========================================="
echo ""

echo "Checking module.postgresql.azurerm_management_lock.can_not_delete_server[0]..."
if ! terraform state show 'module.postgresql.azurerm_management_lock.can_not_delete_server[0]' >/dev/null 2>&1; then
  # Try to find the lock on the PostgreSQL server
  LOCK_ID=$(az lock list \
    --resource-group "${RESOURCE_GROUP_SENSITIVE_NAME}" \
    --resource-name "${POSTGRESQL_SERVER_NAME}" \
    --resource-type "Microsoft.DBforPostgreSQL/flexibleServers" \
    --query "[?lockLevel=='CanNotDelete'].id" -o tsv 2>/dev/null | head -1 || echo "")
  
  if [ -n "${LOCK_ID}" ]; then
    echo "  Importing module.postgresql.azurerm_management_lock.can_not_delete_server[0]..."
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.postgresql.azurerm_management_lock.can_not_delete_server[0]' \
      "${LOCK_ID}" 2>&1; then
      echo "  ✓ Imported module.postgresql.azurerm_management_lock.can_not_delete_server[0]"
    else
      echo "  ⚠️  Failed to import PostgreSQL management lock"
    fi
  else
    echo "  ⚠️  Management lock not found, will be created on apply"
  fi
else
  echo "  ✓ module.postgresql.azurerm_management_lock.can_not_delete_server[0] already in state, skipping"
fi

# ============================================================================
# COMPLETION
# ============================================================================
echo ""
echo "=========================================="
echo "Import Script Completed! 🎉"
echo "Completed at: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="
echo ""
echo "Summary of resources covered:"
echo "  - Audit Storage: identity, storage account, CMK, containers, management policy"
echo "  - Federated Identity Credentials: 6 workload identities"
echo "  - Role Assignments: AGIC, AKS, CSI, DNS, audit storage (11 total)"
echo "  - Scope Management Secrets: 2 encryption key secrets"
echo "  - OpenAI/Document Intelligence Secrets: 5 secrets"
echo "  - PostgreSQL Management Lock: 1 lock"
echo ""
echo "Next steps:"
echo "  1. Run 'terraform plan' to verify the imports"
echo "  2. Review any remaining drift (random_id resources cannot be imported)"
echo "  3. If satisfied, you can copy sections from this script into import_azure_resources.sh"
echo ""
echo "==========================================================================="
echo "DRIFT DOCUMENTATION"
echo "==========================================================================="
echo ""
echo "Resources that CANNOT be imported (expected drift):"
echo ""
echo "1. random_id.scope_management_encryption_key_1"
echo "   - Reason: random_id resources do not support import"
echo "   - Impact: Will show as 'to be created' in plan"
echo "   - Resolution: Values are deterministic based on keepers, so will remain stable"
echo ""
echo "2. random_id.scope_management_encryption_key_2"
echo "   - Reason: random_id resources do not support import"
echo "   - Impact: Will show as 'to be created' in plan"
echo "   - Resolution: Values are deterministic based on keepers, so will remain stable"
echo ""
echo "All other resources should import successfully if they exist in Azure."
echo "==========================================================================="
echo ""
