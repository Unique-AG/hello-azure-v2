#!/bin/bash
# Terraform import commands for Day-1 resources
# Usage: ./import_azure_resources.sh test
#        ./import_azure_resources.sh dev
#
# IMPORTANT: Before running this script, you need to:
# 1. Get the actual Azure resource IDs for each resource
# 2. Replace the placeholder values (marked with TODO) with actual IDs
# 3. Ensure terraform is initialized: terraform init -backend-config=../environments/test/backend-config-day-1.hcl
#
# To get resource IDs:
# - Resource Groups: az group show --name <rg-name> --query id -o tsv
# - Managed Identities: az identity show --name <identity-name> --resource-group <rg-name> --query id -o tsv
# - Role Definitions: az role definition list --name "<role-name>" --query "[0].id" -o tsv
# - VNet: az network vnet show --name <vnet-name> --resource-group <rg-name> --query id -o tsv
# - Subnets: az network vnet subnet show --vnet-name <vnet-name> --resource-group <rg-name> --name <subnet-name> --query id -o tsv

set -euo pipefail

ENV="${1:-test}"
VAR_CONFIG="../environments/${ENV}/00-config-day-1.auto.tfvars"
VAR_PARAMS="../environments/${ENV}/00-parameters-day-1.auto.tfvars"

# Subscription ID - get from config or set here
SUBSCRIPTION_ID="${SUBSCRIPTION_ID:-782871a0-bcee-44fb-851f-ccd3e69ada2a}"

echo "=========================================="
echo "Day-1 Resource Import Script"
echo "Environment: ${ENV}"
echo "=========================================="
echo ""
echo "⚠️  WARNING: This script contains placeholder resource IDs."
echo "   You must replace all TODO placeholders with actual Azure resource IDs before running."
echo ""

# Check if variable files exist
if [[ ! -f "${VAR_CONFIG}" ]]; then
  echo "Error: Variable file not found: ${VAR_CONFIG}"
  exit 1
fi
if [[ ! -f "${VAR_PARAMS}" ]]; then
  echo "Error: Variable file not found: ${VAR_PARAMS}"
  exit 1
fi

