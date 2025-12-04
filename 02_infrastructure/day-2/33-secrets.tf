# Key Vault Secrets
# This file manages secrets stored in Azure Key Vaults
# Secrets are organized by category: passwords, encryption keys, and manual secrets

# ============================================================================
# Password Secrets
# ============================================================================

# RabbitMQ Password for Chat Service
resource "random_password" "rabbitmq_password_chat" {
  keepers = {
    version = "1"
  }
  length  = var.rabbitmq_password_chat_length
  special = false
}

resource "azurerm_key_vault_secret" "rabbitmq_password_chat" {
  name            = var.rabbitmq_password_chat_secret_name
  value           = random_password.rabbitmq_password_chat.result
  key_vault_id    = data.azurerm_key_vault.key_vault_sensitive.id
  expiration_date = var.secret_expiration_date
}

# Zitadel Database User Password
resource "random_password" "zitadel_db_user_password" {
  keepers = {
    version = "1"
  }
  length  = 32 # Must be exactly 32 according to Zitadel documentation
  special = false
}

resource "azurerm_key_vault_secret" "zitadel_db_user_password" {
  name            = var.zitadel_db_user_password_secret_name
  value           = random_password.zitadel_db_user_password.result
  key_vault_id    = data.azurerm_key_vault.key_vault_sensitive.id
  expiration_date = var.secret_expiration_date
}

# Zitadel Master Key
resource "random_password" "zitadel_master_key" {
  keepers = {
    version = "1"
  }
  length  = 32 # Must be exactly 32 according to Zitadel documentation
  special = false
}

resource "azurerm_key_vault_secret" "zitadel_master_key" {
  name         = var.zitadel_master_key_secret_name
  value        = random_password.zitadel_master_key.result
  key_vault_id = data.azurerm_key_vault.key_vault_sensitive.id
}

# ============================================================================
# Encryption Key Secrets
# ============================================================================

# Application Repository Encryption Key
resource "random_password" "encryption_key_app_repository" {
  keepers = {
    version = "1"
  }
  length  = var.secret_password_length
  special = false
}

resource "azurerm_key_vault_secret" "encryption_key_app_repository" {
  name            = var.encryption_key_app_repository_secret_name
  value           = random_password.encryption_key_app_repository.result
  key_vault_id    = data.azurerm_key_vault.key_vault_sensitive.id
  expiration_date = var.secret_expiration_date
}

# Node Chat LXM Encryption Key
resource "random_id" "encryption_key_node_chat_lxm" {
  keepers = {
    version = "1"
  }
  byte_length = var.secret_password_length
}

resource "azurerm_key_vault_secret" "encryption_key_node_chat_lxm" {
  name            = var.encryption_key_node_chat_lxm_secret_name
  value           = random_id.encryption_key_node_chat_lxm.hex
  key_vault_id    = data.azurerm_key_vault.key_vault_sensitive.id
  expiration_date = var.secret_expiration_date
}

# Ingestion Encryption Key
resource "random_id" "encryption_key_ingestion" {
  keepers = {
    version = "1"
  }
  byte_length = var.secret_password_length
}

resource "azurerm_key_vault_secret" "encryption_key_ingestion" {
  name            = var.encryption_key_ingestion_secret_name
  value           = random_id.encryption_key_ingestion.hex
  key_vault_id    = data.azurerm_key_vault.key_vault_sensitive.id
  expiration_date = var.secret_expiration_date
}

# ============================================================================
# Manual Secrets (Placeholders)
# ============================================================================

# Zitadel Personal Access Token (PAT)
# This secret is created as a placeholder and must be set manually
resource "azurerm_key_vault_secret" "zitadel_pat" {
  name         = var.zitadel_pat_secret_name
  value        = "<TO BE SET MANUALLY>"
  key_vault_id = data.azurerm_key_vault.key_vault_core.id

  lifecycle {
    ignore_changes = [value, tags]
  }
}