locals {
  resource_group_name = "${var.resource_group_name}-${var.env}"
  key                 = "${var.key}-${var.env}-v2.tfstate"
}

