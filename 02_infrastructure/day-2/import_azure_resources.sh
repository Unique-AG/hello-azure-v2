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
echo "Importing Redis Cache"
echo "=========================================="
echo ""

# Get Redis cache name from locals (redis_name with env suffix)
REDIS_NAME=$(grep "^redis_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "uqharedis")
REDIS_FULL_NAME="${REDIS_NAME}-${ENV}"
RESOURCE_GROUP_SENSITIVE_NAME=$(grep "^resource_group_sensitive_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "resource-group-sensitive")

echo "Checking module.redis.azurerm_redis_cache.arc..."
if ! terraform state show module.redis.azurerm_redis_cache.arc >/dev/null 2>&1; then
  # Get Redis cache ID from Azure
  REDIS_ID=$(az redis show --name "${REDIS_FULL_NAME}" --resource-group "${RESOURCE_GROUP_SENSITIVE_NAME}" --query id -o tsv 2>/dev/null || echo "")
  
  if [ -n "${REDIS_ID}" ]; then
    # Terraform expects lowercase "redis" in the resource ID, but Azure returns "Redis"
    # Convert the resource ID to use lowercase "redis"
    REDIS_ID_FIXED=$(echo "${REDIS_ID}" | sed 's|/Redis/|/redis/|')
    
    echo "  Importing module.redis.azurerm_redis_cache.arc..."
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      module.redis.azurerm_redis_cache.arc \
      "${REDIS_ID_FIXED}" 2>&1; then
      echo "  ✓ Imported module.redis.azurerm_redis_cache.arc"
    else
      echo "  ⚠️  Failed to import Redis cache. It may not exist yet."
    fi
  else
    echo "  ⚠️  Redis cache '${REDIS_FULL_NAME}' not found in Azure."
    echo "      Available Redis caches in ${RESOURCE_GROUP_SENSITIVE_NAME}:"
    az redis list --resource-group "${RESOURCE_GROUP_SENSITIVE_NAME}" --query "[].name" -o tsv 2>/dev/null | sed 's/^/        - /' || echo "        (none found)"
    echo "  Skipping Redis import."
  fi
else
  echo "  ✓ module.redis.azurerm_redis_cache.arc already in state, skipping"
fi

echo ""
echo "=========================================="
echo "Importing Redis Key Vault Secrets"
echo "=========================================="
echo ""

# Get Key Vault name from variables (constructed as ${sensitive_kv_name}${env}v2)
SENSITIVE_KV_NAME=$(grep "^sensitive_kv_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "hakv")
KEY_VAULT_SENSITIVE_NAME="${SENSITIVE_KV_NAME}${ENV}v2"

# Redis Key Vault secrets
echo "Checking module.redis.azurerm_key_vault_secret.redis-cache-host[0]..."
if ! terraform state show 'module.redis.azurerm_key_vault_secret.redis-cache-host[0]' >/dev/null 2>&1; then
  SECRET_NAME="${REDIS_FULL_NAME}-host"
  SECRET_VERSION_ID=$(az keyvault secret show --vault-name "${KEY_VAULT_SENSITIVE_NAME}" --name "${SECRET_NAME}" --query id -o tsv 2>/dev/null || echo "")
  
  if [ -n "${SECRET_VERSION_ID}" ]; then
    echo "  Importing module.redis.azurerm_key_vault_secret.redis-cache-host[0]..."
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.redis.azurerm_key_vault_secret.redis-cache-host[0]' \
      "${SECRET_VERSION_ID}" 2>&1; then
      echo "  ✓ Imported module.redis.azurerm_key_vault_secret.redis-cache-host[0]"
    else
      echo "  ⚠️  Failed to import redis-cache-host secret"
    fi
  else
    echo "  ⚠️  Secret '${SECRET_NAME}' not found in Key Vault '${KEY_VAULT_SENSITIVE_NAME}'"
  fi
else
  echo "  ✓ module.redis.azurerm_key_vault_secret.redis-cache-host[0] already in state, skipping"
fi

echo "Checking module.redis.azurerm_key_vault_secret.redis-cache-password[0]..."
if ! terraform state show 'module.redis.azurerm_key_vault_secret.redis-cache-password[0]' >/dev/null 2>&1; then
  SECRET_NAME="${REDIS_FULL_NAME}-password"
  SECRET_VERSION_ID=$(az keyvault secret show --vault-name "${KEY_VAULT_SENSITIVE_NAME}" --name "${SECRET_NAME}" --query id -o tsv 2>/dev/null || echo "")
  
  if [ -n "${SECRET_VERSION_ID}" ]; then
    echo "  Importing module.redis.azurerm_key_vault_secret.redis-cache-password[0]..."
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.redis.azurerm_key_vault_secret.redis-cache-password[0]' \
      "${SECRET_VERSION_ID}" 2>&1; then
      echo "  ✓ Imported module.redis.azurerm_key_vault_secret.redis-cache-password[0]"
    else
      echo "  ⚠️  Failed to import redis-cache-password secret"
    fi
  else
    echo "  ⚠️  Secret '${SECRET_NAME}' not found in Key Vault '${KEY_VAULT_SENSITIVE_NAME}'"
  fi
else
  echo "  ✓ module.redis.azurerm_key_vault_secret.redis-cache-password[0] already in state, skipping"
fi

echo "Checking module.redis.azurerm_key_vault_secret.redis-cache-port[0]..."
if ! terraform state show 'module.redis.azurerm_key_vault_secret.redis-cache-port[0]' >/dev/null 2>&1; then
  SECRET_NAME="${REDIS_FULL_NAME}-port"
  SECRET_VERSION_ID=$(az keyvault secret show --vault-name "${KEY_VAULT_SENSITIVE_NAME}" --name "${SECRET_NAME}" --query id -o tsv 2>/dev/null || echo "")
  
  if [ -n "${SECRET_VERSION_ID}" ]; then
    echo "  Importing module.redis.azurerm_key_vault_secret.redis-cache-port[0]..."
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.redis.azurerm_key_vault_secret.redis-cache-port[0]' \
      "${SECRET_VERSION_ID}" 2>&1; then
      echo "  ✓ Imported module.redis.azurerm_key_vault_secret.redis-cache-port[0]"
    else
      echo "  ⚠️  Failed to import redis-cache-port secret"
    fi
  else
    echo "  ⚠️  Secret '${SECRET_NAME}' not found in Key Vault '${KEY_VAULT_SENSITIVE_NAME}'"
  fi
else
  echo "  ✓ module.redis.azurerm_key_vault_secret.redis-cache-port[0] already in state, skipping"
fi

echo ""
echo "Note: Application Registration Key Vault secrets are not imported by this script."
echo "      If needed, import them manually using:"
echo "      az keyvault secret show --vault-name <vault-name> --name <secret-name> --query id -o tsv"
echo ""
echo "=========================================="
echo "Import script completed!"
echo "=========================================="
echo ""
echo "Note: azuread_application_password cannot be imported and will be created fresh."
echo "      This is expected - the password value cannot be retrieved from Azure AD."
echo ""
