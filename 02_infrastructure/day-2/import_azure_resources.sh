#!/bin/bash
# Terraform import commands for Day-2 resources
# Usage: ./import_azure_resources.sh test
#        ./import_azure_resources.sh dev

set -euo pipefail

ENV="${1:-test}"
VAR_CONFIG="../environments/${ENV}/00-config-day-2.auto.tfvars"
VAR_PARAMS="../environments/${ENV}/00-parameters-day-2.auto.tfvars"
SERVICE_PRINCIPAL_ID="5dbf19b3-6943-4696-9334-55b8c5566010"

echo "=========================================="
echo "Day-2 Resource Import Script"
echo "Environment: ${ENV}"
echo "=========================================="
echo ""

# Azure AD Groups
echo "Checking azuread_group.telemetry_observer..."
if ! terraform state show azuread_group.telemetry_observer >/dev/null 2>&1; then
  echo "  Importing azuread_group.telemetry_observer..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azuread_group.telemetry_observer \
    "/groups/3e60cd87-c622-44d7-801f-fc691822d0ca"
  echo "  ✓ Imported azuread_group.telemetry_observer"
else
  echo "  ✓ azuread_group.telemetry_observer already in state, skipping"
fi

echo "Checking azuread_group.sensitive_data_observer..."
if ! terraform state show azuread_group.sensitive_data_observer >/dev/null 2>&1; then
  echo "  Importing azuread_group.sensitive_data_observer..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azuread_group.sensitive_data_observer \
    "/groups/5be17159-b6e6-4823-b478-c9430f90ebe1"
  echo "  ✓ Imported azuread_group.sensitive_data_observer"
else
  echo "  ✓ azuread_group.sensitive_data_observer already in state, skipping"
fi

echo "Checking azuread_group.devops..."
if ! terraform state show azuread_group.devops >/dev/null 2>&1; then
  echo "  Importing azuread_group.devops..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azuread_group.devops \
    "/groups/dfffea4f-9516-4a4d-ad56-b21c4f174b82"
  echo "  ✓ Imported azuread_group.devops"
else
  echo "  ✓ azuread_group.devops already in state, skipping"
fi

echo "Checking azuread_group.emergency_admin..."
if ! terraform state show azuread_group.emergency_admin >/dev/null 2>&1; then
  echo "  Importing azuread_group.emergency_admin..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azuread_group.emergency_admin \
    "/groups/3139d505-c738-49ca-8182-b9f4b334059b"
  echo "  ✓ Imported azuread_group.emergency_admin"
else
  echo "  ✓ azuread_group.emergency_admin already in state, skipping"
fi

echo "Checking azuread_group.admin_kubernetes_cluster..."
if ! terraform state show azuread_group.admin_kubernetes_cluster >/dev/null 2>&1; then
  echo "  Importing azuread_group.admin_kubernetes_cluster..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azuread_group.admin_kubernetes_cluster \
    "/groups/a435bed7-88b3-464f-bc3c-ba000d37ece5"
  echo "  ✓ Imported azuread_group.admin_kubernetes_cluster"
else
  echo "  ✓ azuread_group.admin_kubernetes_cluster already in state, skipping"
fi

echo "Checking azuread_group.main_keyvault_secret_writer..."
if ! terraform state show azuread_group.main_keyvault_secret_writer >/dev/null 2>&1; then
  echo "  Importing azuread_group.main_keyvault_secret_writer..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azuread_group.main_keyvault_secret_writer \
    "/groups/fa8f2e2c-154e-4d4a-a99c-7dfa825858ef"
  echo "  ✓ Imported azuread_group.main_keyvault_secret_writer"
else
  echo "  ✓ azuread_group.main_keyvault_secret_writer already in state, skipping"
fi

echo ""
echo "Importing Azure AD Service Principal and Application Registration resources..."
echo ""

# Azure AD Service Principal for Microsoft Graph
echo "Checking azuread_service_principal.msgraph..."
if ! terraform state show azuread_service_principal.msgraph >/dev/null 2>&1; then
  echo "  Importing azuread_service_principal.msgraph..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    azuread_service_principal.msgraph \
    "/servicePrincipals/29c402c3-5bb1-4677-9a9b-80f77cd74944"
  echo "  ✓ Imported azuread_service_principal.msgraph"
else
  echo "  ✓ azuread_service_principal.msgraph already in state, skipping"
fi

# Application Registration Module Resources
echo "Checking module.application_registration.azuread_application.this..."
if ! terraform state show module.application_registration.azuread_application.this >/dev/null 2>&1; then
  echo "  Importing module.application_registration.azuread_application.this..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    module.application_registration.azuread_application.this \
    "/applications/6f3b9b9b-c440-4696-883d-ea19a0a3b554"
  echo "  ✓ Imported module.application_registration.azuread_application.this"
else
  echo "  ✓ module.application_registration.azuread_application.this already in state, skipping"
fi

echo "Checking module.application_registration.azuread_service_principal.this..."
if ! terraform state show module.application_registration.azuread_service_principal.this >/dev/null 2>&1; then
  echo "  Importing module.application_registration.azuread_service_principal.this..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    module.application_registration.azuread_service_principal.this \
    "/servicePrincipals/${SERVICE_PRINCIPAL_ID}"
  echo "  ✓ Imported module.application_registration.azuread_service_principal.this"
else
  echo "  ✓ module.application_registration.azuread_service_principal.this already in state, skipping"
fi

# Random UUID for maintainers role
echo "Checking module.application_registration.random_uuid.maintainers..."
if ! terraform state show module.application_registration.random_uuid.maintainers >/dev/null 2>&1; then
  echo "  Importing module.application_registration.random_uuid.maintainers..."
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    module.application_registration.random_uuid.maintainers \
    "2ca08d18-0116-978f-bc4e-a110cc8a12d9"
  echo "  ✓ Imported module.application_registration.random_uuid.maintainers"
else
  echo "  ✓ module.application_registration.random_uuid.maintainers already in state, skipping"
fi

# Application App Roles
if ! terraform state show module.application_registration.azuread_application_app_role.maintainers >/dev/null 2>&1; then
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    module.application_registration.azuread_application_app_role.maintainers \
    "/applications/6f3b9b9b-c440-4696-883d-ea19a0a3b554/appRoles/2ca08d18-0116-978f-bc4e-a110cc8a12d9"
fi

if ! terraform state show 'module.application_registration.azuread_application_app_role.managed_roles["application_support"]' >/dev/null 2>&1; then
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    'module.application_registration.azuread_application_app_role.managed_roles["application_support"]' \
    "/applications/6f3b9b9b-c440-4696-883d-ea19a0a3b554/appRoles/719570d9-6707-40f4-9193-29ae0745392e"
fi

if ! terraform state show 'module.application_registration.azuread_application_app_role.managed_roles["infrastructure_support"]' >/dev/null 2>&1; then
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    'module.application_registration.azuread_application_app_role.managed_roles["infrastructure_support"]' \
    "/applications/6f3b9b9b-c440-4696-883d-ea19a0a3b554/appRoles/0a7f4e66-4942-4a2e-a433-82e54464f116"
fi

if ! terraform state show 'module.application_registration.azuread_application_app_role.managed_roles["system_support"]' >/dev/null 2>&1; then
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    'module.application_registration.azuread_application_app_role.managed_roles["system_support"]' \
    "/applications/6f3b9b9b-c440-4696-883d-ea19a0a3b554/appRoles/8719acef-9791-41e4-9621-92d05315181c"
fi

if ! terraform state show 'module.application_registration.azuread_application_app_role.managed_roles["user"]' >/dev/null 2>&1; then
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    'module.application_registration.azuread_application_app_role.managed_roles["user"]' \
    "/applications/6f3b9b9b-c440-4696-883d-ea19a0a3b554/appRoles/6a902661-cfac-44f4-846c-bc5ceaa012d4"
fi

# Application Password
# NOTE: azuread_application_password does NOT support import
# The password value is only available at creation time and cannot be retrieved from Azure AD
# This resource will need to be created fresh or the password will be regenerated
# if ! terraform state show 'module.application_registration.azuread_application_password.aad_app_password[0]' >/dev/null 2>&1; then
#   terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
#     'module.application_registration.azuread_application_password.aad_app_password[0]' \
#     "/applications/6f3b9b9b-c440-4696-883d-ea19a0a3b554/password/fa3e3b35-6c30-4a97-b5f9-1fe3f30d195d"
# fi

# App Role Assignments - Maintainers
if ! terraform state show 'module.application_registration.azuread_app_role_assignment.maintainers["084a1c45-5010-4aab-bab6-7b86a9d10e5c"]' >/dev/null 2>&1; then
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    'module.application_registration.azuread_app_role_assignment.maintainers["084a1c45-5010-4aab-bab6-7b86a9d10e5c"]' \
    "/servicePrincipals/${SERVICE_PRINCIPAL_ID}/appRoleAssignedTo/RRxKCBBQq0q6tnuGqdEOXEeWO3NWueZItSB0uhLHfLQ"
