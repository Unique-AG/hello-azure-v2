locals {
  resource_group_name = var.resource_group_name != null ? var.resource_group_name : "rg-terraform-state-${var.env}"
  key                 = var.key != null ? var.key : "terraform-init-${var.env}-v2.tfstate"
}

