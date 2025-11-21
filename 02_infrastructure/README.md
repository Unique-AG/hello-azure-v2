# Infrastructure Template Generator

This directory uses Terraform's `templatefile()` function to generate environment-specific configurations from templates, reducing duplication and ensuring consistency across environments.

## Structure

```
02_infrastructure/
├── generator.tf              # Main generator using templatefile() and local_file
├── build.sh                  # Automated build script
├── environments.tfvars      # Environment definitions (dev, test)
├── templates/                # Template files (.tftmpl)
│   ├── 00-config.auto.tfvars.tftmpl
│   ├── 00-environment.auto.tfvars.tftmpl
│   ├── 90-backend.tf.tftmpl
│   ├── 91-providers.tf.tftmpl
│   └── 92-versions.tf.tftmpl
├── test/                    # Source files (shared resource definitions)
│   ├── 01-variables.tf
│   ├── 02-locals.tf
│   ├── 03-data.tf
│   ├── 10-resource-groups.tf
│   └── ... (other resource files)
└── generated/               # Generated environments (gitignored)
    ├── dev/
    └── test/
```

## How It Works

1. **Templates** (`.tftmpl` files) contain parameterized Terraform configurations
2. **Generator** (`generator.tf`) uses `templatefile()` to render templates with environment-specific values
3. **Build Script** (`build.sh`) runs the generator and copies shared files to each environment
4. **Generated Output** creates complete, ready-to-use Terraform configurations in `generated/`

## Usage

### Generate Environments

```bash
cd 02_infrastructure
./build.sh
```

This will:
- Generate environment-specific files from templates
- Copy shared resource files to each generated environment
- Create complete Terraform configurations in `generated/dev/` and `generated/test/`

### Use Generated Environment

```bash
# Navigate to generated environment
cd generated/test

# Initialize Terraform
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply
```

### Adding a New Environment

1. Edit `environments.tfvars` and add a new environment entry:

```hcl
environments = {
  # ... existing environments
  prod = {
    name                 = "prod"
    subscription_id      = "..."
    storage_account_name = "..."
    # ... other configuration
  }
}
```

2. Run the build script:

```bash
./build.sh
```

3. The new environment will be generated in `generated/prod/`

## Template Variables

Each template receives an `environment` object with the following properties:

- `name` - Environment name (dev, test, prod)
- `subscription_id` - Azure subscription ID
- `storage_account_name` - Terraform state storage account
- `container_name` - Terraform state container
- `key` - Terraform state file key
- `resource_group_name` - Resource group for Terraform state
- `tenant_id` - Azure AD tenant ID
- `client_id` - Azure AD application client ID
- `name_prefix` - Prefix for resource naming
- `environment` - Environment identifier
- `dns_zone_name` - DNS zone name

## Customizing Templates

To modify environment-specific configurations:

1. Edit the corresponding template file in `templates/`
2. Use `${environment.variable_name}` syntax to reference environment values
3. Run `./build.sh` to regenerate all environments

## Shared Files

The following files are shared across all environments and are copied from `test/`:

- `01-variables.tf` - Variable definitions
- `02-locals.tf` - Local values
- `03-data.tf` - Data sources
- `10-resource-groups.tf` - Resource groups
- `20-networking.tf` - Networking resources
- `21-managed-identities.tf` - Managed identities
- `22-custom-roles.tf` - Custom role definitions
- `23-azuread-groups.tf` - Azure AD groups
- `24-application-registration.tf` - Application registrations
- `25-federated-identity-credentials.tf` - Federated credentials
- `99-outputs.tf` - Output definitions

These files are not templated because they contain the same logic for all environments, with only variable values differing.

