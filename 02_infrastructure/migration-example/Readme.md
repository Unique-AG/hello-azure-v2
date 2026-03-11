# Terraform State Migration example - from legacy hello-azure to hello-azure-v2

This migration folder gives an example for migrating Terraform state from the legacy infrastructure to the new hello-azure-v2 state files.
Guid should not be followed blindly, you should understand each step and make your own adjustments.

## Prerequisites

- ✅ Importing Azure resources using `import_azure_resources.sh` should be completed successfully first.

## Migration Steps

### Step 1: Download State Files

Download the following state files from Azure Storage:

1. **Legacy state file**: `terraform-infra.tfstate`
    ```bash	
    terraform state pull > terraform-infra.tfstate
    ```
2. **New day-1 state file**: `terraform-infra-test-day-1.tfstate`
3. **New day-2 state file**: `terraform-infra-test-day-2.tfstate`
### Step 2: Move State Resources

Manually move Terraform state resources from the legacy Terraform state file to the new day-1 and day-2 state files using one of the following options:

**Option A: Use the provided script (after you made your adjustments)**
```bash
./move_azure_resource_day_1.sh
./move_azure_resource_day_2.sh
#or
./import_azure_resources_day_1.sh
./import_azure_resources_day_2.sh
```

**Option B: Run commands manually (check the script for details)**
- Adjust and use the commands from `move_azure_resource_day_1.sh` and `move_azure_resource_day_2.sh` scripts
- Ensure you understand each state move operation before executing

## Important Notes
- Always verify state file backups before proceeding
- Review the state moves carefully before pushing to Azure Storage
- Ensure Azure Storage account versioning is enabled for state file protection
- Following this steps should only create a new version of the state file, since versioning should be enabled for the storage account. Should something go wrong, you can always revert to the previous version.