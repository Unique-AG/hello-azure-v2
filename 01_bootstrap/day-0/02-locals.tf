locals {
  resource_group_name = "rg-terraform-state-${var.env}"
  key                 = "terraform-init-${var.env}-v2.tfstate"
}