fi

if ! terraform state show 'module.application_registration.azuread_app_role_assignment.maintainers["3b48f167-cb68-4655-b45b-878e170af84d"]' >/dev/null 2>&1; then
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    'module.application_registration.azuread_app_role_assignment.maintainers["3b48f167-cb68-4655-b45b-878e170af84d"]' \
    "/servicePrincipals/${SERVICE_PRINCIPAL_ID}/appRoleAssignedTo/Z_FIO2jLVUa0W4eOFwr4TTafg3vVXT5Em4jqhTXUjt8"
fi

if ! terraform state show 'module.application_registration.azuread_app_role_assignment.maintainers["4b89a1f0-8038-4929-81e6-6d128dac7aa0"]' >/dev/null 2>&1; then
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    'module.application_registration.azuread_app_role_assignment.maintainers["4b89a1f0-8038-4929-81e6-6d128dac7aa0"]' \
    "/servicePrincipals/${SERVICE_PRINCIPAL_ID}/appRoleAssignedTo/8KGJSziAKUmB5m0Sjax6oF3WDUAtnwpAhQJJAOJZjLQ"
fi

if ! terraform state show 'module.application_registration.azuread_app_role_assignment.maintainers["4ee4611f-b24c-444b-8d34-edab333bf868"]' >/dev/null 2>&1; then
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    'module.application_registration.azuread_app_role_assignment.maintainers["4ee4611f-b24c-444b-8d34-edab333bf868"]' \
    "/servicePrincipals/${SERVICE_PRINCIPAL_ID}/appRoleAssignedTo/H2HkTkyyS0SNNO2rMzv4aEeaT8GgFQFCo2P1rtQyp3s"
fi

# App Role Assignments - Managed Roles (application_support)
if ! terraform state show 'module.application_registration.azuread_app_role_assignment.managed_roles["application_support:084a1c45-5010-4aab-bab6-7b86a9d10e5c"]' >/dev/null 2>&1; then
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    'module.application_registration.azuread_app_role_assignment.managed_roles["application_support:084a1c45-5010-4aab-bab6-7b86a9d10e5c"]' \
    "/servicePrincipals/${SERVICE_PRINCIPAL_ID}/appRoleAssignedTo/RRxKCBBQq0q6tnuGqdEOXCe-72KXeWRBs_OM6Qk-K3A"
fi

if ! terraform state show 'module.application_registration.azuread_app_role_assignment.managed_roles["application_support:3b48f167-cb68-4655-b45b-878e170af84d"]' >/dev/null 2>&1; then
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    'module.application_registration.azuread_app_role_assignment.managed_roles["application_support:3b48f167-cb68-4655-b45b-878e170af84d"]' \
    "/servicePrincipals/${SERVICE_PRINCIPAL_ID}/appRoleAssignedTo/Z_FIO2jLVUa0W4eOFwr4TdnphcTuf0xIqmODzGXHbBg"
fi

if ! terraform state show 'module.application_registration.azuread_app_role_assignment.managed_roles["application_support:4b89a1f0-8038-4929-81e6-6d128dac7aa0"]' >/dev/null 2>&1; then
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    'module.application_registration.azuread_app_role_assignment.managed_roles["application_support:4b89a1f0-8038-4929-81e6-6d128dac7aa0"]' \
    "/servicePrincipals/${SERVICE_PRINCIPAL_ID}/appRoleAssignedTo/8KGJSziAKUmB5m0Sjax6oLIA2TWno25PoU_6NU8h3wE"
fi

if ! terraform state show 'module.application_registration.azuread_app_role_assignment.managed_roles["application_support:4ee4611f-b24c-444b-8d34-edab333bf868"]' >/dev/null 2>&1; then
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    'module.application_registration.azuread_app_role_assignment.managed_roles["application_support:4ee4611f-b24c-444b-8d34-edab333bf868"]' \
    "/servicePrincipals/${SERVICE_PRINCIPAL_ID}/appRoleAssignedTo/H2HkTkyyS0SNNO2rMzv4aEvieKf9F0RJhH8NS1WYbUs"
fi

# App Role Assignments - Managed Roles (user)
if ! terraform state show 'module.application_registration.azuread_app_role_assignment.managed_roles["user:084a1c45-5010-4aab-bab6-7b86a9d10e5c"]' >/dev/null 2>&1; then
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    'module.application_registration.azuread_app_role_assignment.managed_roles["user:084a1c45-5010-4aab-bab6-7b86a9d10e5c"]' \
    "/servicePrincipals/${SERVICE_PRINCIPAL_ID}/appRoleAssignedTo/RRxKCBBQq0q6tnuGqdEOXGbH1YDlewtDmQTItNgzE08"
fi

if ! terraform state show 'module.application_registration.azuread_app_role_assignment.managed_roles["user:3b48f167-cb68-4655-b45b-878e170af84d"]' >/dev/null 2>&1; then
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    'module.application_registration.azuread_app_role_assignment.managed_roles["user:3b48f167-cb68-4655-b45b-878e170af84d"]' \
    "/servicePrincipals/${SERVICE_PRINCIPAL_ID}/appRoleAssignedTo/Z_FIO2jLVUa0W4eOFwr4TYRyzkPg6slBiQMy4oG5wZE"
fi

if ! terraform state show 'module.application_registration.azuread_app_role_assignment.managed_roles["user:4b89a1f0-8038-4929-81e6-6d128dac7aa0"]' >/dev/null 2>&1; then
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    'module.application_registration.azuread_app_role_assignment.managed_roles["user:4b89a1f0-8038-4929-81e6-6d128dac7aa0"]' \
    "/servicePrincipals/${SERVICE_PRINCIPAL_ID}/appRoleAssignedTo/8KGJSziAKUmB5m0Sjax6oHhDPWazNnpMsDPxtUeOPB8"
fi

if ! terraform state show 'module.application_registration.azuread_app_role_assignment.managed_roles["user:4ee4611f-b24c-444b-8d34-edab333bf868"]' >/dev/null 2>&1; then
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    'module.application_registration.azuread_app_role_assignment.managed_roles["user:4ee4611f-b24c-444b-8d34-edab333bf868"]' \
    "/servicePrincipals/${SERVICE_PRINCIPAL_ID}/appRoleAssignedTo/H2HkTkyyS0SNNO2rMzv4aHU7MVR2up9KnsngViZrQVQ"
fi

# Storage Accounts
echo ""
echo "=========================================="
echo "Storage Accounts"
echo "=========================================="
echo ""

# Extract storage account names and key vault name from variables
# Try to get from tfvars, otherwise use defaults
INGESTION_CACHE_SA_BASE=$(grep "^ingestion_cache_sa_name" "${VAR_PARAMS}" 2>/dev/null | cut -d'"' -f2 || echo "uqhacache")
INGESTION_STORAGE_SA_BASE=$(grep "^ingestion_storage_sa_name" "${VAR_PARAMS}" 2>/dev/null | cut -d'"' -f2 || echo "uqhastorage")
RESOURCE_GROUP_SENSITIVE=$(grep "^resource_group_sensitive_name" "${VAR_PARAMS}" 2>/dev/null | cut -d'"' -f2 || echo "")
SENSITIVE_KV_NAME=$(grep "^sensitive_kv_name" "${VAR_PARAMS}" 2>/dev/null | cut -d'"' -f2 || echo "")
ENV_NAME=$(grep "^env" "${VAR_PARAMS}" 2>/dev/null | head -1 | sed -E 's/^env\s*=\s*"?([^"]+)"?.*/\1/' | tr -d ' ' || echo "")

# Construct full storage account names (base + env)
INGESTION_CACHE_SA_NAME="${INGESTION_CACHE_SA_BASE}${ENV_NAME}"
INGESTION_STORAGE_SA_NAME="${INGESTION_STORAGE_SA_BASE}${ENV_NAME}"

if [ -z "${RESOURCE_GROUP_SENSITIVE}" ] || [ -z "${SENSITIVE_KV_NAME}" ] || [ -z "${ENV_NAME}" ]; then
  echo "⚠️  Key vault name, resource group, or environment not found in config files, skipping storage account imports"
  echo "   RESOURCE_GROUP_SENSITIVE: ${RESOURCE_GROUP_SENSITIVE:-<empty>}"
  echo "   SENSITIVE_KV_NAME: ${SENSITIVE_KV_NAME:-<empty>}"
  echo "   ENV_NAME: ${ENV_NAME:-<empty>}"
