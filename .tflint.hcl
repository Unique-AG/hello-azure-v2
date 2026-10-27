# tflint configuration for every Terraform root (run with `tflint --recursive`).
config {
  call_module_type = "none"
}

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "azurerm" {
  enabled = true
  version = "0.33.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

# The Ephemeral tier (day-2, day-3) is torn down and re-created by design (Phase 2 Cycle).
rule "azurerm_resources_missing_prevent_destroy" {
  enabled = false
}

# Unused variables, locals and data sources are dead code from the v1 layout; task 0007-004 removes them and
# re-enables this rule.
rule "terraform_unused_declarations" {
  enabled = false
}