# Read resource group names from VAR_PARAMS (needed for managed identities and other resources)
RESOURCE_GROUP_CORE_NAME=$(grep "^resource_group_core_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "resource-group-core")
RESOURCE_GROUP_SENSITIVE_NAME=$(grep "^resource_group_sensitive_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "resource-group-sensitive")

# Resource Groups
echo "=========================================="
echo "Importing Resource Groups"
echo "=========================================="
echo ""

echo "Checking azurerm_resource_group.vnet..."
if ! terraform state show azurerm_resource_group.vnet >/dev/null 2>&1; then
  echo "  Importing azurerm_resource_group.vnet..."
  # TODO: Replace with actual resource group ID
  # Get with: az group show --name rg-vnet-002 --query id -o tsv
  RESOURCE_GROUP_VNET_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/rg-vnet-002"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_resource_group.vnet \
    "${RESOURCE_GROUP_VNET_ID}"
  echo "  ✓ Imported azurerm_resource_group.vnet"
else
  echo "  ✓ azurerm_resource_group.vnet already in state, skipping"
fi

echo "Checking azurerm_resource_group.core..."
if ! terraform state show azurerm_resource_group.core >/dev/null 2>&1; then
  echo "  Importing azurerm_resource_group.core..."
  # Get with: az group show --name <resource_group_core_name> --query id -o tsv
  RESOURCE_GROUP_CORE_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_resource_group.core \
    "${RESOURCE_GROUP_CORE_ID}"
  echo "  ✓ Imported azurerm_resource_group.core"
else
  echo "  ✓ azurerm_resource_group.core already in state, skipping"
fi

echo "Checking azurerm_resource_group.sensitive..."
if ! terraform state show azurerm_resource_group.sensitive >/dev/null 2>&1; then
  echo "  Importing azurerm_resource_group.sensitive..."
  # Get with: az group show --name <resource_group_sensitive_name> --query id -o tsv
  RESOURCE_GROUP_SENSITIVE_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE_NAME}"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_resource_group.sensitive \
    "${RESOURCE_GROUP_SENSITIVE_ID}"
  echo "  ✓ Imported azurerm_resource_group.sensitive"
else
  echo "  ✓ azurerm_resource_group.sensitive already in state, skipping"
fi

echo ""
echo "=========================================="
echo "Importing Subscription Provider Registrations"
echo "=========================================="
echo ""

echo "Checking azurerm_resource_provider_registration.azure_dashboard_provider..."
if ! terraform state show azurerm_resource_provider_registration.azure_dashboard_provider >/dev/null 2>&1; then
  echo "  Importing azurerm_resource_provider_registration.azure_dashboard_provider..."
  PROVIDER_ID="/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Dashboard"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_resource_provider_registration.azure_dashboard_provider \
    "${PROVIDER_ID}"
  echo "  ✓ Imported azurerm_resource_provider_registration.azure_dashboard_provider"
else
  echo "  ✓ azurerm_resource_provider_registration.azure_dashboard_provider already in state, skipping"
fi

echo "Checking azurerm_resource_provider_registration.azure_monitor_provider..."
if ! terraform state show azurerm_resource_provider_registration.azure_monitor_provider >/dev/null 2>&1; then
  echo "  Importing azurerm_resource_provider_registration.azure_monitor_provider..."
  PROVIDER_ID="/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Monitor"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_resource_provider_registration.azure_monitor_provider \
    "${PROVIDER_ID}"
  echo "  ✓ Imported azurerm_resource_provider_registration.azure_monitor_provider"
else
  echo "  ✓ azurerm_resource_provider_registration.azure_monitor_provider already in state, skipping"
fi

echo "Checking azurerm_resource_provider_registration.azure_alerts_provider..."
if ! terraform state show azurerm_resource_provider_registration.azure_alerts_provider >/dev/null 2>&1; then
  echo "  Importing azurerm_resource_provider_registration.azure_alerts_provider..."
  PROVIDER_ID="/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.AlertsManagement"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_resource_provider_registration.azure_alerts_provider \
    "${PROVIDER_ID}"
  echo "  ✓ Imported azurerm_resource_provider_registration.azure_alerts_provider"
else
  echo "  ✓ azurerm_resource_provider_registration.azure_alerts_provider already in state, skipping"
fi

echo ""
echo "=========================================="
echo "Importing Subscription Budgets"
echo "=========================================="
echo ""

echo "Checking azurerm_consumption_budget_subscription.subscription_budget..."
if ! terraform state show azurerm_consumption_budget_subscription.subscription_budget >/dev/null 2>&1; then
  echo "  Importing azurerm_consumption_budget_subscription.subscription_budget..."
  # Read subscription_budget_name from VAR_PARAMS or use default
  BUDGET_NAME=$(grep "^subscription_budget_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "subscription_budget")
  BUDGET_ID="/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Consumption/budgets/${BUDGET_NAME}"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_consumption_budget_subscription.subscription_budget \
    "${BUDGET_ID}"
  echo "  ✓ Imported azurerm_consumption_budget_subscription.subscription_budget"
else
  echo "  ✓ azurerm_consumption_budget_subscription.subscription_budget already in state, skipping"
fi

echo ""
echo "=========================================="
echo "Importing Public IPs"
echo "=========================================="
echo ""

echo "Checking azurerm_public_ip.aks_public_ip..."
if ! terraform state show azurerm_public_ip.aks_public_ip >/dev/null 2>&1; then
  echo "  Importing azurerm_public_ip.aks_public_ip..."
  # Get with: az network public-ip show --name <aks_public_ip_name> --resource-group <resource_group_core_name> --query id -o tsv
  # Read aks_public_ip_name from VAR_PARAMS or use default
  AKS_PUBLIC_IP_NAME=$(grep "^aks_public_ip_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "aks_public_ip")
  PUBLIC_IP_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.Network/publicIPAddresses/${AKS_PUBLIC_IP_NAME}"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_public_ip.aks_public_ip \
    "${PUBLIC_IP_ID}"
  echo "  ✓ Imported azurerm_public_ip.aks_public_ip"
else
  echo "  ✓ azurerm_public_ip.aks_public_ip already in state, skipping"
fi

echo ""
echo "=========================================="
echo "Importing Virtual Network Module Resources"
echo "=========================================="
echo ""
echo "⚠️  Note: The vnet module uses azapi_resource (not azurerm resources)."
echo "   azapi_resource import may not work reliably due to provider limitations."
echo "   If imports fail, run 'terraform plan' to see if resources need to be created"
echo "   or if they're already managed by Terraform."
echo ""
echo "   Resources to attempt importing:"
echo "   - module.vnet.azapi_resource.vnet"
echo "   - module.vnet.module.subnet[\"snet-aks-pods\"].azapi_resource.subnet"
echo "   - module.vnet.module.subnet[\"snet-aks-nodes\"].azapi_resource.subnet"
echo "   - module.vnet.module.subnet[\"snet-agw\"].azapi_resource.subnet"
echo "   - module.vnet.module.subnet[\"snet-cognitive\"].azapi_resource.subnet"
echo "   - module.vnet.module.subnet[\"snet-kv\"].azapi_resource.subnet"
echo "   - module.vnet.module.subnet[\"snet-psql\"].azapi_resource.subnet"
echo "   - module.vnet.module.subnet[\"snet-redis\"].azapi_resource.subnet"
echo "   - module.vnet.module.subnet[\"snet-storage\"].azapi_resource.subnet"
echo "   - module.vnet.module.subnet[\"snet-github\"].azapi_resource.subnet"
echo ""

# Virtual Network
echo "Checking module.vnet resources..."
# Get VNet resource group name
VNET_RG_NAME="rg-vnet-002"
VNET_NAME="vnet-001"

# The VNet module uses azapi_resource, not azurerm_virtual_network
# NOTE: azapi_resource import may not work reliably. If import fails, the resource may already exist
# or may need to be managed differently. Check terraform plan after running this script.
echo "Checking module.vnet.azapi_resource.vnet..."
if ! terraform state show module.vnet.azapi_resource.vnet >/dev/null 2>&1; then
  echo "  Attempting to import module.vnet.azapi_resource.vnet..."
  # Get with: az network vnet show --name vnet-001 --resource-group rg-vnet-002 --query id -o tsv
  VNET_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${VNET_RG_NAME}/providers/Microsoft.Network/virtualNetworks/${VNET_NAME}"
  set +e  # Temporarily disable exit on error for this import attempt
  IMPORT_OUTPUT=$(terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    module.vnet.azapi_resource.vnet \
    "${VNET_ID}" 2>&1)
  IMPORT_EXIT_CODE=$?
  set -e  # Re-enable exit on error
  
  if [ ${IMPORT_EXIT_CODE} -eq 0 ]; then
    echo "  ✓ Imported module.vnet.azapi_resource.vnet"
  else
    echo "  ⚠️  Import failed for module.vnet.azapi_resource.vnet (exit code: ${IMPORT_EXIT_CODE})"
    echo "     This may be expected - azapi resources may not support standard import."
    echo "     Error: ${IMPORT_OUTPUT}"
    echo "     Run 'terraform plan' to check if the resource needs to be created or is already managed."
  fi
else
  echo "  ✓ module.vnet.azapi_resource.vnet already in state, skipping"
fi

# Subnets - import each subnet
# The module uses nested subnet modules with azapi_resource
# Format: "terraform-key:actual-azure-subnet-name"
# Note: Terraform uses keys like "snet-agw" but Azure uses names like "snet-application-gateway"
declare -a SUBNETS=(
  "snet-aks-pods:snet-aks-pods"
  "snet-aks-nodes:snet-aks-nodes"
  "snet-agw:snet-application-gateway"
  "snet-cognitive:snet-cognitive-services"
  "snet-kv:snet-key-vault"
  "snet-psql:snet-postgres"
  "snet-redis:snet-redis"
  "snet-storage:snet-storage"
  "snet-github:snet-github-runners"
)

for subnet_pair in "${SUBNETS[@]}"; do
  IFS=':' read -r subnet_key subnet_name <<< "${subnet_pair}"
  RESOURCE_ADDRESS="module.vnet.module.subnet[\"${subnet_key}\"].azapi_resource.subnet"
  if ! terraform state show "${RESOURCE_ADDRESS}" >/dev/null 2>&1; then
    echo "  Attempting to import ${RESOURCE_ADDRESS}..."
    # Get with: az network vnet subnet show --vnet-name vnet-001 --resource-group rg-vnet-002 --name ${subnet_name} --query id -o tsv
    # Note: Use actual Azure subnet name, not the terraform key
    SUBNET_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${VNET_RG_NAME}/providers/Microsoft.Network/virtualNetworks/${VNET_NAME}/subnets/${subnet_name}"
    set +e  # Temporarily disable exit on error for this import attempt
    IMPORT_OUTPUT=$(terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      "${RESOURCE_ADDRESS}" \
      "${SUBNET_ID}" 2>&1)
    IMPORT_EXIT_CODE=$?
    set -e  # Re-enable exit on error
    
    if [ ${IMPORT_EXIT_CODE} -eq 0 ]; then
      echo "  ✓ Imported ${RESOURCE_ADDRESS}"
    else
      echo "  ⚠️  Import failed for ${RESOURCE_ADDRESS} (exit code: ${IMPORT_EXIT_CODE})"
      echo "     This may be expected - azapi resources may not support standard import."
      echo "     Error: ${IMPORT_OUTPUT}"
      echo "     Run 'terraform plan' to check if the resource needs to be created or is already managed."
    fi
  else
    echo "  ✓ ${RESOURCE_ADDRESS} already in state, skipping"
  fi
done

echo ""
echo "=========================================="
echo "Importing Managed Identities"
echo "=========================================="
echo ""

# Read identity names from VAR_PARAMS
PSQL_IDENTITY_NAME=$(grep "^psql_user_assigned_identity_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "")
INGESTION_CACHE_IDENTITY_NAME=$(grep "^ingestion_cache_identity_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "")
INGESTION_STORAGE_IDENTITY_NAME=$(grep "^ingestion_storage_identity_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "")
DOCUMENT_INTELLIGENCE_IDENTITY_NAME=$(grep "^document_intelligence_identity_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "")
AKS_IDENTITY_NAME=$(grep "^aks_user_assigned_identity_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "")
GRAFANA_IDENTITY_NAME=$(grep "^grafana_identity_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "")

# Managed Identities are in sensitive resource group except document_intelligence and aks_workload which are in core
echo "Checking azurerm_user_assigned_identity.psql_identity..."
if ! terraform state show azurerm_user_assigned_identity.psql_identity >/dev/null 2>&1; then
  if [[ -n "${PSQL_IDENTITY_NAME}" ]]; then
    echo "  Importing azurerm_user_assigned_identity.psql_identity..."
    # TODO: Replace with actual identity ID
    # Get with: az identity show --name ${PSQL_IDENTITY_NAME} --resource-group ${RESOURCE_GROUP_SENSITIVE_NAME} --query id -o tsv
    PSQL_IDENTITY_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${PSQL_IDENTITY_NAME}"
    terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      azurerm_user_assigned_identity.psql_identity \
      "${PSQL_IDENTITY_ID}"
    echo "  ✓ Imported azurerm_user_assigned_identity.psql_identity"
  else
    echo "  ⚠️  psql_user_assigned_identity_name not found in ${VAR_PARAMS}, skipping"
  fi
else
  echo "  ✓ azurerm_user_assigned_identity.psql_identity already in state, skipping"
fi

echo "Checking azurerm_user_assigned_identity.ingestion_cache_identity..."
if ! terraform state show azurerm_user_assigned_identity.ingestion_cache_identity >/dev/null 2>&1; then
  if [[ -n "${INGESTION_CACHE_IDENTITY_NAME}" ]]; then
    echo "  Importing azurerm_user_assigned_identity.ingestion_cache_identity..."
    # TODO: Replace with actual identity ID
    INGESTION_CACHE_IDENTITY_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${INGESTION_CACHE_IDENTITY_NAME}"
    terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      azurerm_user_assigned_identity.ingestion_cache_identity \
      "${INGESTION_CACHE_IDENTITY_ID}"
    echo "  ✓ Imported azurerm_user_assigned_identity.ingestion_cache_identity"
  else
    echo "  ⚠️  ingestion_cache_identity_name not found in ${VAR_PARAMS}, skipping"
  fi
else
  echo "  ✓ azurerm_user_assigned_identity.ingestion_cache_identity already in state, skipping"
fi

echo "Checking azurerm_user_assigned_identity.ingestion_storage_identity..."
if ! terraform state show azurerm_user_assigned_identity.ingestion_storage_identity >/dev/null 2>&1; then
  if [[ -n "${INGESTION_STORAGE_IDENTITY_NAME}" ]]; then
    echo "  Importing azurerm_user_assigned_identity.ingestion_storage_identity..."
    # TODO: Replace with actual identity ID
    INGESTION_STORAGE_IDENTITY_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${INGESTION_STORAGE_IDENTITY_NAME}"
    terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      azurerm_user_assigned_identity.ingestion_storage_identity \
      "${INGESTION_STORAGE_IDENTITY_ID}"
    echo "  ✓ Imported azurerm_user_assigned_identity.ingestion_storage_identity"
  else
    echo "  ⚠️  ingestion_storage_identity_name not found in ${VAR_PARAMS}, skipping"
  fi
else
  echo "  ✓ azurerm_user_assigned_identity.ingestion_storage_identity already in state, skipping"
fi

echo "Checking azurerm_user_assigned_identity.document_intelligence_identity..."
if ! terraform state show azurerm_user_assigned_identity.document_intelligence_identity >/dev/null 2>&1; then
  if [[ -n "${DOCUMENT_INTELLIGENCE_IDENTITY_NAME}" ]]; then
    echo "  Importing azurerm_user_assigned_identity.document_intelligence_identity..."
    # TODO: Replace with actual identity ID
    DOCUMENT_INTELLIGENCE_IDENTITY_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${DOCUMENT_INTELLIGENCE_IDENTITY_NAME}"
    terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      azurerm_user_assigned_identity.document_intelligence_identity \
      "${DOCUMENT_INTELLIGENCE_IDENTITY_ID}"
    echo "  ✓ Imported azurerm_user_assigned_identity.document_intelligence_identity"
  else
    echo "  ⚠️  document_intelligence_identity_name not found in ${VAR_PARAMS}, skipping"
  fi
else
  echo "  ✓ azurerm_user_assigned_identity.document_intelligence_identity already in state, skipping"
fi

echo "Checking azurerm_user_assigned_identity.aks_workload_identity..."
if ! terraform state show azurerm_user_assigned_identity.aks_workload_identity >/dev/null 2>&1; then
  if [[ -n "${AKS_IDENTITY_NAME}" ]]; then
    echo "  Importing azurerm_user_assigned_identity.aks_workload_identity..."
    # TODO: Replace with actual identity ID
    AKS_IDENTITY_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${AKS_IDENTITY_NAME}"
    terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      azurerm_user_assigned_identity.aks_workload_identity \
      "${AKS_IDENTITY_ID}"
    echo "  ✓ Imported azurerm_user_assigned_identity.aks_workload_identity"
  else
    echo "  ⚠️  aks_user_assigned_identity_name not found in ${VAR_PARAMS}, skipping"
  fi
else
  echo "  ✓ azurerm_user_assigned_identity.aks_workload_identity already in state, skipping"
fi

echo "Checking azurerm_user_assigned_identity.grafana_identity..."
if ! terraform state show azurerm_user_assigned_identity.grafana_identity >/dev/null 2>&1; then
  if [[ -n "${GRAFANA_IDENTITY_NAME}" ]]; then
    echo "  Importing azurerm_user_assigned_identity.grafana_identity..."
    # TODO: Replace with actual identity ID
    GRAFANA_IDENTITY_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${GRAFANA_IDENTITY_NAME}"
    terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      azurerm_user_assigned_identity.grafana_identity \
      "${GRAFANA_IDENTITY_ID}"
    echo "  ✓ Imported azurerm_user_assigned_identity.grafana_identity"
  else
    echo "  ⚠️  grafana_identity_name not found in ${VAR_PARAMS}, skipping"
  fi
else
  echo "  ✓ azurerm_user_assigned_identity.grafana_identity already in state, skipping"
fi

echo ""
echo "=========================================="
echo "Importing Custom Role Definitions"
echo "=========================================="
echo ""

# Custom Role Definitions
# Import format: {role_definition_resource_id}|{scope}
# The role_definition_resource_id is the full Azure resource ID, and scope is the subscription ID
SUBSCRIPTION_SCOPE="/subscriptions/${SUBSCRIPTION_ID}"

# Role definition IDs from terraform state
# Format: /subscriptions/{subscription-id}/providers/Microsoft.Authorization/roleDefinitions/{guid}|/subscriptions/{subscription-id}
echo "Checking azurerm_role_definition.emergency_admin..."
if ! terraform state show azurerm_role_definition.emergency_admin >/dev/null 2>&1; then
  echo "  Importing azurerm_role_definition.emergency_admin..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_role_definition.emergency_admin \
    "/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Authorization/roleDefinitions/14e570ce-b6dc-f404-9eb9-ff271205cf34|${SUBSCRIPTION_SCOPE}"
  echo "  ✓ Imported azurerm_role_definition.emergency_admin"
else
  echo "  ✓ azurerm_role_definition.emergency_admin already in state, skipping"
fi

echo "Checking azurerm_role_definition.devops_preview..."
if ! terraform state show azurerm_role_definition.devops_preview >/dev/null 2>&1; then
  echo "  Importing azurerm_role_definition.devops_preview..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_role_definition.devops_preview \
    "/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Authorization/roleDefinitions/a36ac756-3599-98f8-350d-153655fddbfd|${SUBSCRIPTION_SCOPE}"
  echo "  ✓ Imported azurerm_role_definition.devops_preview"
else
  echo "  ✓ azurerm_role_definition.devops_preview already in state, skipping"
fi

echo "Checking azurerm_role_definition.telemetry_observer..."
if ! terraform state show azurerm_role_definition.telemetry_observer >/dev/null 2>&1; then
  echo "  Importing azurerm_role_definition.telemetry_observer..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_role_definition.telemetry_observer \
    "/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Authorization/roleDefinitions/175b5d34-3284-ec30-7aba-dd7a2502cab5|${SUBSCRIPTION_SCOPE}"
  echo "  ✓ Imported azurerm_role_definition.telemetry_observer"
else
  echo "  ✓ azurerm_role_definition.telemetry_observer already in state, skipping"
fi

echo "Checking azurerm_role_definition.sensitive_data_observer..."
if ! terraform state show azurerm_role_definition.sensitive_data_observer >/dev/null 2>&1; then
  echo "  Importing azurerm_role_definition.sensitive_data_observer..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_role_definition.sensitive_data_observer \
    "/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Authorization/roleDefinitions/79b5d30f-05b2-5a6b-1483-9677cb5916c1|${SUBSCRIPTION_SCOPE}"
  echo "  ✓ Imported azurerm_role_definition.sensitive_data_observer"
else
  echo "  ✓ azurerm_role_definition.sensitive_data_observer already in state, skipping"
fi

echo "Checking azurerm_role_definition.vnet_subnet_access..."
if ! terraform state show azurerm_role_definition.vnet_subnet_access >/dev/null 2>&1; then
  echo "  Importing azurerm_role_definition.vnet_subnet_access..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_role_definition.vnet_subnet_access \
    "/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Authorization/roleDefinitions/601d68ee-cef2-0d84-e696-34a9bf0e3b0f|${SUBSCRIPTION_SCOPE}"
  echo "  ✓ Imported azurerm_role_definition.vnet_subnet_access"
else
  echo "  ✓ azurerm_role_definition.vnet_subnet_access already in state, skipping"
fi

echo "Checking azurerm_role_definition.acr_puller..."
if ! terraform state show azurerm_role_definition.acr_puller >/dev/null 2>&1; then
  echo "  Importing azurerm_role_definition.acr_puller..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_role_definition.acr_puller \
    "/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Authorization/roleDefinitions/0e36e8b9-0905-d27c-50c1-f162bc5a533e|${SUBSCRIPTION_SCOPE}"
  echo "  ✓ Imported azurerm_role_definition.acr_puller"
else
  echo "  ✓ azurerm_role_definition.acr_puller already in state, skipping"
fi

# DNS Zones and Records
echo ""
echo "=========================================="
echo "Importing DNS Zones and Records..."
echo "=========================================="

# Read DNS zone name from VAR_PARAMS
DNS_ZONE_NAME=$(grep "^dns_zone_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "")
PSQL_DNS_ZONE_NAME=$(grep "^psql_private_dns_zone_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "psql.postgres.database.azure.com")
SPEECH_DNS_ZONE_NAME=$(grep "^speech_service_private_dns_zone_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "")

RESOURCE_GROUP_VNET_NAME=$(grep "^resource_group_vnet_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "rg-vnet-002")

echo "Checking azurerm_dns_zone.dns_zone..."
if ! terraform state show azurerm_dns_zone.dns_zone >/dev/null 2>&1; then
  echo "  Importing azurerm_dns_zone.dns_zone..."
  # TODO: Replace with actual DNS zone resource ID
  # Get with: az network dns zone show --name <zone-name> --resource-group <rg-name> --query id -o tsv
  DNS_ZONE_ID="${DNS_ZONE_ID:-/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_VNET_NAME}/providers/Microsoft.Network/dnsZones/${DNS_ZONE_NAME}}"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_dns_zone.dns_zone \
    "${DNS_ZONE_ID}"
  echo "  ✓ Imported azurerm_dns_zone.dns_zone"
else
  echo "  ✓ azurerm_dns_zone.dns_zone already in state, skipping"
fi

echo "Checking azurerm_private_dns_zone.psql_private_dns_zone..."
if ! terraform state show azurerm_private_dns_zone.psql_private_dns_zone >/dev/null 2>&1; then
  echo "  Importing azurerm_private_dns_zone.psql_private_dns_zone..."
  # TODO: Replace with actual private DNS zone resource ID
  # Get with: az network private-dns zone show --name <zone-name> --resource-group <rg-name> --query id -o tsv
  PSQL_DNS_ZONE_ID="${PSQL_DNS_ZONE_ID:-/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_VNET_NAME}/providers/Microsoft.Network/privateDnsZones/${PSQL_DNS_ZONE_NAME}}"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_private_dns_zone.psql_private_dns_zone \
    "${PSQL_DNS_ZONE_ID}"
  echo "  ✓ Imported azurerm_private_dns_zone.psql_private_dns_zone"
else
  echo "  ✓ azurerm_private_dns_zone.psql_private_dns_zone already in state, skipping"
fi

echo "Checking azurerm_private_dns_zone.speech_service_private_dns_zone..."
if ! terraform state show azurerm_private_dns_zone.speech_service_private_dns_zone >/dev/null 2>&1; then
  echo "  Importing azurerm_private_dns_zone.speech_service_private_dns_zone..."
  # TODO: Replace with actual private DNS zone resource ID
  # Get with: az network private-dns zone show --name <zone-name> --resource-group <rg-name> --query id -o tsv
  SPEECH_DNS_ZONE_ID="${SPEECH_DNS_ZONE_ID:-/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_VNET_NAME}/providers/Microsoft.Network/privateDnsZones/${SPEECH_DNS_ZONE_NAME}}"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_private_dns_zone.speech_service_private_dns_zone \
    "${SPEECH_DNS_ZONE_ID}"
  echo "  ✓ Imported azurerm_private_dns_zone.speech_service_private_dns_zone"
else
  echo "  ✓ azurerm_private_dns_zone.speech_service_private_dns_zone already in state, skipping"
fi

# DNS A Records
echo ""
echo "Importing DNS A Records..."
echo "Checking azurerm_dns_a_record.adnsar_root..."
if ! terraform state show azurerm_dns_a_record.adnsar_root >/dev/null 2>&1; then
  echo "  Importing azurerm_dns_a_record.adnsar_root..."
  # DNS A record ID format: /subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.Network/dnsZones/{zone}/A/{name}
  # From terraform.tfstate: /subscriptions/782871a0-bcee-44fb-851f-ccd3e69ada2a/resourceGroups/rg-vnet-002/providers/Microsoft.Network/dnsZones/test-hello.azure.unique.dev/A/@
  DNS_A_ROOT_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_VNET_NAME}/providers/Microsoft.Network/dnsZones/${DNS_ZONE_NAME}/A/@"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_dns_a_record.adnsar_root \
    "${DNS_A_ROOT_ID}"
  echo "  ✓ Imported azurerm_dns_a_record.adnsar_root"
else
  echo "  ✓ azurerm_dns_a_record.adnsar_root already in state, skipping"
fi

# Import subdomain A records
echo "Checking azurerm_dns_a_record.adnsar_sub_domains..."
# The keys in the original state are: api, argo, zitadel
# Note: zitadel has name "id" but key "zitadel"
declare -A SUBDOMAIN_NAMES=(
  ["api"]="api"
  ["argo"]="argo"
  ["zitadel"]="id"
)

for subdomain_key in api argo zitadel; do
  echo "Checking azurerm_dns_a_record.adnsar_sub_domains[\"${subdomain_key}\"]..."
  if ! terraform state show "azurerm_dns_a_record.adnsar_sub_domains[\"${subdomain_key}\"]" >/dev/null 2>&1; then
    echo "  Importing azurerm_dns_a_record.adnsar_sub_domains[\"${subdomain_key}\"]..."
    # Get the actual subdomain name (DNS record name, not the key)
    # Try to get from variable first, otherwise use the mapping
    SUBDOMAIN_NAME=$(grep -A 10 "dns_zone_sub_domain_records\|dns_subdomain_records" "${VAR_PARAMS}" 2>/dev/null | grep -A 5 "${subdomain_key}" | grep "name" | cut -d'"' -f2 | head -1)
    if [ -z "${SUBDOMAIN_NAME}" ]; then
      SUBDOMAIN_NAME="${SUBDOMAIN_NAMES[${subdomain_key}]}"
    fi
    # DNS A record ID format: /subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.Network/dnsZones/{zone}/A/{name}
    DNS_A_SUBDOMAIN_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_VNET_NAME}/providers/Microsoft.Network/dnsZones/${DNS_ZONE_NAME}/A/${SUBDOMAIN_NAME}"
    terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      "azurerm_dns_a_record.adnsar_sub_domains[\"${subdomain_key}\"]" \
      "${DNS_A_SUBDOMAIN_ID}"
    echo "  ✓ Imported azurerm_dns_a_record.adnsar_sub_domains[\"${subdomain_key}\"]"
  else
    echo "  ✓ azurerm_dns_a_record.adnsar_sub_domains[\"${subdomain_key}\"] already in state, skipping"
  fi
done

# Private DNS Zone Virtual Network Links
echo ""
echo "Importing Private DNS Zone Virtual Network Links..."
echo "Checking azurerm_private_dns_zone_virtual_network_link.psql-private-dns-zone-vnet-link..."
if ! terraform state show azurerm_private_dns_zone_virtual_network_link.psql-private-dns-zone-vnet-link >/dev/null 2>&1; then
  echo "  Importing azurerm_private_dns_zone_virtual_network_link.psql-private-dns-zone-vnet-link..."
  # Private DNS zone VNet link ID format: /subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.Network/privateDnsZones/{zone}/virtualNetworkLinks/{link-name}
  # From terraform.tfstate: /subscriptions/782871a0-bcee-44fb-851f-ccd3e69ada2a/resourceGroups/rg-vnet-002/providers/Microsoft.Network/privateDnsZones/psql.postgres.database.azure.com/virtualNetworkLinks/PsqlVnetZone.com
  PSQL_VNET_LINK_NAME=$(grep "^azurerm_private_dns_zone_virtual_network_link_name\|^azurerm_private_dns_zone_virtual_network_link_name" "${VAR_PARAMS}" 2>/dev/null | cut -d'"' -f2 | head -1 || echo "PsqlVnetZone.com")
  PSQL_VNET_LINK_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_VNET_NAME}/providers/Microsoft.Network/privateDnsZones/${PSQL_DNS_ZONE_NAME}/virtualNetworkLinks/${PSQL_VNET_LINK_NAME}"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_private_dns_zone_virtual_network_link.psql-private-dns-zone-vnet-link \
    "${PSQL_VNET_LINK_ID}"
  echo "  ✓ Imported azurerm_private_dns_zone_virtual_network_link.psql-private-dns-zone-vnet-link"
else
  echo "  ✓ azurerm_private_dns_zone_virtual_network_link.psql-private-dns-zone-vnet-link already in state, skipping"
fi

echo "Checking azurerm_private_dns_zone_virtual_network_link.speech_service_private_dns_zone_vnet_link..."
if ! terraform state show azurerm_private_dns_zone_virtual_network_link.speech_service_private_dns_zone_vnet_link >/dev/null 2>&1; then
  echo "  Importing azurerm_private_dns_zone_virtual_network_link.speech_service_private_dns_zone_vnet_link..."
  # Private DNS zone VNet link ID format: /subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.Network/privateDnsZones/{zone}/virtualNetworkLinks/{link-name}
  # From terraform.tfstate: /subscriptions/782871a0-bcee-44fb-851f-ccd3e69ada2a/resourceGroups/rg-vnet-002/providers/Microsoft.Network/privateDnsZones/privatelink.cognitiveservices.azure.com/virtualNetworkLinks/speech-service-private-dns-zone-vnet-link-test
  SPEECH_VNET_LINK_NAME=$(grep "^speech_service_private_dns_zone_virtual_network_link_name" "${VAR_PARAMS}" 2>/dev/null | cut -d'"' -f2 | head -1 || echo "")
  SPEECH_VNET_LINK_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_VNET_NAME}/providers/Microsoft.Network/privateDnsZones/${SPEECH_DNS_ZONE_NAME}/virtualNetworkLinks/${SPEECH_VNET_LINK_NAME}"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_private_dns_zone_virtual_network_link.speech_service_private_dns_zone_vnet_link \
    "${SPEECH_VNET_LINK_ID}"
  echo "  ✓ Imported azurerm_private_dns_zone_virtual_network_link.speech_service_private_dns_zone_vnet_link"
else
  echo "  ✓ azurerm_private_dns_zone_virtual_network_link.speech_service_private_dns_zone_vnet_link already in state, skipping"
fi

echo ""
echo "=========================================="
echo "Importing Key Vaults"
echo "=========================================="
echo ""

# Read Key Vault names from VAR_PARAMS or use defaults
MAIN_KV_NAME_PREFIX=$(grep "^main_kv_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "hakv1")
SENSITIVE_KV_NAME_PREFIX=$(grep "^sensitive_kv_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "hakv2")

# Compute full Key Vault names (matching local.main_kv_name and local.sensitive_kv_name pattern)
# Pattern: ${var.main_kv_name}${var.env}v2
# We need to get env from VAR_CONFIG or VAR_PARAMS
ENV_VALUE=$(grep "^env" "${VAR_CONFIG}" "${VAR_PARAMS}" 2>/dev/null | head -1 | cut -d'"' -f2 || echo "${ENV}")
MAIN_KV_NAME="${MAIN_KV_NAME_PREFIX}${ENV_VALUE}v2"
SENSITIVE_KV_NAME="${SENSITIVE_KV_NAME_PREFIX}${ENV_VALUE}v2"

echo "Checking azurerm_key_vault.main_kv..."
if ! terraform state show azurerm_key_vault.main_kv >/dev/null 2>&1; then
  echo "  Importing azurerm_key_vault.main_kv..."
  echo "  Key Vault name: ${MAIN_KV_NAME}"
  echo "  Resource Group: ${RESOURCE_GROUP_CORE_NAME}"
  # Get with: az keyvault show --name ${MAIN_KV_NAME} --resource-group ${RESOURCE_GROUP_CORE_NAME} --query id -o tsv
  MAIN_KV_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.KeyVault/vaults/${MAIN_KV_NAME}"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_key_vault.main_kv \
    "${MAIN_KV_ID}"
  echo "  ✓ Imported azurerm_key_vault.main_kv"
else
  echo "  ✓ azurerm_key_vault.main_kv already in state, skipping"
fi

echo "Checking azurerm_key_vault.sensitive_kv..."
if ! terraform state show azurerm_key_vault.sensitive_kv >/dev/null 2>&1; then
  echo "  Importing azurerm_key_vault.sensitive_kv..."
  echo "  Key Vault name: ${SENSITIVE_KV_NAME}"
  echo "  Resource Group: ${RESOURCE_GROUP_SENSITIVE_NAME}"
  # Get with: az keyvault show --name ${SENSITIVE_KV_NAME} --resource-group ${RESOURCE_GROUP_SENSITIVE_NAME} --query id -o tsv
  SENSITIVE_KV_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE_NAME}/providers/Microsoft.KeyVault/vaults/${SENSITIVE_KV_NAME}"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_key_vault.sensitive_kv \
    "${SENSITIVE_KV_ID}"
  echo "  ✓ Imported azurerm_key_vault.sensitive_kv"
else
  echo "  ✓ azurerm_key_vault.sensitive_kv already in state, skipping"
fi

echo ""
echo "=========================================="
echo "Importing Log Analytics Workspace"
echo "=========================================="
echo ""

echo "Checking azurerm_log_analytics_workspace.this..."
if ! terraform state show azurerm_log_analytics_workspace.this >/dev/null 2>&1; then
  echo "  Importing azurerm_log_analytics_workspace.this..."
  # Read log_analytics_workspace_name from VAR_PARAMS and construct the full name with env suffix
  # The actual workspace name in Azure includes the environment suffix (e.g., "la-test")
  LOG_ANALYTICS_WORKSPACE_BASE_NAME=$(grep "^log_analytics_workspace_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "la")
  LOG_ANALYTICS_WORKSPACE_NAME="${LOG_ANALYTICS_WORKSPACE_BASE_NAME}-${ENV}"
  # Get with: az monitor log-analytics workspace show --resource-group <resource_group_core_name> --workspace-name <log_analytics_workspace_name> --query id -o tsv
  LOG_ANALYTICS_WORKSPACE_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.OperationalInsights/workspaces/${LOG_ANALYTICS_WORKSPACE_NAME}"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azurerm_log_analytics_workspace.this \
    "${LOG_ANALYTICS_WORKSPACE_ID}"
  echo "  ✓ Imported azurerm_log_analytics_workspace.this"
else
  echo "  ✓ azurerm_log_analytics_workspace.this already in state, skipping"
fi

echo ""
echo "=========================================="
echo "Import script completed!"
echo "=========================================="
echo "Next steps:"
echo "   - Review and update all TODO placeholders with actual resource IDs"
echo "   - Run 'terraform plan' to verify imports and identify any missing resources"
echo "   - Import any additional resources shown in the plan"
echo "   - Some cosmetic drifts are expected (API versions, etc.)"
echo ""

