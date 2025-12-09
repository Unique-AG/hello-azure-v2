# Azure Bastion Outputs

output "bastion_id" {
  description = "The ID of the Azure Bastion host"
  value       = azurerm_bastion_host.this.id
}

output "bastion_name" {
  description = "The name of the Azure Bastion host"
  value       = azurerm_bastion_host.this.name
}

output "bastion_fqdn" {
  description = "The FQDN of the Azure Bastion host"
  value       = azurerm_bastion_host.this.dns_name
}

output "bastion_public_ip_id" {
  description = "The ID of the public IP address used by Azure Bastion"
  value       = azurerm_public_ip.bastion.id
}

output "bastion_public_ip_name" {
  description = "The name of the public IP address used by Azure Bastion"
  value       = azurerm_public_ip.bastion.name
}

output "bastion_public_ip_address" {
  description = "The IP address of the public IP used by Azure Bastion"
  value       = azurerm_public_ip.bastion.ip_address
}

