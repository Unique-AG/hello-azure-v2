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
echo "Importing OpenAI Resources"
echo "=========================================="
echo ""

# Get subscription ID and resource group name from variables
# Try to get subscription ID from VAR_CONFIG first, then from Azure CLI
SUBSCRIPTION_ID=$(grep "^subscription_id" "${VAR_CONFIG}" 2>/dev/null | cut -d'"' -f2 || az account show --query id -o tsv 2>/dev/null || echo "")
if [ -z "${SUBSCRIPTION_ID}" ]; then
  echo "  ⚠️  Warning: Could not determine subscription ID. Some imports may fail."
  echo "     Please ensure subscription_id is set in ${VAR_CONFIG} or run 'az login'"
fi
RESOURCE_GROUP_CORE=$(grep "^resource_group_core_name" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "resource-group-core")
ENV_SUFFIX=$(grep "^env" "${VAR_PARAMS}" | cut -d'"' -f2 || echo "test")

# OpenAI Cognitive Account
OPENAI_ACCOUNT_NAME="cognitive-account-swedencentral-${ENV_SUFFIX}"
echo "Checking module.openai.azurerm_cognitive_account.aca[\"cognitive-account-swedencentral\"]..."
if ! terraform state show 'module.openai.azurerm_cognitive_account.aca["cognitive-account-swedencentral"]' >/dev/null 2>&1; then
  echo "  Importing module.openai.azurerm_cognitive_account.aca[\"cognitive-account-swedencentral\"]..."
  # Get resource ID: /subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.CognitiveServices/accounts/{name}
  COGNITIVE_ACCOUNT_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE}/providers/Microsoft.CognitiveServices/accounts/${OPENAI_ACCOUNT_NAME}"
  terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
    'module.openai.azurerm_cognitive_account.aca["cognitive-account-swedencentral"]' \
    "${COGNITIVE_ACCOUNT_ID}"
  echo "  ✓ Imported module.openai.azurerm_cognitive_account.aca[\"cognitive-account-swedencentral\"]"
else
  echo "  ✓ module.openai.azurerm_cognitive_account.aca[\"cognitive-account-swedencentral\"] already in state, skipping"
fi

# OpenAI Cognitive Deployments
echo ""
echo "Importing OpenAI Cognitive Deployments..."
DEPLOYMENTS=(
  "text-embedding-ada-002:text-embedding-ada-002"
  "gpt-35-turbo-0125:gpt-35-turbo-0125"
  "gpt-4o-2024-11-20:gpt-4o-2024-11-20"
)

for deployment_pair in "${DEPLOYMENTS[@]}"; do
  IFS=':' read -r deployment_key deployment_name <<< "${deployment_pair}"
  # Deployment key format in module: "${account_key}-${deployment.name}"
  DEPLOYMENT_STATE_KEY="cognitive-account-swedencentral-${deployment_name}"
  echo "Checking module.openai.azurerm_cognitive_deployment.deployments[\"${DEPLOYMENT_STATE_KEY}\"]..."
  if ! terraform state show "module.openai.azurerm_cognitive_deployment.deployments[\"${DEPLOYMENT_STATE_KEY}\"]" >/dev/null 2>&1; then
    echo "  Importing module.openai.azurerm_cognitive_deployment.deployments[\"${DEPLOYMENT_STATE_KEY}\"]..."
    # Get resource ID: /subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.CognitiveServices/accounts/{account}/deployments/{name}
    DEPLOYMENT_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE}/providers/Microsoft.CognitiveServices/accounts/${OPENAI_ACCOUNT_NAME}/deployments/${deployment_name}"
    terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      "module.openai.azurerm_cognitive_deployment.deployments[\"${DEPLOYMENT_STATE_KEY}\"]" \
      "${DEPLOYMENT_ID}"
    echo "  ✓ Imported module.openai.azurerm_cognitive_deployment.deployments[\"${DEPLOYMENT_STATE_KEY}\"]"
  else
    echo "  ✓ module.openai.azurerm_cognitive_deployment.deployments[\"${DEPLOYMENT_STATE_KEY}\"] already in state, skipping"
  fi
done

# Speech Service Account
echo ""
echo "Importing Speech Service Resources..."
SPEECH_SERVICE_NAME="speech-service-${ENV_SUFFIX}"
echo "Checking module.speech_service.azurerm_cognitive_account.aca[\"swedencentral-speech\"]..."
if ! terraform state show 'module.speech_service.azurerm_cognitive_account.aca["swedencentral-speech"]' >/dev/null 2>&1; then
  echo "  Importing module.speech_service.azurerm_cognitive_account.aca[\"swedencentral-speech\"]..."
  # Speech Service account name pattern
  SPEECH_ACCOUNT_NAME=$(az cognitiveservices account list --resource-group "${RESOURCE_GROUP_CORE}" --query "[?kind=='SpeechServices'].name" -o tsv 2>/dev/null | head -1 || echo "")
  if [ -z "${SPEECH_ACCOUNT_NAME}" ]; then
    echo "  ⚠️  Could not find Speech Service account. Please import manually:"
    echo "     az cognitiveservices account list --resource-group ${RESOURCE_GROUP_CORE} --query \"[?kind=='SpeechServices'].name\" -o tsv"
    echo "     terraform import -var-file=\"${VAR_CONFIG}\" -var-file=\"${VAR_PARAMS}\" \\"
    echo "       'module.speech_service.azurerm_cognitive_account.aca[\"swedencentral-speech\"]' \\"
    echo "       '/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE}/providers/Microsoft.CognitiveServices/accounts/{account-name}'"
  else
    SPEECH_ACCOUNT_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE}/providers/Microsoft.CognitiveServices/accounts/${SPEECH_ACCOUNT_NAME}"
    terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.speech_service.azurerm_cognitive_account.aca["swedencentral-speech"]' \
      "${SPEECH_ACCOUNT_ID}"
    echo "  ✓ Imported module.speech_service.azurerm_cognitive_account.aca[\"swedencentral-speech\"]"
  fi
