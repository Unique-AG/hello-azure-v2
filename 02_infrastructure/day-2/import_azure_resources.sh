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

echo ""
echo "=========================================="
echo "Importing Key Vault Secrets"
echo "=========================================="
echo ""

# Helper function to import a Key Vault secret
import_key_vault_secret() {
  local resource_name=$1
  local vault_name=$2
  local secret_name=$3

  if ! terraform state show "${resource_name}" >/dev/null 2>&1; then
    echo "Checking azurerm_key_vault_secret.${resource_name#azurerm_key_vault_secret.}..."
    
    # Get the version ID from Azure CLI
    local version_id
    version_id=$(az keyvault secret show \
      --vault-name "${vault_name}" \
      --name "${secret_name}" \
      --query id -o tsv 2>/dev/null)
    
    if [ -z "${version_id}" ]; then
      echo "  ⚠️  Secret '${secret_name}' not found in vault '${vault_name}', skipping"
      return
    fi
    
    echo "  Importing ${resource_name}..."
    if terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      "${resource_name}" \
      "${version_id}" 2>/dev/null; then
      echo "  ✓ Imported ${resource_name}"
    else
      echo "  ✗ Failed to import ${resource_name}"
    fi
  else
    echo "  ✓ ${resource_name} already in state, skipping"
  fi
}

# Get Key Vault names from locals (they follow the pattern: hakv1${ENV}v2 and hakv2${ENV}v2)
SENSITIVE_KV_NAME="hakv2${ENV}v2"
CORE_KV_NAME="hakv1${ENV}v2"

echo "Using Key Vaults:"
echo "  - Sensitive: ${SENSITIVE_KV_NAME}"
echo "  - Core: ${CORE_KV_NAME}"
echo ""

# Import secrets from 33-secrets.tf
# Secrets in sensitive Key Vault
import_key_vault_secret \
  "azurerm_key_vault_secret.rabbitmq_password_chat" \
  "${SENSITIVE_KV_NAME}" \
  "rabbitmq-password-chat"

import_key_vault_secret \
  "azurerm_key_vault_secret.zitadel_db_user_password" \
  "${SENSITIVE_KV_NAME}" \
  "zitadel-db-user-password"

import_key_vault_secret \
  "azurerm_key_vault_secret.zitadel_master_key" \
  "${SENSITIVE_KV_NAME}" \
  "zitadel-master-key"

import_key_vault_secret \
  "azurerm_key_vault_secret.encryption_key_app_repository" \
  "${SENSITIVE_KV_NAME}" \
  "encryption-key-app-repository"

import_key_vault_secret \
  "azurerm_key_vault_secret.encryption_key_ingestion" \
  "${SENSITIVE_KV_NAME}" \
  "encryption-key-ingestion"

# Secret in core Key Vault
import_key_vault_secret \
  "azurerm_key_vault_secret.zitadel_pat" \
  "${CORE_KV_NAME}" \
  "manual-zitadel-scope-mgmt-pat"

import_key_vault_secret \
  "azurerm_key_vault_secret.encryption_key_node_chat_lxm" \
  "${SENSITIVE_KV_NAME}" \
  "encryption-key-chat-lxm"

echo ""
echo "=========================================="
echo "Application Registration Secrets"
echo "=========================================="
echo ""
echo "⚠️  Application registration secrets are NOT imported by this script."
echo ""
echo "Expected behavior:"
echo "  - terraform plan will show these as 'to be created':"
echo "    * module.application_registration.azurerm_key_vault_secret.aad_app_gitops_client_id[0]"
echo "    * module.application_registration.azurerm_key_vault_secret.aad_app_gitops_client_secret[0]"
echo ""
echo "Resolution:"
echo "  1. Let Terraform create them fresh (recommended if values can be regenerated)"
echo "  2. Manually import with version ID (get version from Azure Portal or CLI):"
echo "     az keyvault secret show --vault-name ${SENSITIVE_KV_NAME} --name <secret-name> --query id -o tsv"
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
