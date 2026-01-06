#!/bin/bash
set -euo pipefail

export LEGACY_STATE_FILE="terraform-infra.tfstate"
export NEW_STATE_FILE="terraform-infra-test-v2-day-2.tfstate"

# After each terraform state mv command, inccrement "serial": value in the NEW_STATE_FILE and run terraform state push to propagate the changes
# (cd .. && terraform state push ./migration/$NEW_STATE_FILE)
# Alternatively, you can execute whole script and push the changes at the end

# Move terraform state resources from legacy Terraform state file to new day-2 state file
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE module.workloads.random_password.rabbitmq_password_chat random_password.rabbitmq_password_chat
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE module.workloads.random_password.encryption_key_app_repository random_password.encryption_key_app_repository
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE module.workloads.random_password.postgres_password random_password.postgres_password
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE module.workloads.random_password.postgres_username random_password.postgres_username
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE module.workloads.random_password.zitadel_master_key random_password.zitadel_master_key
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE module.workloads.random_password.zitadel_db_user_password random_password.zitadel_db_user_password
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE module.workloads.random_id.encryption_key_ingestion random_id.encryption_key_ingestion
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE module.identities.module.application_registration.azuread_application_password.aad_app_password module.application_registration.azuread_application_password.aad_app_password
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.workloads.module.postgresql.azurerm_key_vault_secret.database_connection_strings["app-repository"]' 'module.postgresql.azurerm_key_vault_secret.database_connection_strings["app-repository"]'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.workloads.module.postgresql.azurerm_key_vault_secret.database_connection_strings["chat"]' 'module.postgresql.azurerm_key_vault_secret.database_connection_strings["chat"]'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.workloads.module.postgresql.azurerm_key_vault_secret.database_connection_strings["ingestion"]' 'module.postgresql.azurerm_key_vault_secret.database_connection_strings["ingestion"]'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.workloads.module.postgresql.azurerm_key_vault_secret.database_connection_strings["scope-management"]' 'module.postgresql.azurerm_key_vault_secret.database_connection_strings["scope-management"]'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.workloads.module.postgresql.azurerm_key_vault_secret.database_connection_strings["theme"]' 'module.postgresql.azurerm_key_vault_secret.database_connection_strings["theme"]'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.workloads.module.kubernetes_cluster.azurerm_log_analytics_workspace_table.basic_log_table["AKSControlPlane"]' 'module.kubernetes_cluster.azurerm_log_analytics_workspace_table.basic_log_table["AKSControlPlane"]'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.workloads.module.kubernetes_cluster.azurerm_log_analytics_workspace_table.basic_log_table["ContainerLogV2"]' 'module.kubernetes_cluster.azurerm_log_analytics_workspace_table.basic_log_table["ContainerLogV2"]'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.workloads.random_id.encryption_key_node_chat_lxm' 'random_id.encryption_key_node_chat_lxm'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.identities.azurerm_role_assignment.telemetry_observer_users' 'azurerm_role_assignment.telemetry_observer_users'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.identities.azurerm_role_assignment.telemetry_observer_group' 'azurerm_role_assignment.telemetry_observer_group'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.identities.azurerm_role_assignment.monitor_metrics_reader' 'azurerm_role_assignment.monitor_metrics_reader' 
#NOTE: this was missing when compared with dev hello-azure state file
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.azurerm_federated_identity_credential.afic_workloads["assistants-core"]' 'azurerm_federated_identity_credential.afic_workloads["assistants-core"]'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.azurerm_federated_identity_credential.afic_workloads["backend-service-chat"]' 'azurerm_federated_identity_credential.afic_workloads["backend-service-chat"]'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.azurerm_federated_identity_credential.afic_workloads["backend-service-ingestion"]' 'azurerm_federated_identity_credential.afic_workloads["backend-service-ingestion"]'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.azurerm_federated_identity_credential.afic_workloads["backend-service-ingestion-worker"]' 'azurerm_federated_identity_credential.afic_workloads["backend-service-ingestion-worker"]'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.azurerm_federated_identity_credential.afic_workloads["backend-service-ingestion-worker-chat"]' 'azurerm_federated_identity_credential.afic_workloads["backend-service-ingestion-worker-chat"]'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.azurerm_federated_identity_credential.afic_workloads["backend-service-speech"]' 'azurerm_federated_identity_credential.afic_workloads["backend-service-speech"]'


terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.identities.azurerm_role_assignment.audit_storage_kv_key_reader' 'azurerm_role_assignment.audit_storage_kv_key_reader'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.identities.azurerm_role_assignment.audit_storage_kv_secrets_reader' 'azurerm_role_assignment.audit_storage_kv_secrets_reader'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.identities.azurerm_role_assignment.aks_workload_identity_cognitive_services_user' 'azurerm_role_assignment.aks_workload_identity_cognitive_services_user'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.identities.azurerm_role_assignment.application_gateway_ingres_controller_contributor_role' 'azurerm_role_assignment.application_gateway_ingres_controller_contributor_role'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.identities.azurerm_role_assignment.application_gateway_ingres_controller_reader_role' 'azurerm_role_assignment.application_gateway_ingres_controller_reader_role'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.identities.azurerm_role_assignment.application_gateway_ingres_controller_vnet_subnet_access' 'azurerm_role_assignment.application_gateway_ingres_controller_vnet_subnet_access'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.identities.azurerm_role_assignment.cluster_rbac_admin_terraform' 'azurerm_role_assignment.cluster_rbac_admin_terraform'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.identities.azurerm_role_assignment.cluster_user_terraform' 'azurerm_role_assignment.cluster_user_terraform'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.identities.azurerm_role_assignment.csi_identity_secret_reader' 'azurerm_role_assignment.csi_identity_secret_reader'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.identities.azurerm_role_assignment.csi_identity_secret_reader_main_kv' 'azurerm_role_assignment.csi_identity_secret_reader_main_kv'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.identities.azurerm_role_assignment.dns_contributor' 'azurerm_role_assignment.dns_contributor'

terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.workloads.module.audit_storage.azurerm_key_vault_key.storage-account-byok[0]' 'module.audit_storage.azurerm_key_vault_key.storage-account-byok[0]'