else
  echo "  ✓ module.speech_service.azurerm_cognitive_account.aca[\"swedencentral-speech\"] already in state, skipping"
fi

# Speech Service Private Endpoint (if exists)
echo ""
echo "Checking for Speech Service Private Endpoint..."
if ! terraform state show 'module.speech_service.azurerm_private_endpoint.pe["swedencentral-speech"]' >/dev/null 2>&1; then
  echo "  Checking if private endpoint exists in Azure..."
  PRIVATE_ENDPOINT_NAME=$(az network private-endpoint list --resource-group "${RESOURCE_GROUP_CORE}" --query "[?contains(name, 'speech')].name" -o tsv 2>/dev/null | head -1 || echo "")
  if [ -n "${PRIVATE_ENDPOINT_NAME}" ]; then
    echo "  Importing module.speech_service.azurerm_private_endpoint.pe[\"swedencentral-speech\"]..."
    PRIVATE_ENDPOINT_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE}/providers/Microsoft.Network/privateEndpoints/${PRIVATE_ENDPOINT_NAME}"
    terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.speech_service.azurerm_private_endpoint.pe["swedencentral-speech"]' \
      "${PRIVATE_ENDPOINT_ID}"
    echo "  ✓ Imported module.speech_service.azurerm_private_endpoint.pe[\"swedencentral-speech\"]"
  else
    echo "  ℹ️  No private endpoint found for Speech Service (this is expected if public_network_access_enabled is true)"
  fi
else
  echo "  ✓ module.speech_service.azurerm_private_endpoint.pe[\"swedencentral-speech\"] already in state, skipping"
fi

# Document Intelligence Account
echo ""
echo "Importing Document Intelligence Resources..."
DOC_INTELLIGENCE_NAME="doc-intelligence-${ENV_SUFFIX}"
echo "Checking module.document_intelligence.azurerm_cognitive_account.aca[\"swedencentral-form-recognizer\"]..."
if ! terraform state show 'module.document_intelligence.azurerm_cognitive_account.aca["swedencentral-form-recognizer"]' >/dev/null 2>&1; then
  echo "  Importing module.document_intelligence.azurerm_cognitive_account.aca[\"swedencentral-form-recognizer\"]..."
  # Document Intelligence uses FormRecognizer account name pattern
  # The actual account name might be different - check Azure Portal or use: az cognitiveservices account list --resource-group ${RESOURCE_GROUP_CORE} --query "[?kind=='FormRecognizer'].name" -o tsv
  DOC_INTELLIGENCE_ACCOUNT_NAME=$(az cognitiveservices account list --resource-group "${RESOURCE_GROUP_CORE}" --query "[?kind=='FormRecognizer'].name" -o tsv 2>/dev/null | head -1 || echo "")
  if [ -z "${DOC_INTELLIGENCE_ACCOUNT_NAME}" ]; then
    echo "  ⚠️  Could not find Document Intelligence account. Please import manually:"
    echo "     az cognitiveservices account list --resource-group ${RESOURCE_GROUP_CORE} --query \"[?kind=='FormRecognizer'].name\" -o tsv"
    echo "     terraform import -var-file=\"${VAR_CONFIG}\" -var-file=\"${VAR_PARAMS}\" \\"
    echo "       'module.document_intelligence.azurerm_cognitive_account.aca[\"swedencentral-form-recognizer\"]' \\"
    echo "       '/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE}/providers/Microsoft.CognitiveServices/accounts/{account-name}'"
  else
    DOC_INTELLIGENCE_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_CORE}/providers/Microsoft.CognitiveServices/accounts/${DOC_INTELLIGENCE_ACCOUNT_NAME}"
    terraform import -var-file="${VAR_CONFIG}" -var-file="${VAR_PARAMS}" \
      'module.document_intelligence.azurerm_cognitive_account.aca["swedencentral-form-recognizer"]' \
      "${DOC_INTELLIGENCE_ID}"
    echo "  ✓ Imported module.document_intelligence.azurerm_cognitive_account.aca[\"swedencentral-form-recognizer\"]"
  fi
else
  echo "  ✓ module.document_intelligence.azurerm_cognitive_account.aca[\"swedencentral-form-recognizer\"] already in state, skipping"
fi

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
