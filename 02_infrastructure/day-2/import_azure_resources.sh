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
echo "Importing PostgreSQL Resources"
echo "=========================================="
echo ""

# PostgreSQL Server
RESOURCE_GROUP_SENSITIVE_NAME=$(grep "^resource_group_sensitive_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "resource-group-sensitive")
POSTGRESQL_SERVER_NAME=$(grep "^postgresql_server_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "")

if [ -n "${POSTGRESQL_SERVER_NAME}" ] && [ -n "${RESOURCE_GROUP_SENSITIVE_NAME}" ]; then
  SUBSCRIPTION_ID=$(az account show --query id -o tsv 2>/dev/null || echo "")
  
  if [ -n "${SUBSCRIPTION_ID}" ]; then
    # Check if PostgreSQL server exists in Azure before attempting import
    echo "Checking if PostgreSQL server exists in Azure..."
    SERVER_EXISTS=$(az postgres flexible-server show --name "${POSTGRESQL_SERVER_NAME}" --resource-group "${RESOURCE_GROUP_SENSITIVE_NAME}" --query id -o tsv 2>/dev/null || echo "")
    
    if [ -z "${SERVER_EXISTS}" ]; then
      echo "  ⚠️  PostgreSQL server '${POSTGRESQL_SERVER_NAME}' not found in Azure."
      echo "      Checking for other PostgreSQL servers in the resource group..."
      ACTUAL_SERVERS=$(az postgres flexible-server list --resource-group "${RESOURCE_GROUP_SENSITIVE_NAME}" --query "[].name" -o tsv 2>/dev/null || echo "")
      if [ -n "${ACTUAL_SERVERS}" ]; then
        echo "      Found PostgreSQL server(s) in Azure:"
        echo "${ACTUAL_SERVERS}" | while read -r SERVER; do
          echo "        - ${SERVER}"
        done
        echo ""
        echo "  ⚠️  Server name mismatch detected!"
        echo "      Expected: ${POSTGRESQL_SERVER_NAME}"
        echo "      Actual: $(echo "${ACTUAL_SERVERS}" | head -1)"
        echo ""
        echo "  Action: Update postgresql_server_name in tfvars to match the actual server name:"
        echo "      postgresql_server_name = \"$(echo "${ACTUAL_SERVERS}" | head -1)\""
        echo ""
        echo "      Then re-run this import script to import the existing server."
      else
        echo "      No PostgreSQL servers found in the resource group."
        echo "      Skipping PostgreSQL import. The server may not exist yet."
        echo ""
        echo "  ℹ️  If the server doesn't exist, the following resources will be created by Terraform:"
        echo "      - PostgreSQL server and databases"
        echo "      - Server configuration parameters"
        echo "      - Management lock"
        echo "      - Metric alerts"
        echo "      - Key Vault secrets"
        echo "      This is expected behavior and documented in the 'Expected Drifts' section."
      fi
    else
      POSTGRESQL_SERVER_ID="${SERVER_EXISTS}"
      
      echo "Checking module.postgresql.azurerm_postgresql_flexible_server.apfs..."
      if ! terraform state show module.postgresql.azurerm_postgresql_flexible_server.apfs >/dev/null 2>&1; then
        echo "  Importing module.postgresql.azurerm_postgresql_flexible_server.apfs..."
        if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
          module.postgresql.azurerm_postgresql_flexible_server.apfs \
          "${POSTGRESQL_SERVER_ID}" 2>&1; then
          echo "  ✓ Imported module.postgresql.azurerm_postgresql_flexible_server.apfs"
        else
          echo "  ⚠️  Failed to import PostgreSQL server. Please verify the server exists and the resource ID is correct:"
          echo "      ${POSTGRESQL_SERVER_ID}"
        fi
      else
        echo "  ✓ module.postgresql.azurerm_postgresql_flexible_server.apfs already in state, skipping"
      fi

      # Import PostgreSQL databases
      # Note: All databases in the default configuration have prevent_destroy = false,
      # so they will be in destroyable_database, not destroy_prevented_database
      echo "Checking PostgreSQL databases..."
      DATABASES=("chat" "ingestion" "theme" "scope-management" "app-repository")
      for DB_NAME in "${DATABASES[@]}"; do
        # Check if database already exists in state
        if ! terraform state show "module.postgresql.azurerm_postgresql_flexible_server_database.destroy_prevented_database[\"${DB_NAME}\"]" >/dev/null 2>&1 && \
           ! terraform state show "module.postgresql.azurerm_postgresql_flexible_server_database.destroyable_database[\"${DB_NAME}\"]" >/dev/null 2>&1; then
          # Check if database exists in Azure
          DB_EXISTS=$(az postgres flexible-server db show --server-name "${POSTGRESQL_SERVER_NAME}" --resource-group "${RESOURCE_GROUP_SENSITIVE_NAME}" --database-name "${DB_NAME}" --query id -o tsv 2>/dev/null || echo "")
          
          if [ -z "${DB_EXISTS}" ]; then
            echo "  ⚠️  Database ${DB_NAME} not found in Azure. It may not exist yet."
          else
            DB_ID="${DB_EXISTS}"
            # Try destroyable_database first (since all default databases have prevent_destroy = false)
            if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
              "module.postgresql.azurerm_postgresql_flexible_server_database.destroyable_database[\"${DB_NAME}\"]" \
              "${DB_ID}" 2>&1; then
              echo "  ✓ Imported module.postgresql.azurerm_postgresql_flexible_server_database.destroyable_database[\"${DB_NAME}\"]"
            elif terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
              "module.postgresql.azurerm_postgresql_flexible_server_database.destroy_prevented_database[\"${DB_NAME}\"]" \
              "${DB_ID}" 2>&1; then
              echo "  ✓ Imported module.postgresql.azurerm_postgresql_flexible_server_database.destroy_prevented_database[\"${DB_NAME}\"]"
            else
              echo "  ⚠️  Failed to import database ${DB_NAME}."
            fi
          fi
        else
          echo "  ✓ Database ${DB_NAME} already in state, skipping"
        fi
      done

      # Import PostgreSQL server configurations (parameters)
      # Note: These are optional and may not exist if using default values
      echo "Checking PostgreSQL server configurations..."
      CONFIG_PARAMS=("max_connections" "azure.extensions" "enable_seqscan")
      for PARAM_NAME in "${CONFIG_PARAMS[@]}"; do
        if ! terraform state show "module.postgresql.azurerm_postgresql_flexible_server_configuration.parameters[\"${PARAM_NAME}\"]" >/dev/null 2>&1; then
          # Check if parameter exists in Azure
          PARAM_EXISTS=$(az postgres flexible-server parameter show --server-name "${POSTGRESQL_SERVER_NAME}" --resource-group "${RESOURCE_GROUP_SENSITIVE_NAME}" --name "${PARAM_NAME}" --query id -o tsv 2>/dev/null || echo "")
          
          if [ -z "${PARAM_EXISTS}" ]; then
            echo "  ℹ️  Configuration parameter ${PARAM_NAME} not found in Azure. It may use default values or not be configured."
          else
            PARAM_ID="${PARAM_EXISTS}"
            if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
              "module.postgresql.azurerm_postgresql_flexible_server_configuration.parameters[\"${PARAM_NAME}\"]" \
              "${PARAM_ID}" 2>&1; then
              echo "  ✓ Imported module.postgresql.azurerm_postgresql_flexible_server_configuration.parameters[\"${PARAM_NAME}\"]"
            else
              echo "  ⚠️  Failed to import configuration parameter ${PARAM_NAME}."
            fi
          fi
        else
          echo "  ✓ Configuration parameter ${PARAM_NAME} already in state, skipping"
        fi
      done

      # Import management lock (if it exists)
      echo "Checking PostgreSQL management lock..."
      if ! terraform state show "module.postgresql.azurerm_management_lock.can_not_delete_server[0]" >/dev/null 2>&1; then
        # Check if lock exists in Azure first
        LOCK_NAME="TerraformModuleLock-CanNotDelete"
        LOCK_EXISTS=$(az lock show --name "${LOCK_NAME}" --resource "${POSTGRESQL_SERVER_ID}" --query id -o tsv 2>/dev/null || echo "")
        
        if [ -n "${LOCK_EXISTS}" ]; then
          # Management lock format: {scope}/providers/Microsoft.Authorization/locks/{name}
          LOCK_ID="${POSTGRESQL_SERVER_ID}/providers/Microsoft.Authorization/locks/${LOCK_NAME}"
          if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
            "module.postgresql.azurerm_management_lock.can_not_delete_server[0]" \
            "${LOCK_ID}" 2>&1; then
            echo "  ✓ Imported module.postgresql.azurerm_management_lock.can_not_delete_server[0]"
          else
            echo "  ⚠️  Failed to import management lock. It may have a different name or format."
          fi
        else
          echo "  ℹ️  Management lock not found in Azure. It may not exist yet or may have been manually removed."
          echo "      This is expected - Terraform will create the lock on first apply."
        fi
      else
        echo "  ✓ Management lock already in state, skipping"
      fi

      # Import metric alerts (if they exist)
      # Note: The module uses keys from var.metric_alerts, which defaults to:
      # - default_cpu_alert -> "PostgreSQL High CPU Usage"
      # - default_memory_alert -> "PostgreSQL High Memory Usage"
      # - default_absence_alert -> "PostgreSQL Heartbeat Absent"
      echo "Checking PostgreSQL metric alerts..."
      # Map alert names to their Terraform resource keys
      declare -A ALERT_MAP=(
        ["PostgreSQL High CPU Usage"]="default_cpu_alert"
        ["PostgreSQL High Memory Usage"]="default_memory_alert"
        ["PostgreSQL Heartbeat Absent"]="default_absence_alert"
      )
      
      for ALERT_NAME in "${!ALERT_MAP[@]}"; do
        ALERT_KEY="${ALERT_MAP[$ALERT_NAME]}"
        if ! terraform state show "module.postgresql.azurerm_monitor_metric_alert.postgres_metric_alerts[\"${ALERT_KEY}\"]" >/dev/null 2>&1; then
          # Try to find the alert by name in Azure
          ALERT_ID=$(az monitor metrics alert list --resource-group "${RESOURCE_GROUP_SENSITIVE_NAME}" --query "[?name=='${ALERT_NAME}'].id" -o tsv 2>/dev/null | head -1)
          if [ -n "${ALERT_ID}" ]; then
            if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
              "module.postgresql.azurerm_monitor_metric_alert.postgres_metric_alerts[\"${ALERT_KEY}\"]" \
              "${ALERT_ID}" 2>&1; then
              echo "  ✓ Imported module.postgresql.azurerm_monitor_metric_alert.postgres_metric_alerts[\"${ALERT_KEY}\"]"
            else
              echo "  ⚠️  Failed to import metric alert '${ALERT_NAME}' (key: ${ALERT_KEY})."
            fi
          else
            echo "  ℹ️  Metric alert '${ALERT_NAME}' not found in Azure. It may not exist yet."
          fi
        else
          echo "  ✓ Metric alert ${ALERT_NAME} (key: ${ALERT_KEY}) already in state, skipping"
        fi
      done
    fi
  else
    echo "  ⚠️  Could not determine subscription ID. Please set SUBSCRIPTION_ID environment variable or ensure az CLI is logged in."
    echo "  Skipping PostgreSQL import."
  fi
else
  echo "  ⚠️  PostgreSQL server name or resource group not found in tfvars. Skipping PostgreSQL import."
fi

echo ""
echo "=========================================="
echo "Expected Drifts After Import"
echo "=========================================="
echo ""
echo "⚠️  The following drifts are EXPECTED and can be safely ignored:"
echo ""
echo "1. PostgreSQL Server and Databases:"
echo "   - Resources:"
echo "     * module.postgresql.azurerm_postgresql_flexible_server.apfs"
echo "     * module.postgresql.azurerm_postgresql_flexible_server_database.destroyable_database[*]"
echo "   - Reason: The PostgreSQL server name in tfvars may not match the actual server name in Azure."
echo "            If the names don't match, Terraform will try to create a new server instead of importing."
echo "            This can happen if:"
echo "            * The server was created with a different name (e.g., auto-generated name)"
echo "            * The server doesn't exist yet (new environment)"
echo "            * The server name in tfvars is incorrect"
echo "   - Action:"
echo "            Step 1: Check actual server name in Azure:"
echo "              az postgres flexible-server list --resource-group <resource-group> --query '[].name' -o tsv"
echo "            Step 2: Update postgresql_server_name in tfvars to match the actual server name"
echo "            Step 3: Re-run the import script to import the existing server"
echo "            Step 4: If the server doesn't exist, this is expected and Terraform will create it"
echo ""
echo "2. PostgreSQL Random Passwords:"
echo "   - Resources:"
echo "     * random_password.postgres_username"
echo "     * random_password.postgres_password"
echo "   - Reason: Random password resources cannot be imported because they are"
echo "            generated resources with no corresponding Azure resource."
echo "            The values are generated fresh by Terraform on each apply."
echo "   - Action: Safe to ignore - these will be created fresh by Terraform."
echo "            The actual PostgreSQL server credentials in Azure are not affected."
echo "            Note: If importing an existing server, the passwords in Terraform will differ"
echo "            from the actual server passwords. This is expected and safe."
echo ""
echo "3. PostgreSQL Key Vault Secrets:"
echo "   - Resources:"
echo "     * module.postgresql.azurerm_key_vault_secret.* (host, port, username, password, connection strings)"
echo "   - Reason: Terraform requires versioned secret IDs for import."
echo "            Format: https://{vault}.vault.azure.net/secrets/{name}/{version-id}"
echo "            Getting the version ID programmatically is complex and error-prone."
echo "   - Action: These will show as 'to be created' in terraform plan."
echo "            Option 1: Let Terraform create them fresh (recommended if values can be regenerated)"
echo "            Option 2: Manually import with version ID:"
echo "              az keyvault secret show --vault-name <vault-name> --name <secret-name> --query id -o tsv"
echo "              terraform import -var-file=\"${VAR_CONFIG}\" -var-file=\"${VAR_PARAMS}\" \\"
echo "                'module.postgresql.azurerm_key_vault_secret.<resource_name>' \\"
echo "                '<versioned-id-from-az-command>'"
echo ""
echo "4. PostgreSQL Server Configuration Parameters:"
echo "   - Resources:"
echo "     * module.postgresql.azurerm_postgresql_flexible_server_configuration.parameters[*]"
echo "   - Reason: Configuration parameters may not exist if the server uses default values,"
echo "            or they may have different names than expected."
echo "   - Action: If parameters don't exist in Azure, they will be created by Terraform"
echo "            with the values specified in var.postgresql_databases.parameter_values."
echo "            This is safe and expected behavior."
echo ""
echo "5. Application Registration Secrets:"
echo "   - Resources:"
echo "     * module.application_registration.azurerm_key_vault_secret.aad_app_gitops_client_id[0]"
echo "     * module.application_registration.azurerm_key_vault_secret.aad_app_gitops_client_secret[0]"
echo "   - Reason: Same as PostgreSQL secrets - requires versioned secret IDs."
echo "   - Action: Let Terraform create them fresh or manually import with version ID."
echo ""
echo "6. Azure AD Application Password:"
echo "   - Resource: module.application_registration.azuread_application_password.aad_app_password[0]"
echo "   - Reason: azuread_application_password cannot be imported because the password value"
echo "            is only available at creation time and cannot be retrieved from Azure AD."
echo "   - Action: This will be created fresh by Terraform. This is expected and safe."
echo ""
echo "7. PostgreSQL Management Lock:"
echo "   - Resource: module.postgresql.azurerm_management_lock.can_not_delete_server[0]"
echo "   - Reason: Management locks may not exist if the server was created without them,"
echo "            or they may have been manually removed."
echo "   - Action: If the lock doesn't exist, Terraform will create it. This is safe"
echo "            and provides additional protection against accidental deletion."
echo ""
echo "8. PostgreSQL Metric Alerts:"
echo "   - Resources:"
echo "     * module.postgresql.azurerm_monitor_metric_alert.postgres_metric_alerts[\"default_cpu_alert\"]"
echo "     * module.postgresql.azurerm_monitor_metric_alert.postgres_metric_alerts[\"default_memory_alert\"]"
echo "     * module.postgresql.azurerm_monitor_metric_alert.postgres_metric_alerts[\"default_absence_alert\"]"
echo "   - Reason: Metric alerts may not exist if the server was created without them,"
echo "            or they may have been manually removed. The 'PostgreSQL Heartbeat Absent'"
echo "            alert may not exist even if CPU and Memory alerts do."
echo "   - Action: If alerts don't exist, Terraform will create them. This is safe"
echo "            and provides monitoring capabilities for the PostgreSQL server."
echo ""
echo "9. PostgreSQL Server Configuration Updates:"
echo "   - Resource: module.postgresql.azurerm_postgresql_flexible_server.apfs"
echo "   - Drifts:"
echo "     * administrator_login: Shows as changed (sensitive value)"
echo "     * administrator_password: Shows as 'to be added' (sensitive value)"
echo "     * maintenance_window: Will be added (day_of_week=0, start_hour=3, start_minute=15)"
echo "     * timeouts: Will be added (update = '30m')"
echo "   - Reason:"
echo "     * administrator_login/password: When importing an existing server, Terraform"
echo "            cannot retrieve the actual credentials (password is write-only in Azure)."
echo "            The module uses random_password resources which generate new values."
echo "            However, Azure PostgreSQL Flexible Server has restrictions:"
echo "            - administrator_login CANNOT be changed after server creation"
echo "            - administrator_password can only be changed if current password is provided"
echo "            Therefore, Terraform will show these as drifts, but Azure will:"
echo "            - Reject administrator_login changes (no-op, safe)"
echo "            - Skip administrator_password changes (no current password provided, safe)"
echo "     * maintenance_window: This is a feature addition from the module that"
echo "            sets a maintenance window (Sunday 3:15 AM). This is safe and expected."
echo "     * timeouts: This sets a 30-minute timeout for updates, which is a best practice."
echo "   - Action:"
echo "     * administrator_login/password: SAFE TO IGNORE - These drifts are cosmetic."
echo "            Azure will NOT change the actual server credentials due to API restrictions."
echo "            The random_password values in Terraform state are placeholders that"
echo "            don't affect the actual server. The server keeps its original credentials."
echo "     * maintenance_window and timeouts: SAFE TO IGNORE - These are non-breaking"
echo "            feature additions that enhance server management."
echo ""
echo "   ⚠️  IMPORTANT: The administrator_login and administrator_password drifts are"
echo "      SAFE TO IGNORE. Azure will reject these changes due to API restrictions."
echo "      The actual server credentials remain unchanged. Do NOT manually update"
echo "      these values in Terraform state unless you understand the implications."
echo ""
echo "10. Undeclared Variable Warning (kv_sku):"
echo "   - Warning: 'The root module does not declare a variable named \"kv_sku\"'"
echo "   - Reason: kv_sku is a day-1 variable used for Key Vault SKU configuration."
echo "            It should not be in day-2 tfvars files."
echo "   - Action: Remove 'kv_sku = \"premium\"' from day-2 tfvars files."
echo "            This variable is only relevant for day-1 Key Vault creation."
echo ""
echo "=========================================="
echo "Import script completed!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Remove 'kv_sku' from day-2 tfvars files (it's a day-1 variable)"
echo "  2. Run 'terraform plan' to verify all imports were successful"
echo "  3. Review the 'Expected Drifts' section above for drifts that can be safely ignored"
echo "  4. All resources should now be in state, with only expected configuration drifts remaining"
echo ""