else
  SUBSCRIPTION_ID=$(az account show --query id -o tsv 2>/dev/null || echo "")
  if [ -z "${SUBSCRIPTION_ID}" ]; then
    echo "⚠️  Could not get Azure subscription ID, skipping storage account imports"
  else
    KEY_VAULT_NAME="${SENSITIVE_KV_NAME}${ENV_NAME}v2"
    
    # Import ingestion_cache storage account
    echo "Checking module.ingestion_cache.azurerm_storage_account.storage_account..."
    if ! terraform state show 'module.ingestion_cache.azurerm_storage_account.storage_account' >/dev/null 2>&1; then
      echo "  Importing module.ingestion_cache.azurerm_storage_account.storage_account..."
      terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
        'module.ingestion_cache.azurerm_storage_account.storage_account' \
        "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE}/providers/Microsoft.Storage/storageAccounts/${INGESTION_CACHE_SA_NAME}"
      echo "  ✓ Imported module.ingestion_cache.azurerm_storage_account.storage_account"
    else
      echo "  ✓ module.ingestion_cache.azurerm_storage_account.storage_account already in state, skipping"
    fi

    # Import ingestion_cache Key Vault Key
    # Format: https://{vault-name}.vault.azure.net/keys/{key-name}/{version-id}
    echo "Checking module.ingestion_cache.azurerm_key_vault_key.storage-account-byok[0]..."
    if ! terraform state show 'module.ingestion_cache.azurerm_key_vault_key.storage-account-byok[0]' >/dev/null 2>&1; then
      KEY_VERSION=$(az keyvault key list-versions --vault-name "${KEY_VAULT_NAME}" --name "ingestion-cache-cmk" --query "[0].kid" -o tsv 2>/dev/null || echo "")
      if [ -n "${KEY_VERSION}" ]; then
        echo "  Importing module.ingestion_cache.azurerm_key_vault_key.storage-account-byok[0]..."
        terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
          'module.ingestion_cache.azurerm_key_vault_key.storage-account-byok[0]' \
          "${KEY_VERSION}"
        echo "  ✓ Imported module.ingestion_cache.azurerm_key_vault_key.storage-account-byok[0]"
      else
        echo "  ⚠️  Could not determine key version for ingestion-cache-cmk, skipping import"
        echo "      You may need to import manually: az keyvault key show --vault-name ${KEY_VAULT_NAME} --name ingestion-cache-cmk --query kid -o tsv"
      fi
    else
      echo "  ✓ module.ingestion_cache.azurerm_key_vault_key.storage-account-byok[0] already in state, skipping"
    fi

    # Import ingestion_cache Key Vault Secrets (requires version ID)
    echo "Checking module.ingestion_cache.azurerm_key_vault_secret.storage-account-connection-string-1[0]..."
    if ! terraform state show 'module.ingestion_cache.azurerm_key_vault_secret.storage-account-connection-string-1[0]' >/dev/null 2>&1; then
      SECRET_ID=$(az keyvault secret list-versions --vault-name "${KEY_VAULT_NAME}" --name "ingestion-cache-connection-string-1" --query "[0].id" -o tsv 2>/dev/null || echo "")
      if [ -n "${SECRET_ID}" ]; then
        echo "  Importing module.ingestion_cache.azurerm_key_vault_secret.storage-account-connection-string-1[0]..."
        terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
          'module.ingestion_cache.azurerm_key_vault_secret.storage-account-connection-string-1[0]' \
          "${SECRET_ID}"
        echo "  ✓ Imported module.ingestion_cache.azurerm_key_vault_secret.storage-account-connection-string-1[0]"
      else
        echo "  ⚠️  Could not determine secret version for ingestion-cache-connection-string-1, skipping import"
        echo "      You may need to import manually: az keyvault secret list-versions --vault-name ${KEY_VAULT_NAME} --name ingestion-cache-connection-string-1 --query '[0].id' -o tsv"
      fi
    else
      echo "  ✓ module.ingestion_cache.azurerm_key_vault_secret.storage-account-connection-string-1[0] already in state, skipping"
    fi

    echo "Checking module.ingestion_cache.azurerm_key_vault_secret.storage-account-connection-string-2[0]..."
    if ! terraform state show 'module.ingestion_cache.azurerm_key_vault_secret.storage-account-connection-string-2[0]' >/dev/null 2>&1; then
      SECRET_ID=$(az keyvault secret list-versions --vault-name "${KEY_VAULT_NAME}" --name "ingestion-cache-connection-string-2" --query "[0].id" -o tsv 2>/dev/null || echo "")
      if [ -n "${SECRET_ID}" ]; then
        echo "  Importing module.ingestion_cache.azurerm_key_vault_secret.storage-account-connection-string-2[0]..."
        terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
          'module.ingestion_cache.azurerm_key_vault_secret.storage-account-connection-string-2[0]' \
          "${SECRET_ID}"
        echo "  ✓ Imported module.ingestion_cache.azurerm_key_vault_secret.storage-account-connection-string-2[0]"
      else
        echo "  ⚠️  Could not determine secret version for ingestion-cache-connection-string-2, skipping import"
        echo "      You may need to import manually: az keyvault secret list-versions --vault-name ${KEY_VAULT_NAME} --name ingestion-cache-connection-string-2 --query '[0].id' -o tsv"
      fi
    else
      echo "  ✓ module.ingestion_cache.azurerm_key_vault_secret.storage-account-connection-string-2[0] already in state, skipping"
    fi

    # Import ingestion_cache Customer Managed Key
    echo "Checking module.ingestion_cache.azurerm_storage_account_customer_managed_key.storage_account_cmk[0]..."
    if ! terraform state show 'module.ingestion_cache.azurerm_storage_account_customer_managed_key.storage_account_cmk[0]' >/dev/null 2>&1; then
      echo "  Importing module.ingestion_cache.azurerm_storage_account_customer_managed_key.storage_account_cmk[0]..."
      terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
        'module.ingestion_cache.azurerm_storage_account_customer_managed_key.storage_account_cmk[0]' \
        "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE}/providers/Microsoft.Storage/storageAccounts/${INGESTION_CACHE_SA_NAME}"
      echo "  ✓ Imported module.ingestion_cache.azurerm_storage_account_customer_managed_key.storage_account_cmk[0]"
    else
      echo "  ✓ module.ingestion_cache.azurerm_storage_account_customer_managed_key.storage_account_cmk[0] already in state, skipping"
    fi

    # Import ingestion_cache Storage Management Policy
    echo "Checking module.ingestion_cache.azurerm_storage_management_policy.default[0]..."
    if ! terraform state show 'module.ingestion_cache.azurerm_storage_management_policy.default[0]' >/dev/null 2>&1; then
      echo "  Importing module.ingestion_cache.azurerm_storage_management_policy.default[0]..."
      terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
        'module.ingestion_cache.azurerm_storage_management_policy.default[0]' \
        "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE}/providers/Microsoft.Storage/storageAccounts/${INGESTION_CACHE_SA_NAME}/managementPolicies/default"
      echo "  ✓ Imported module.ingestion_cache.azurerm_storage_management_policy.default[0]"
    else
      echo "  ✓ module.ingestion_cache.azurerm_storage_management_policy.default[0] already in state, skipping"
    fi

    # Import ingestion_storage storage account
    echo "Checking module.ingestion_storage.azurerm_storage_account.storage_account..."
    if ! terraform state show 'module.ingestion_storage.azurerm_storage_account.storage_account' >/dev/null 2>&1; then
      echo "  Importing module.ingestion_storage.azurerm_storage_account.storage_account..."
      terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
        'module.ingestion_storage.azurerm_storage_account.storage_account' \
        "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE}/providers/Microsoft.Storage/storageAccounts/${INGESTION_STORAGE_SA_NAME}"
      echo "  ✓ Imported module.ingestion_storage.azurerm_storage_account.storage_account"
    else
      echo "  ✓ module.ingestion_storage.azurerm_storage_account.storage_account already in state, skipping"
    fi

    # Import ingestion_storage Key Vault Key
    # Format: https://{vault-name}.vault.azure.net/keys/{key-name}/{version-id}
    echo "Checking module.ingestion_storage.azurerm_key_vault_key.storage-account-byok[0]..."
    if ! terraform state show 'module.ingestion_storage.azurerm_key_vault_key.storage-account-byok[0]' >/dev/null 2>&1; then
      KEY_VERSION=$(az keyvault key list-versions --vault-name "${KEY_VAULT_NAME}" --name "ingestion-storage-cmk" --query "[0].kid" -o tsv 2>/dev/null || echo "")
      if [ -n "${KEY_VERSION}" ]; then
        echo "  Importing module.ingestion_storage.azurerm_key_vault_key.storage-account-byok[0]..."
        terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
          'module.ingestion_storage.azurerm_key_vault_key.storage-account-byok[0]' \
          "${KEY_VERSION}"
        echo "  ✓ Imported module.ingestion_storage.azurerm_key_vault_key.storage-account-byok[0]"
      else
        echo "  ⚠️  Could not determine key version for ingestion-storage-cmk, skipping import"
        echo "      You may need to import manually: az keyvault key show --vault-name ${KEY_VAULT_NAME} --name ingestion-storage-cmk --query kid -o tsv"
      fi
    else
      echo "  ✓ module.ingestion_storage.azurerm_key_vault_key.storage-account-byok[0] already in state, skipping"
    fi

    # Import ingestion_storage Key Vault Secrets
    echo "Checking module.ingestion_storage.azurerm_key_vault_secret.storage-account-connection-string-1[0]..."
    if ! terraform state show 'module.ingestion_storage.azurerm_key_vault_secret.storage-account-connection-string-1[0]' >/dev/null 2>&1; then
      SECRET_ID=$(az keyvault secret list-versions --vault-name "${KEY_VAULT_NAME}" --name "ingestion-storage-connection-string-1" --query "[0].id" -o tsv 2>/dev/null || echo "")
      if [ -n "${SECRET_ID}" ]; then
        echo "  Importing module.ingestion_storage.azurerm_key_vault_secret.storage-account-connection-string-1[0]..."
        terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
          'module.ingestion_storage.azurerm_key_vault_secret.storage-account-connection-string-1[0]' \
          "${SECRET_ID}"
        echo "  ✓ Imported module.ingestion_storage.azurerm_key_vault_secret.storage-account-connection-string-1[0]"
      else
        echo "  ⚠️  Could not determine secret version for ingestion-storage-connection-string-1, skipping import"
        echo "      You may need to import manually: az keyvault secret list-versions --vault-name ${KEY_VAULT_NAME} --name ingestion-storage-connection-string-1 --query '[0].id' -o tsv"
      fi
    else
      echo "  ✓ module.ingestion_storage.azurerm_key_vault_secret.storage-account-connection-string-1[0] already in state, skipping"
    fi

    echo "Checking module.ingestion_storage.azurerm_key_vault_secret.storage-account-connection-string-2[0]..."
    if ! terraform state show 'module.ingestion_storage.azurerm_key_vault_secret.storage-account-connection-string-2[0]' >/dev/null 2>&1; then
      SECRET_ID=$(az keyvault secret list-versions --vault-name "${KEY_VAULT_NAME}" --name "ingestion-storage-connection-string-2" --query "[0].id" -o tsv 2>/dev/null || echo "")
      if [ -n "${SECRET_ID}" ]; then
        echo "  Importing module.ingestion_storage.azurerm_key_vault_secret.storage-account-connection-string-2[0]..."
        terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
          'module.ingestion_storage.azurerm_key_vault_secret.storage-account-connection-string-2[0]' \
          "${SECRET_ID}"
        echo "  ✓ Imported module.ingestion_storage.azurerm_key_vault_secret.storage-account-connection-string-2[0]"
      else
        echo "  ⚠️  Could not determine secret version for ingestion-storage-connection-string-2, skipping import"
        echo "      You may need to import manually: az keyvault secret list-versions --vault-name ${KEY_VAULT_NAME} --name ingestion-storage-connection-string-2 --query '[0].id' -o tsv"
      fi
    else
      echo "  ✓ module.ingestion_storage.azurerm_key_vault_secret.storage-account-connection-string-2[0] already in state, skipping"
    fi

    # Import ingestion_storage Customer Managed Key
    echo "Checking module.ingestion_storage.azurerm_storage_account_customer_managed_key.storage_account_cmk[0]..."
    if ! terraform state show 'module.ingestion_storage.azurerm_storage_account_customer_managed_key.storage_account_cmk[0]' >/dev/null 2>&1; then
      echo "  Importing module.ingestion_storage.azurerm_storage_account_customer_managed_key.storage_account_cmk[0]..."
      terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
        'module.ingestion_storage.azurerm_storage_account_customer_managed_key.storage_account_cmk[0]' \
        "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE}/providers/Microsoft.Storage/storageAccounts/${INGESTION_STORAGE_SA_NAME}"
      echo "  ✓ Imported module.ingestion_storage.azurerm_storage_account_customer_managed_key.storage_account_cmk[0]"
    else
      echo "  ✓ module.ingestion_storage.azurerm_storage_account_customer_managed_key.storage_account_cmk[0] already in state, skipping"
    fi

    # Import ingestion_storage Storage Management Policy
    echo "Checking module.ingestion_storage.azurerm_storage_management_policy.default[0]..."
    if ! terraform state show 'module.ingestion_storage.azurerm_storage_management_policy.default[0]' >/dev/null 2>&1; then
      echo "  Importing module.ingestion_storage.azurerm_storage_management_policy.default[0]..."
      terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
        'module.ingestion_storage.azurerm_storage_management_policy.default[0]' \
        "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE}/providers/Microsoft.Storage/storageAccounts/${INGESTION_STORAGE_SA_NAME}/managementPolicies/default"
      echo "  ✓ Imported module.ingestion_storage.azurerm_storage_management_policy.default[0]"
    else
      echo "  ✓ module.ingestion_storage.azurerm_storage_management_policy.default[0] already in state, skipping"
    fi

    # Import Backup Resources for ingestion_cache
    echo ""
    echo "=========================================="
    echo "Backup Resources - ingestion_cache"
    echo "=========================================="
    echo ""
    
    BACKUP_VAULT_BASE_NAME="storage-backup-vault"
    BACKUP_POLICY_NAME="default-blob-backup-policy"
    BACKUP_INSTANCE_NAME="default-blob-backup-instance"
    
    # Import ingestion_cache Backup Vault
    echo "Checking module.ingestion_cache.azurerm_data_protection_backup_vault.backup_vault[0]..."
    if ! terraform state show 'module.ingestion_cache.azurerm_data_protection_backup_vault.backup_vault[0]' >/dev/null 2>&1; then
      # Try to find backup vault - it might have a random suffix
      BACKUP_VAULT_NAME=$(az dataprotection backup-vault list --resource-group "${RESOURCE_GROUP_SENSITIVE}" --query "[?starts_with(name, '${BACKUP_VAULT_BASE_NAME}')].name" -o tsv 2>/dev/null | head -1 || echo "")
      if [ -z "${BACKUP_VAULT_NAME}" ]; then
        # Try exact name match
        BACKUP_VAULT_NAME="${BACKUP_VAULT_BASE_NAME}"
      fi
      
      BACKUP_VAULT_ID=$(az dataprotection backup-vault show --resource-group "${RESOURCE_GROUP_SENSITIVE}" --vault-name "${BACKUP_VAULT_NAME}" --query id -o tsv 2>/dev/null || echo "")
      if [ -n "${BACKUP_VAULT_ID}" ]; then
        echo "  Found backup vault: ${BACKUP_VAULT_NAME}"
        echo "  Importing module.ingestion_cache.azurerm_data_protection_backup_vault.backup_vault[0]..."
        terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
          'module.ingestion_cache.azurerm_data_protection_backup_vault.backup_vault[0]' \
          "${BACKUP_VAULT_ID}"
        echo "  ✓ Imported module.ingestion_cache.azurerm_data_protection_backup_vault.backup_vault[0]"
      else
        echo "  ⚠️  Backup vault '${BACKUP_VAULT_BASE_NAME}' (or with suffix) not found, skipping backup resource imports"
        echo "      Backup resources may need to be created fresh or imported manually"
      fi
    else
      echo "  ✓ module.ingestion_cache.azurerm_data_protection_backup_vault.backup_vault[0] already in state, skipping"
      BACKUP_VAULT_ID=$(terraform state show 'module.ingestion_cache.azurerm_data_protection_backup_vault.backup_vault[0]' 2>/dev/null | grep "^id " | cut -d'"' -f2 || echo "")
      BACKUP_VAULT_NAME=$(echo "${BACKUP_VAULT_ID}" | sed -E 's|.*/backupVaults/([^/]+).*|\1|' || echo "")
    fi

    if [ -n "${BACKUP_VAULT_ID}" ] && [ -n "${BACKUP_VAULT_NAME}" ]; then
      # Import ingestion_cache Backup Policy
      echo "Checking module.ingestion_cache.azurerm_data_protection_backup_policy_blob_storage.backup_policy[0]..."
      if ! terraform state show 'module.ingestion_cache.azurerm_data_protection_backup_policy_blob_storage.backup_policy[0]' >/dev/null 2>&1; then
        # Try to find the policy by name (it might have a different name)
        BACKUP_POLICY_ID=$(az dataprotection backup-policy list --resource-group "${RESOURCE_GROUP_SENSITIVE}" --vault-name "${BACKUP_VAULT_NAME}" --query "[?name=='${BACKUP_POLICY_NAME}'].id" -o tsv 2>/dev/null | head -1 || echo "")
        if [ -z "${BACKUP_POLICY_ID}" ]; then
          # Fallback to constructed ID
          BACKUP_POLICY_ID="${BACKUP_VAULT_ID}/backupPolicies/${BACKUP_POLICY_NAME}"
        fi
        echo "  Importing module.ingestion_cache.azurerm_data_protection_backup_policy_blob_storage.backup_policy[0]..."
        terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
          'module.ingestion_cache.azurerm_data_protection_backup_policy_blob_storage.backup_policy[0]' \
          "${BACKUP_POLICY_ID}" 2>&1 || echo "  ⚠️  Failed to import backup policy, it may need to be created"
        if terraform state show 'module.ingestion_cache.azurerm_data_protection_backup_policy_blob_storage.backup_policy[0]' >/dev/null 2>&1; then
          echo "  ✓ Imported module.ingestion_cache.azurerm_data_protection_backup_policy_blob_storage.backup_policy[0]"
        fi
      else
        echo "  ✓ module.ingestion_cache.azurerm_data_protection_backup_policy_blob_storage.backup_policy[0] already in state, skipping"
      fi

      # Import ingestion_cache Backup Instance
      echo "Checking module.ingestion_cache.azurerm_data_protection_backup_instance_blob_storage.backup_instance[0]..."
      if ! terraform state show 'module.ingestion_cache.azurerm_data_protection_backup_instance_blob_storage.backup_instance[0]' >/dev/null 2>&1; then
        # Try to find the instance - it might be named differently
        BACKUP_INSTANCE_ID=$(az dataprotection backup-instance list --resource-group "${RESOURCE_GROUP_SENSITIVE}" --vault-name "${BACKUP_VAULT_NAME}" --query "[?contains(name, '${INGESTION_CACHE_SA_NAME}') || name=='${BACKUP_INSTANCE_NAME}'].id" -o tsv 2>/dev/null | head -1 || echo "")
        if [ -z "${BACKUP_INSTANCE_ID}" ]; then
          # Fallback to constructed ID
          BACKUP_INSTANCE_ID="${BACKUP_VAULT_ID}/backupInstances/${BACKUP_INSTANCE_NAME}"
        fi
        echo "  Importing module.ingestion_cache.azurerm_data_protection_backup_instance_blob_storage.backup_instance[0]..."
        terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
          'module.ingestion_cache.azurerm_data_protection_backup_instance_blob_storage.backup_instance[0]' \
          "${BACKUP_INSTANCE_ID}" 2>&1 || echo "  ⚠️  Failed to import backup instance, it may need to be created"
        if terraform state show 'module.ingestion_cache.azurerm_data_protection_backup_instance_blob_storage.backup_instance[0]' >/dev/null 2>&1; then
          echo "  ✓ Imported module.ingestion_cache.azurerm_data_protection_backup_instance_blob_storage.backup_instance[0]"
        fi
      else
        echo "  ✓ module.ingestion_cache.azurerm_data_protection_backup_instance_blob_storage.backup_instance[0] already in state, skipping"
      fi

      # Import ingestion_cache Backup Role Assignment
      echo "Checking module.ingestion_cache.azurerm_role_assignment.backup_vault_storage_access[0]..."
      if ! terraform state show 'module.ingestion_cache.azurerm_role_assignment.backup_vault_storage_access[0]' >/dev/null 2>&1; then
        # Get the principal ID from the backup vault identity
        BACKUP_VAULT_PRINCIPAL_ID=$(az dataprotection backup-vault show --resource-group "${RESOURCE_GROUP_SENSITIVE}" --vault-name "${BACKUP_VAULT_NAME}" --query "identity.principalId" -o tsv 2>/dev/null || echo "")
        if [ -n "${BACKUP_VAULT_PRINCIPAL_ID}" ]; then
          # Find the role assignment ID
          ROLE_ASSIGNMENT_ID=$(az role assignment list --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE}/providers/Microsoft.Storage/storageAccounts/${INGESTION_CACHE_SA_NAME}" --assignee "${BACKUP_VAULT_PRINCIPAL_ID}" --role "Storage Account Backup Contributor" --query "[0].id" -o tsv 2>/dev/null || echo "")
          if [ -n "${ROLE_ASSIGNMENT_ID}" ]; then
            echo "  Importing module.ingestion_cache.azurerm_role_assignment.backup_vault_storage_access[0]..."
            terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
              'module.ingestion_cache.azurerm_role_assignment.backup_vault_storage_access[0]' \
              "${ROLE_ASSIGNMENT_ID}"
            echo "  ✓ Imported module.ingestion_cache.azurerm_role_assignment.backup_vault_storage_access[0]"
          else
            echo "  ⚠️  Could not find role assignment for backup vault, skipping import"
          fi
        else
          echo "  ⚠️  Could not get backup vault principal ID, skipping role assignment import"
        fi
      else
        echo "  ✓ module.ingestion_cache.azurerm_role_assignment.backup_vault_storage_access[0] already in state, skipping"
      fi
    fi

    # Import Backup Resources for ingestion_storage
    echo ""
    echo "=========================================="
    echo "Backup Resources - ingestion_storage"
    echo "=========================================="
    echo ""
    
    # Import ingestion_storage Backup Vault (may be the same vault or different)
    echo "Checking module.ingestion_storage.azurerm_data_protection_backup_vault.backup_vault[0]..."
    if ! terraform state show 'module.ingestion_storage.azurerm_data_protection_backup_vault.backup_vault[0]' >/dev/null 2>&1; then
      # Try to get the backup vault ID (might be the same vault or different)
      if [ -z "${BACKUP_VAULT_ID}" ] || [ -z "${BACKUP_VAULT_NAME}" ]; then
        # Try to find backup vault - it might have a random suffix
        BACKUP_VAULT_NAME_STORAGE=$(az dataprotection backup-vault list --resource-group "${RESOURCE_GROUP_SENSITIVE}" --query "[?starts_with(name, '${BACKUP_VAULT_BASE_NAME}')].name" -o tsv 2>/dev/null | head -1 || echo "")
        if [ -z "${BACKUP_VAULT_NAME_STORAGE}" ]; then
          # Try exact name match
          BACKUP_VAULT_NAME_STORAGE="${BACKUP_VAULT_BASE_NAME}"
        fi
        BACKUP_VAULT_ID=$(az dataprotection backup-vault show --resource-group "${RESOURCE_GROUP_SENSITIVE}" --vault-name "${BACKUP_VAULT_NAME_STORAGE}" --query id -o tsv 2>/dev/null || echo "")
        if [ -n "${BACKUP_VAULT_ID}" ]; then
          BACKUP_VAULT_NAME="${BACKUP_VAULT_NAME_STORAGE}"
        fi
      fi
      if [ -n "${BACKUP_VAULT_ID}" ] && [ -n "${BACKUP_VAULT_NAME}" ]; then
        echo "  Found backup vault: ${BACKUP_VAULT_NAME}"
        echo "  Importing module.ingestion_storage.azurerm_data_protection_backup_vault.backup_vault[0]..."
        terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
          'module.ingestion_storage.azurerm_data_protection_backup_vault.backup_vault[0]' \
          "${BACKUP_VAULT_ID}"
        echo "  ✓ Imported module.ingestion_storage.azurerm_data_protection_backup_vault.backup_vault[0]"
      else
        echo "  ⚠️  Backup vault '${BACKUP_VAULT_BASE_NAME}' (or with suffix) not found, skipping backup resource imports"
      fi
    else
      echo "  ✓ module.ingestion_storage.azurerm_data_protection_backup_vault.backup_vault[0] already in state, skipping"
      if [ -z "${BACKUP_VAULT_ID}" ]; then
        BACKUP_VAULT_ID=$(terraform state show 'module.ingestion_storage.azurerm_data_protection_backup_vault.backup_vault[0]' 2>/dev/null | grep "^id " | cut -d'"' -f2 || echo "")
        BACKUP_VAULT_NAME=$(echo "${BACKUP_VAULT_ID}" | sed -E 's|.*/backupVaults/([^/]+).*|\1|' || echo "")
      fi
    fi

    if [ -n "${BACKUP_VAULT_ID}" ] && [ -n "${BACKUP_VAULT_NAME}" ]; then
      # Import ingestion_storage Backup Policy
      echo "Checking module.ingestion_storage.azurerm_data_protection_backup_policy_blob_storage.backup_policy[0]..."
      if ! terraform state show 'module.ingestion_storage.azurerm_data_protection_backup_policy_blob_storage.backup_policy[0]' >/dev/null 2>&1; then
        # Try to find the policy by name (it might have a different name)
        BACKUP_POLICY_ID=$(az dataprotection backup-policy list --resource-group "${RESOURCE_GROUP_SENSITIVE}" --vault-name "${BACKUP_VAULT_NAME}" --query "[?name=='${BACKUP_POLICY_NAME}'].id" -o tsv 2>/dev/null | head -1 || echo "")
        if [ -z "${BACKUP_POLICY_ID}" ]; then
          # Fallback to constructed ID
          BACKUP_POLICY_ID="${BACKUP_VAULT_ID}/backupPolicies/${BACKUP_POLICY_NAME}"
        fi
        echo "  Importing module.ingestion_storage.azurerm_data_protection_backup_policy_blob_storage.backup_policy[0]..."
        terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
          'module.ingestion_storage.azurerm_data_protection_backup_policy_blob_storage.backup_policy[0]' \
          "${BACKUP_POLICY_ID}" 2>&1 || echo "  ⚠️  Failed to import backup policy, it may need to be created"
        if terraform state show 'module.ingestion_storage.azurerm_data_protection_backup_policy_blob_storage.backup_policy[0]' >/dev/null 2>&1; then
          echo "  ✓ Imported module.ingestion_storage.azurerm_data_protection_backup_policy_blob_storage.backup_policy[0]"
        fi
      else
        echo "  ✓ module.ingestion_storage.azurerm_data_protection_backup_policy_blob_storage.backup_policy[0] already in state, skipping"
      fi

      # Import ingestion_storage Backup Instance
      echo "Checking module.ingestion_storage.azurerm_data_protection_backup_instance_blob_storage.backup_instance[0]..."
      if ! terraform state show 'module.ingestion_storage.azurerm_data_protection_backup_instance_blob_storage.backup_instance[0]' >/dev/null 2>&1; then
        # Try to find the instance - it might be named differently
        BACKUP_INSTANCE_ID=$(az dataprotection backup-instance list --resource-group "${RESOURCE_GROUP_SENSITIVE}" --vault-name "${BACKUP_VAULT_NAME}" --query "[?contains(name, '${INGESTION_STORAGE_SA_NAME}') || name=='${BACKUP_INSTANCE_NAME}'].id" -o tsv 2>/dev/null | head -1 || echo "")
        if [ -z "${BACKUP_INSTANCE_ID}" ]; then
          # Fallback to constructed ID
          BACKUP_INSTANCE_ID="${BACKUP_VAULT_ID}/backupInstances/${BACKUP_INSTANCE_NAME}"
        fi
        echo "  Importing module.ingestion_storage.azurerm_data_protection_backup_instance_blob_storage.backup_instance[0]..."
        terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
          'module.ingestion_storage.azurerm_data_protection_backup_instance_blob_storage.backup_instance[0]' \
          "${BACKUP_INSTANCE_ID}" 2>&1 || echo "  ⚠️  Failed to import backup instance, it may need to be created"
        if terraform state show 'module.ingestion_storage.azurerm_data_protection_backup_instance_blob_storage.backup_instance[0]' >/dev/null 2>&1; then
          echo "  ✓ Imported module.ingestion_storage.azurerm_data_protection_backup_instance_blob_storage.backup_instance[0]"
        fi
      else
        echo "  ✓ module.ingestion_storage.azurerm_data_protection_backup_instance_blob_storage.backup_instance[0] already in state, skipping"
      fi

      # Import ingestion_storage Backup Role Assignment
      echo "Checking module.ingestion_storage.azurerm_role_assignment.backup_vault_storage_access[0]..."
      if ! terraform state show 'module.ingestion_storage.azurerm_role_assignment.backup_vault_storage_access[0]' >/dev/null 2>&1; then
        # Get the principal ID from the backup vault identity
        if [ -z "${BACKUP_VAULT_PRINCIPAL_ID}" ]; then
          BACKUP_VAULT_PRINCIPAL_ID=$(az dataprotection backup-vault show --resource-group "${RESOURCE_GROUP_SENSITIVE}" --vault-name "${BACKUP_VAULT_NAME}" --query "identity.principalId" -o tsv 2>/dev/null || echo "")
        fi
        if [ -n "${BACKUP_VAULT_PRINCIPAL_ID}" ]; then
          # Find the role assignment ID
          ROLE_ASSIGNMENT_ID=$(az role assignment list --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_SENSITIVE}/providers/Microsoft.Storage/storageAccounts/${INGESTION_STORAGE_SA_NAME}" --assignee "${BACKUP_VAULT_PRINCIPAL_ID}" --role "Storage Account Backup Contributor" --query "[0].id" -o tsv 2>/dev/null || echo "")
          if [ -n "${ROLE_ASSIGNMENT_ID}" ]; then
            echo "  Importing module.ingestion_storage.azurerm_role_assignment.backup_vault_storage_access[0]..."
            terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
              'module.ingestion_storage.azurerm_role_assignment.backup_vault_storage_access[0]' \
              "${ROLE_ASSIGNMENT_ID}"
            echo "  ✓ Imported module.ingestion_storage.azurerm_role_assignment.backup_vault_storage_access[0]"
          else
            echo "  ⚠️  Could not find role assignment for backup vault, skipping import"
          fi
        else
          echo "  ⚠️  Could not get backup vault principal ID, skipping role assignment import"
        fi
      else
        echo "  ✓ module.ingestion_storage.azurerm_role_assignment.backup_vault_storage_access[0] already in state, skipping"
      fi
    fi
  fi
