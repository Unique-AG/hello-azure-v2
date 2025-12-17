# Terraform State Migration Guide

This guide describes the process for migrating Terraform state from the legacy infrastructure to the new hello-azure-v2 day-2 state file.

## Prerequisites

- ✅ Importing Azure resources using `import_azure_resources.sh` should be completed successfully first.

## Migration Steps

### Step 1: Download State Files

Download the following state files from Azure Storage:

1. **Legacy state file**: `terraform-infra.tfstate`
2. **New day-2 state file**: `terraform-infra-test-v2-day-2.tfstate`

### Step 2: Move State Resources

Manually move Terraform state resources from the legacy Terraform state file to the new day-2 state file using one of the following options:

**Option A: Use the provided script**
```bash
./move_terraform_state.sh
```

**Option B: Run commands manually**
- Adjust and use the commands from `move_terraform_state.sh` script
- Ensure you understand each state move operation before executing

### Step 3: Push State to Azure Storage

1. Make sure you're positioned in the `day-2` directory:
   ```bash
   cd /var/git/repos/hello-azure-v2/02_infrastructure/day-2
   ```

2. Run terraform state push to propagate the changes:
   ```bash
   terraform state push ./migration/<new-state-file>
   ```

   **Note**: This should only create a new version of the state file, since versioning should be enabled for the storage account.

## Important Notes

- Always verify state file backups before proceeding
- Review the state moves carefully before pushing to Azure Storage
- Ensure Azure Storage account versioning is enabled for state file protection
