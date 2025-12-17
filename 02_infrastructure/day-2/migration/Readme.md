1 - Importing Azure resources using import_azure_resources.sh should be completed successfully first.
2 - Download terraform-infra.tfstate from Azure Storage (legacy state file)
3 - Download terraform-infra-test-v2-day-2.tfstate from Azure Storage (new hello-azure-v2 day-2 state file)
4 - Manually move terraform state resources from legacy Terraform state file to new day-2 state file using the following commands bellow (or adjust and use ./move_terraform_state.sh script)
5 - Make sure you're positioned in the day-2 directory
5 - Run terraform state push ./migration/<new state file> to propagate the changes to the new state file in Azure Storage (this should only create new version of the state file, since versioning should be enabled for the storage account)

Example:
```bash
# <module>.<type>.<name> e.g. module.workloads.random_password.rabbitmq_password_chat -> random_password.rabbitmq_password_chat (module.workloads is old nested module structure and new one in the root of the state file)

terraform state mv -state=terraform-infra.tfstate -state-out=terraform-infra-test-v2-day-2.tfstate module.workloads.random_password.rabbitmq_password_chat random_password.rabbitmq_password_chat
terraform state mv -state=terraform-infra.tfstate -state-out=terraform-infra-test-v2-day-2.tfstate module.workloads.random_password.encryption_key_app_repository random_password.encryption_key_app_repository
terraform state mv -state=terraform-infra.tfstate -state-out=terraform-infra-test-v2-day-2.tfstate module.workloads.random_password.postgres_password random_password.postgres_password
terraform state mv -state=terraform-infra.tfstate -state-out=terraform-infra-test-v2-day-2.tfstate module.workloads.random_password.postgres_username random_password.postgres_username
terraform state mv -state=terraform-infra.tfstate -state-out=terraform-infra-test-v2-day-2.tfstate module.workloads.random_password.zitadel_master_key random_password.zitadel_master_key
terraform state mv -state=terraform-infra.tfstate -state-out=terraform-infra-test-v2-day-2.tfstate module.workloads.random_id.encryption_key_ingestion random_id.encryption_key_ingestion
terraform state mv -state=terraform-infra.tfstate -state-out=terraform-infra-test-v2-day-2.tfstate module.identities.module.application_registration.azuread_application_password.aad_app_password module.application_registration.azuread_application_password.aad_app_password
terraform state mv -state=terraform-infra.tfstate -state-out=terraform-infra-test-v2-day-2.tfstate 'module.workloads.module.postgresql.azurerm_key_vault_secret.database_connection_strings["app-repository"]' 'module.postgresql.azurerm_key_vault_secret.database_connection_strings["app-repository"]'
terraform state mv -state=terraform-infra.tfstate -state-out=terraform-infra-test-v2-day-2.tfstate 'module.workloads.module.postgresql.azurerm_key_vault_secret.database_connection_strings["chat"]' 'module.postgresql.azurerm_key_vault_secret.database_connection_strings["chat"]'
terraform state mv -state=terraform-infra.tfstate -state-out=terraform-infra-test-v2-day-2.tfstate 'module.workloads.module.postgresql.azurerm_key_vault_secret.database_connection_strings["ingestion"]' 'module.postgresql.azurerm_key_vault_secret.database_connection_strings["ingestion"]'
terraform state mv -state=terraform-infra.tfstate -state-out=terraform-infra-test-v2-day-2.tfstate 'module.workloads.module.postgresql.azurerm_key_vault_secret.database_connection_strings["scope-management"]' 'module.postgresql.azurerm_key_vault_secret.database_connection_strings["scope-management"]'
terraform state mv -state=terraform-infra.tfstate -state-out=terraform-infra-test-v2-day-2.tfstate 'module.workloads.module.postgresql.azurerm_key_vault_secret.database_connection_strings["theme"]' 'module.postgresql.azurerm_key_vault_secret.database_connection_strings["theme"]'
terraform state mv -state=terraform-infra.tfstate -state-out=terraform-infra-test-v2-day-2.tfstate 'module.workloads.module.kubernetes_cluster.azurerm_log_analytics_workspace_table.basic_log_table["AKSControlPlane"]' 'module.kubernetes_cluster.azurerm_log_analytics_workspace_table.basic_log_table["AKSControlPlane"]'
terraform state mv -state=terraform-infra.tfstate -state-out=terraform-infra-test-v2-day-2.tfstate 'module.workloads.module.kubernetes_cluster.azurerm_log_analytics_workspace_table.basic_log_table["ContainerLogV2"]' 'module.kubernetes_cluster.azurerm_log_analytics_workspace_table.basic_log_table["ContainerLogV2"]'
# terraform state mv -state=terraform-infra.tfstate -state-out=terraform-infra-test-v2-day-2.tfstate 'module.workloads.random_id.encryption_key_node_chat_lxm' 'random_id.encryption_key_node_chat_lxm'
terraform state mv -state=terraform-infra.tfstate -state-out=terraform-infra-test-v2-day-2.tfstate 'module.identities.azurerm_role_assignment.telemetry_observer_users' 'azurerm_role_assignment.telemetry_observer_users'
terraform state mv -state=terraform-infra.tfstate -state-out=terraform-infra-test-v2-day-2.tfstate 'module.workloads.azurerm_key_vault_secret.encryption_key_node_chat_lxm' 'azurerm_key_vault_secret.encryption_key_node_chat_lxm'
terraform state mv -state=terraform-infra.tfstate -state-out=terraform-infra-test-v2-day-2.tfstate 'module.identities.azurerm_role_assignment.telemetry_observer_group' 'azurerm_role_assignment.telemetry_observer_group'
terraform state mv -state=terraform-infra.tfstate -state-out=terraform-infra-test-v2-day-2.tfstate 'module.identities.azurerm_role_assignment.monitor_metrics_reader' 'azurerm_role_assignment.monitor_metrics_reader'

```