fi

echo ""
echo "=========================================="
echo "Importing Kubernetes Cluster"
echo "=========================================="
echo ""

# Kubernetes Cluster (AKS)
# Format: /subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.ContainerService/managedClusters/{cluster-name}
RESOURCE_GROUP_CORE_NAME=$(grep "^resource_group_core_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "resource-group-core")
SUBSCRIPTION_ID=$(az account show --query id -o tsv 2>/dev/null || echo "")

# Get the actual cluster name from Azure (this is what exists, not what Terraform thinks it should be)
CLUSTER_NAME_FROM_TFVARS=$(grep "^cluster_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "aks")
if [ -n "${RESOURCE_GROUP_CORE_NAME}" ]; then
  ACTUAL_CLUSTER_NAME=$(az aks list --resource-group "${RESOURCE_GROUP_CORE_NAME}" --query "[0].name" -o tsv 2>/dev/null || echo "")
  if [ -n "${ACTUAL_CLUSTER_NAME}" ]; then
    CLUSTER_NAME="${ACTUAL_CLUSTER_NAME}"
    # Check if there's a mismatch with Terraform's expected name
    TERRAFORM_CLUSTER_NAME="${CLUSTER_NAME_FROM_TFVARS}-${ENV}"
    if [ "${CLUSTER_NAME}" != "${TERRAFORM_CLUSTER_NAME}" ]; then
      echo "  ⚠️  WARNING: Mismatch detected!"
      echo "      Azure cluster name: ${CLUSTER_NAME}"
      echo "      Terraform expects (local.cluster_name): ${TERRAFORM_CLUSTER_NAME}"
      echo "      This will cause drift. Consider changing cluster_name in tfvars to:"
      echo "      cluster_name = \"$(echo ${CLUSTER_NAME} | sed "s/-${ENV}$//")\""
    fi
  else
    # Fallback: construct from tfvars + env (this is what Terraform will use via local.cluster_name)
    CLUSTER_NAME="${CLUSTER_NAME_FROM_TFVARS}-${ENV}"
    echo "  ⚠️  Could not determine actual cluster name from Azure. Using constructed name: ${CLUSTER_NAME}"
    echo "  ⚠️  Note: If cluster_name in tfvars is 'aks-test', local.cluster_name becomes 'aks-test-test'"
    echo "  ⚠️  Consider changing cluster_name in tfvars to just 'aks' (base name) so local makes it 'aks-test'"
  fi
else
  CLUSTER_NAME="${CLUSTER_NAME_FROM_TFVARS}-${ENV}"
fi

if [ -z "${SUBSCRIPTION_ID}" ]; then
  echo "  ⚠️  Could not determine subscription ID. Please set SUBSCRIPTION_ID environment variable or ensure az CLI is logged in."
  echo "  Skipping Kubernetes cluster import."
else
  CLUSTER_RESOURCE_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.ContainerService/managedClusters/${CLUSTER_NAME}"
  
  # Get the actual node resource group name from Azure
  echo "  ℹ️  Determining node resource group name from existing cluster..."
  NODE_RG_NAME=$(az aks show --name "${CLUSTER_NAME}" --resource-group "${RESOURCE_GROUP_CORE_NAME}" --query nodeResourceGroup -o tsv 2>/dev/null || echo "")
  if [ -n "${NODE_RG_NAME}" ]; then
    echo "  ℹ️  Found node resource group: ${NODE_RG_NAME}"
    echo "  ℹ️  IMPORTANT: Add this to your tfvars file:"
    echo "      node_resource_group_name = \"${NODE_RG_NAME}\""
  else
    echo "  ⚠️  Could not determine node resource group. Cluster may not exist yet."
    echo "  ℹ️  Node resource group is typically: <resource-group>-<cluster-name>-nodes"
    echo "      or: MC_<resource-group>_<cluster-name>_<location>"
  fi
  
  echo "Checking module.kubernetes_cluster.azurerm_kubernetes_cluster.cluster..."
  if ! terraform state show module.kubernetes_cluster.azurerm_kubernetes_cluster.cluster >/dev/null 2>&1; then
    echo "  Importing module.kubernetes_cluster.azurerm_kubernetes_cluster.cluster..."
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      module.kubernetes_cluster.azurerm_kubernetes_cluster.cluster \
      "${CLUSTER_RESOURCE_ID}" 2>&1; then
      echo "  ✓ Imported module.kubernetes_cluster.azurerm_kubernetes_cluster.cluster"
    else
      echo "  ⚠️  Failed to import cluster. Please verify the cluster exists and the resource ID is correct:"
      echo "      ${CLUSTER_RESOURCE_ID}"
      echo "      Get the correct ID with: az aks show --name ${CLUSTER_NAME} --resource-group ${RESOURCE_GROUP_CORE_NAME} --query id -o tsv"
    fi
  else
    echo "  ✓ module.kubernetes_cluster.azurerm_kubernetes_cluster.cluster already in state, skipping"
  fi

  # Import node pools
  echo "Checking module.kubernetes_cluster.azurerm_kubernetes_cluster_node_pool.node_pool[\"rapid\"]..."
  if ! terraform state show 'module.kubernetes_cluster.azurerm_kubernetes_cluster_node_pool.node_pool["rapid"]' >/dev/null 2>&1; then
    NODE_POOL_RAPID_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.ContainerService/managedClusters/${CLUSTER_NAME}/agentPools/rapid"
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.kubernetes_cluster.azurerm_kubernetes_cluster_node_pool.node_pool["rapid"]' \
      "${NODE_POOL_RAPID_ID}" 2>&1; then
      echo "  ✓ Imported module.kubernetes_cluster.azurerm_kubernetes_cluster_node_pool.node_pool[\"rapid\"]"
    else
      echo "  ⚠️  Failed to import rapid node pool. It may not exist yet or have a different name."
    fi
  else
    echo "  ✓ module.kubernetes_cluster.azurerm_kubernetes_cluster_node_pool.node_pool[\"rapid\"] already in state, skipping"
  fi

  echo "Checking module.kubernetes_cluster.azurerm_kubernetes_cluster_node_pool.node_pool[\"steady\"]..."
  if ! terraform state show 'module.kubernetes_cluster.azurerm_kubernetes_cluster_node_pool.node_pool["steady"]' >/dev/null 2>&1; then
    NODE_POOL_STEADY_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.ContainerService/managedClusters/${CLUSTER_NAME}/agentPools/steady"
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.kubernetes_cluster.azurerm_kubernetes_cluster_node_pool.node_pool["steady"]' \
      "${NODE_POOL_STEADY_ID}" 2>&1; then
      echo "  ✓ Imported module.kubernetes_cluster.azurerm_kubernetes_cluster_node_pool.node_pool[\"steady\"]"
    else
      echo "  ⚠️  Failed to import steady node pool. It may not exist yet or have a different name."
    fi
  else
    echo "  ✓ module.kubernetes_cluster.azurerm_kubernetes_cluster_node_pool.node_pool[\"steady\"] already in state, skipping"
  fi

  # Import additional resources created by the Kubernetes module
  echo ""
  echo "  ℹ️  Checking for additional Kubernetes module resources..."
  
  # Grafana Dashboard
  GRAFANA_NAME="${CLUSTER_NAME}-grafana"
  echo "Checking module.kubernetes_cluster.azurerm_dashboard_grafana.grafana[0]..."
  if ! terraform state show 'module.kubernetes_cluster.azurerm_dashboard_grafana.grafana[0]' >/dev/null 2>&1; then
    GRAFANA_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.Dashboard/grafana/${GRAFANA_NAME}"
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.kubernetes_cluster.azurerm_dashboard_grafana.grafana[0]' \
      "${GRAFANA_ID}" 2>&1; then
      echo "  ✓ Imported module.kubernetes_cluster.azurerm_dashboard_grafana.grafana[0]"
    else
      echo "  ⚠️  Grafana dashboard may not exist yet or has a different name. It will be created by Terraform."
    fi
  else
    echo "  ✓ module.kubernetes_cluster.azurerm_dashboard_grafana.grafana[0] already in state, skipping"
  fi
  
  # Monitor Workspace
  MONITOR_WORKSPACE_NAME="${CLUSTER_NAME}-monitor"
  echo "Checking module.kubernetes_cluster.azurerm_monitor_workspace.monitor_workspace[0]..."
  if ! terraform state show 'module.kubernetes_cluster.azurerm_monitor_workspace.monitor_workspace[0]' >/dev/null 2>&1; then
    # Monitor workspace requires proper casing: resourceGroups (capital G) and Microsoft.Monitor (capital M)
    MONITOR_WORKSPACE_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.Monitor/accounts/${MONITOR_WORKSPACE_NAME}"
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.kubernetes_cluster.azurerm_monitor_workspace.monitor_workspace[0]' \
      "${MONITOR_WORKSPACE_ID}" 2>&1; then
      echo "  ✓ Imported module.kubernetes_cluster.azurerm_monitor_workspace.monitor_workspace[0]"
    else
      echo "  ⚠️  Monitor workspace may not exist yet. It will be created by Terraform."
    fi
  else
    echo "  ✓ module.kubernetes_cluster.azurerm_monitor_workspace.monitor_workspace[0] already in state, skipping"
  fi
  
  # Monitor Data Collection Endpoint
  MONITOR_DCE_NAME="${CLUSTER_NAME}-monitor-dce"
  echo "Checking module.kubernetes_cluster.azurerm_monitor_data_collection_endpoint.monitor_dce[0]..."
  if ! terraform state show 'module.kubernetes_cluster.azurerm_monitor_data_collection_endpoint.monitor_dce[0]' >/dev/null 2>&1; then
    MONITOR_DCE_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.Insights/dataCollectionEndpoints/${MONITOR_DCE_NAME}"
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.kubernetes_cluster.azurerm_monitor_data_collection_endpoint.monitor_dce[0]' \
      "${MONITOR_DCE_ID}" 2>&1; then
      echo "  ✓ Imported module.kubernetes_cluster.azurerm_monitor_data_collection_endpoint.monitor_dce[0]"
    else
      echo "  ⚠️  Monitor DCE may not exist yet. It will be created by Terraform."
    fi
  else
    echo "  ✓ module.kubernetes_cluster.azurerm_monitor_data_collection_endpoint.monitor_dce[0] already in state, skipping"
  fi
  
  # Monitor Data Collection Rules
  MONITOR_DCR_CI_NAME="${CLUSTER_NAME}-ci-dcr"
  echo "Checking module.kubernetes_cluster.azurerm_monitor_data_collection_rule.ci_dcr[0]..."
  if ! terraform state show 'module.kubernetes_cluster.azurerm_monitor_data_collection_rule.ci_dcr[0]' >/dev/null 2>&1; then
    MONITOR_DCR_CI_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.Insights/dataCollectionRules/${MONITOR_DCR_CI_NAME}"
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.kubernetes_cluster.azurerm_monitor_data_collection_rule.ci_dcr[0]' \
      "${MONITOR_DCR_CI_ID}" 2>&1; then
      echo "  ✓ Imported module.kubernetes_cluster.azurerm_monitor_data_collection_rule.ci_dcr[0]"
    else
      echo "  ⚠️  Monitor DCR (CI) may not exist yet. It will be created by Terraform."
    fi
  else
    echo "  ✓ module.kubernetes_cluster.azurerm_monitor_data_collection_rule.ci_dcr[0] already in state, skipping"
  fi
  
  MONITOR_DCR_PROM_NAME="MSProm-swedencentral-${CLUSTER_NAME}"
  echo "Checking module.kubernetes_cluster.azurerm_monitor_data_collection_rule.monitor_dcr[0]..."
  if ! terraform state show 'module.kubernetes_cluster.azurerm_monitor_data_collection_rule.monitor_dcr[0]' >/dev/null 2>&1; then
    MONITOR_DCR_PROM_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.Insights/dataCollectionRules/${MONITOR_DCR_PROM_NAME}"
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.kubernetes_cluster.azurerm_monitor_data_collection_rule.monitor_dcr[0]' \
      "${MONITOR_DCR_PROM_ID}" 2>&1; then
      echo "  ✓ Imported module.kubernetes_cluster.azurerm_monitor_data_collection_rule.monitor_dcr[0]"
    else
      echo "  ⚠️  Monitor DCR (Prometheus) may not exist yet. It will be created by Terraform."
    fi
  else
    echo "  ✓ module.kubernetes_cluster.azurerm_monitor_data_collection_rule.monitor_dcr[0] already in state, skipping"
  fi
  
  # Monitor Data Collection Rule Associations
  MONITOR_DCR_CI_NAME="${CLUSTER_NAME}-ci-dcr"
  echo "Checking module.kubernetes_cluster.azurerm_monitor_data_collection_rule_association.ci_dcr_asc[0]..."
  if ! terraform state show 'module.kubernetes_cluster.azurerm_monitor_data_collection_rule_association.ci_dcr_asc[0]' >/dev/null 2>&1; then
    MONITOR_DCR_CI_ASC_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.ContainerService/managedClusters/${CLUSTER_NAME}/providers/Microsoft.Insights/dataCollectionRuleAssociations/${MONITOR_DCR_CI_NAME}-asc"
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.kubernetes_cluster.azurerm_monitor_data_collection_rule_association.ci_dcr_asc[0]' \
      "${MONITOR_DCR_CI_ASC_ID}" 2>&1; then
      echo "  ✓ Imported module.kubernetes_cluster.azurerm_monitor_data_collection_rule_association.ci_dcr_asc[0]"
    else
      echo "  ⚠️  Monitor DCR association (CI) may not exist yet. It will be created by Terraform."
    fi
  else
    echo "  ✓ module.kubernetes_cluster.azurerm_monitor_data_collection_rule_association.ci_dcr_asc[0] already in state, skipping"
  fi
  
  MONITOR_DCR_PROM_NAME="MSProm-swedencentral-${CLUSTER_NAME}"
  echo "Checking module.kubernetes_cluster.azurerm_monitor_data_collection_rule_association.monitor_dcr_asc[0]..."
  if ! terraform state show 'module.kubernetes_cluster.azurerm_monitor_data_collection_rule_association.monitor_dcr_asc[0]' >/dev/null 2>&1; then
    MONITOR_DCR_PROM_ASC_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.ContainerService/managedClusters/${CLUSTER_NAME}/providers/Microsoft.Insights/dataCollectionRuleAssociations/${MONITOR_DCR_PROM_NAME}"
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.kubernetes_cluster.azurerm_monitor_data_collection_rule_association.monitor_dcr_asc[0]' \
      "${MONITOR_DCR_PROM_ASC_ID}" 2>&1; then
      echo "  ✓ Imported module.kubernetes_cluster.azurerm_monitor_data_collection_rule_association.monitor_dcr_asc[0]"
    else
      echo "  ⚠️  Monitor DCR association (Prometheus) may not exist yet. It will be created by Terraform."
    fi
  else
    echo "  ✓ module.kubernetes_cluster.azurerm_monitor_data_collection_rule_association.monitor_dcr_asc[0] already in state, skipping"
  fi
  
  # Diagnostic Setting
  echo "Checking module.kubernetes_cluster.azurerm_monitor_diagnostic_setting.aks_diagnostic_logs[0]..."
  if ! terraform state show 'module.kubernetes_cluster.azurerm_monitor_diagnostic_setting.aks_diagnostic_logs[0]' >/dev/null 2>&1; then
    # Diagnostic settings require format: {resourceId}|{name}
    # Use the cluster resource ID (with proper casing) with pipe separator and diagnostic setting name
    CLUSTER_RESOURCE_ID_CANONICAL="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE_NAME}/providers/Microsoft.ContainerService/managedClusters/${CLUSTER_NAME}"
    DIAGNOSTIC_SETTING_ID="${CLUSTER_RESOURCE_ID_CANONICAL}|aks-diagnostic-logs"
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.kubernetes_cluster.azurerm_monitor_diagnostic_setting.aks_diagnostic_logs[0]' \
      "${DIAGNOSTIC_SETTING_ID}" 2>&1; then
      echo "  ✓ Imported module.kubernetes_cluster.azurerm_monitor_diagnostic_setting.aks_diagnostic_logs[0]"
    else
      echo "  ⚠️  Diagnostic setting may not exist yet. It will be created by Terraform."
    fi
  else
    echo "  ✓ module.kubernetes_cluster.azurerm_monitor_diagnostic_setting.aks_diagnostic_logs[0] already in state, skipping"
  fi
  
  # Log Analytics Workspace Tables
  # NOTE: These tables are NOT imported because:
  # 1. They are auto-created by Azure Monitor/Container Insights
  # 2. Importing them causes refresh errors ("parsing '': cannot parse an empty string")
  # 3. They can be safely created fresh by Terraform without affecting existing data
  echo ""
  echo "  ℹ️  Skipping Log Analytics workspace tables import..."
  echo "      These tables (AKSControlPlane, ContainerLogV2) are auto-created by Azure Monitor"
  echo "      and will be created fresh by Terraform. This is safe and expected behavior."
fi

echo ""
echo "=========================================="
echo "Expected Drifts After Import"
echo "=========================================="
echo ""
echo "⚠️  The following drifts are EXPECTED and can be safely ignored:"
echo ""
echo "1. Kubernetes Cluster - Configuration Updates:"
echo "   - Resource: module.kubernetes_cluster.azurerm_kubernetes_cluster.cluster"
echo "   - Drifts:"
echo "     * temporary_name_for_rotation on default_node_pool: 'defaultrepl'"
echo "     * storage_profile block (blob_driver_enabled, disk_driver_enabled, etc.)"
echo "     * timeouts block (update = '30m')"
echo "   - Reason: These are feature additions from the module that enhance cluster"
echo "            functionality. The temporary_name_for_rotation helps with zero-downtime"
echo "            node pool upgrades, storage_profile enables additional storage drivers,"
echo "            and timeouts sets reasonable update timeouts."
echo "   - Action: Safe to ignore - these are non-breaking feature additions."
echo ""
echo "2. Kubernetes Node Pools - temporary_name_for_rotation:"
echo "   - Resources:"
echo "     * module.kubernetes_cluster.azurerm_kubernetes_cluster_node_pool.node_pool[\"rapid\"]"
echo "     * module.kubernetes_cluster.azurerm_kubernetes_cluster_node_pool.node_pool[\"steady\"]"
echo "   - Drift: temporary_name_for_rotation = 'rapidrepl' / 'steadyrepl'"
echo "   - Reason: The module sets this automatically for node pool rotation during upgrades."
echo "            This is a best practice for zero-downtime upgrades."
echo "   - Action: Safe to ignore - this is a non-breaking configuration enhancement."
echo ""
echo "3. Log Analytics Workspace Tables:"
echo "   - Resources:"
echo "     * module.kubernetes_cluster.azurerm_log_analytics_workspace_table.basic_log_table[\"AKSControlPlane\"]"
echo "     * module.kubernetes_cluster.azurerm_log_analytics_workspace_table.basic_log_table[\"ContainerLogV2\"]"
echo "   - Note: These tables are NOT imported because:"
echo "     * They are auto-created by Azure Monitor/Container Insights"
echo "     * Importing them causes refresh errors (empty resource ID parsing)"
echo "     * They can be safely created fresh by Terraform without affecting existing data"
echo "   - Action: These will show as 'to be created' in terraform plan - this is expected"
echo "            and safe. The tables will be created by Terraform on first apply."
echo ""
echo "=========================================="
echo "Import script completed!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "   - Run 'terraform plan' to verify all imports were successful"
echo "   - Review the 'Expected Drifts' section above for drifts that can be safely ignored"
echo "   - All resources should now be in state, with only expected configuration drifts remaining"

echo ""
echo "=========================================="
echo "Skipping Key Vault Secrets"
echo "=========================================="
echo ""
echo "⚠️  Key Vault secrets are NOT imported by this script."
echo ""
echo "Reason: Terraform requires versioned secret IDs for import."
echo "        Format: https://{vault}.vault.azure.net/secrets/{name}/{version-id}"
echo "        Getting the version ID programmatically is complex and error-prone."
echo ""
echo "Expected behavior:"
echo "  - terraform plan will show these as 'to be created':"
echo "    * module.application_registration.azurerm_key_vault_secret.aad_app_gitops_client_id[0]"
echo "    * module.application_registration.azurerm_key_vault_secret.aad_app_gitops_client_secret[0]"
echo ""
echo "Resolution:"
echo "  1. Let Terraform create them fresh (recommended if values can be regenerated)"
echo "  2. Manually import with version ID (get version from Azure Portal or CLI):"
echo "     az keyvault secret show --vault-name hakv2testv2 --name aad-app-ha-test-gitops-client-id --query id -o tsv"
echo "     terraform import -var-file=\"${VAR_CONFIG}\" -var-file=\"${VAR_PARAMS}\" \\"
echo "       'module.application_registration.azurerm_key_vault_secret.aad_app_gitops_client_id[0]' \\"
echo "       '<versioned-id-from-az-command>'"
echo ""
echo "=========================================="
echo "Import script completed!"
echo "=========================================="
echo ""
echo "Note: azuread_application_password cannot be imported and will be created fresh."
echo "      This is expected - the password value cannot be retrieved from Azure AD."
echo ""
