#!/bin/bash
set -euo pipefail

LEGACY_STATE_FILE="terraform-infra.tfstate"
NEW_STATE_FILE="terraform-infra-test-v2-day-2-final-test-2.tfstate"

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
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.workloads.module.postgresql.azurerm_key_vault_secret.username' 'module.postgresql.azurerm_key_vault_secret.username'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.workloads.module.postgresql.azurerm_key_vault_secret.port' 'module.postgresql.azurerm_key_vault_secret.port'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.workloads.module.postgresql.azurerm_key_vault_secret.password' 'module.postgresql.azurerm_key_vault_secret.password'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.workloads.module.postgresql.azurerm_key_vault_secret.host' 'module.postgresql.azurerm_key_vault_secret.host'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.workloads.module.kubernetes_cluster.azurerm_log_analytics_workspace_table.basic_log_table["AKSControlPlane"]' 'module.kubernetes_cluster.azurerm_log_analytics_workspace_table.basic_log_table["AKSControlPlane"]'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.workloads.module.kubernetes_cluster.azurerm_log_analytics_workspace_table.basic_log_table["ContainerLogV2"]' 'module.kubernetes_cluster.azurerm_log_analytics_workspace_table.basic_log_table["ContainerLogV2"]'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.workloads.random_id.encryption_key_node_chat_lxm' 'random_id.encryption_key_node_chat_lxm'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.identities.azurerm_role_assignment.telemetry_observer_users' 'azurerm_role_assignment.telemetry_observer_users'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.identities.azurerm_role_assignment.telemetry_observer_group' 'azurerm_role_assignment.telemetry_observer_group'
terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.identities.azurerm_role_assignment.monitor_metrics_reader' 'azurerm_role_assignment.monitor_metrics_reader'

# terraform state mv -state=$LEGACY_STATE_FILE -state-out=$NEW_STATE_FILE 'module.workloads.azurerm_key_vault_secret.encryption_key_node_chat_lxm' 'azurerm_key_vault_secret.encryption_key_node_chat_lxm'