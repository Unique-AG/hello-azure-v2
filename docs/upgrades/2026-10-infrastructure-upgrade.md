# Infrastructure upgrade guide: Terraform modules and providers (October 2026)

**Scope of this guide:** the complete module and provider upgrade merged with PRs
[#103](https://github.com/Unique-AG/hello-azure-v2/pull/103) to
[#112](https://github.com/Unique-AG/hello-azure-v2/pull/112) (see the "PRs covered" table at the end). It
moves every Terraform root from the azurerm 4.x provider to azurerm 5.x and every `terraform-modules` pin to
its latest release, in two steps that were applied separately on Unique's test environment but land together
in one release:

- **Step A** (modules to their last azurerm 4 release, provider unchanged): #103, #104, #105, #112, #106, #107.
- **Step B** (azurerm `~> 5.5` and the azurerm 5 module releases): #108, #109, #111, #110.

It applies when you move from release `2026.40.5` or earlier to the first release that contains them. You
apply both steps in one pass per root; the expected plans below are the combined ones.

## Who this is for

Operators who run a self-hosted setup based on this repository and take over the Terraform changes of a
release in one go. The upgrade touches all Terraform roots: `01_bootstrap/day-0`, `02_infrastructure/day-1`,
`02_infrastructure/day-3` and `02_infrastructure/day-2`.

This is a **migration guide for existing environments** that were created with the previous module versions.
A new deployment does not need it: follow the regular READMEs in `01_bootstrap` and `02_infrastructure` in
the usual order (day-0, day-1, day-2, day-3). The one-off state command in this guide (`terraform state rm`
in step 4) only exists because two resources change owner between modules and state files; on a fresh
deployment they are created in the right place from the start.

**Downtime:** none of the steps in this guide interrupts the platform or its users. Every change is an
in-place update of a control-plane setting, a state-only operation, or an idempotent write of values that
are already live. The one exception with a visible effect is the Argo CD client-secret rotation in step 4:
it interrupts new Argo CD SSO logins for a few minutes, and only if your Argo CD authenticates against this
app registration. Workloads are never affected. The per-step "Impact" lines say what each apply does.

## Why "pull, plan, apply" is not enough

Three things make this release different from a routine one:

1. **The roots depend on each other and the order matters.** day-2 and day-3 read day-1 resources through
   data sources, and the first day-1 apply interferes with the Bastion network security group (NSG) that day-3
   manages. day-1 and day-3 have to be applied back to back.
2. **Module major versions and the provider major version moved.** Several Unique modules and the AVM
   virtual network module jumped major versions, and the azurerm provider goes from 4.x to 5.x in every
   root. The code in this repository was adjusted so that the running infrastructure keeps its behaviour,
   but that only holds if your copy uses the same inputs. Where your fork deviates, the plan will tell you,
   so every plan has to be read before it is applied.
3. **Each root has a known-good plan.** Unique applied every change on its test environment and recorded the
   plan. Your plan should match it, apart from the documented differences. Anything else is a stop.

## Before you start

- **Terraform 1.12.2** (see `.terraform-version`). day-1 and day-2 require `>= 1.12`.
- **Azure CLI** logged in with the identity you normally use for Terraform. The day-0 backend configuration
  has no `subscription_id`, so select the subscription first:
  `az account set --subscription <your subscription>`.
- **Back up every state file before you touch it.** From each root, after `terraform init`:
  `terraform state pull > <folder outside the repository>/<root>-before-upgrade.tfstate`.
  The state storage account should also have blob versioning enabled, which gives you a second copy.
- **Provider lock files are not committed** in this repository (`.terraform.lock.hcl` is ignored), so
  `terraform init` resolves the newest provider versions allowed by the constraints. Every root's azurerm
  constraint moves to `~> 5.5`, so **run `terraform init -upgrade` in every root**; a plain `init` refuses the
  new constraint when a 4.x lock file is present. Unique's runs resolved `azurerm 5.11.0` and `azapi 2.13.0`
  (the PRs were measured on 5.10.0 with identical plans). Note the versions your `init` picks.
- **azurerm 5 behaviour kept from 4.x:** every root sets `resource_provider_registrations = "legacy"`, so
  the provider keeps registering the same resource providers as before (azurerm 5 defaults to `none`). azurerm
  5 also disables location validation at plan time by default; an invalid `location` would surface at apply.
  All locations in this upgrade already exist, so it has no effect here.
- **Never plan with `-refresh=false`.** Several checks in this guide rely on the refresh.
- **Check out the release**, do not work from an arbitrary commit:
  `git fetch --tags && git checkout <release tag>`.
- Replace `<env>` in the commands below with your environment folder (`test` in this repository).

**Stop means:** do not apply. Save the plan output (`terraform plan -no-color > plan.txt`) and share it with
Unique before you continue. Applying a plan that differs from the expected one can replace resources.

## Order of operations

| Step | Root | Why in this position |
|---|---|---|
| 1 | `01_bootstrap/day-0` | Holds the Terraform state storage account. Must plan `No changes`. |
| 2 | `02_infrastructure/day-1` | Network and Log Analytics. The first apply with the new vnet module detaches the Bastion NSG. Takes over the two Log Analytics tables from day-2. |
| 3 | `02_infrastructure/day-3` | Re-attaches the Bastion NSG. Run directly after step 2. |
| 4 | `02_infrastructure/day-2` | Platform. Reads day-1 resources. Drops the two Log Analytics tables from its state before plan. |

## Step 1: day-0 (Terraform state storage)

**What changed** ([#104](https://github.com/Unique-AG/hello-azure-v2/pull/104),
[#108](https://github.com/Unique-AG/hello-azure-v2/pull/108)): the `azure-storage-account` module moves from
5.1.0 to 8.0.1 and the azurerm constraint from `~> 4.21` to `~> 5.5`. 8.0.1 maps the module's unchanged
`public_network_access_enabled` input to azurerm 5's renamed `public_network_access` attribute. The provider
block gets `resource_provider_registrations = "legacy"`.

```bash
az account set --subscription <your subscription>
cd 01_bootstrap/day-0
terraform init -upgrade -backend-config=../environments/<env>/backend-config-day-0.hcl
terraform state pull > <backup folder>/day-0-before-upgrade.tfstate
terraform plan \
  -var-file=../environments/<env>/00-config-day-0.auto.tfvars \
  -var-file=../environments/<env>/00-parameters-day-0.auto.tfvars
```

**Expected plan:** `No changes. Your infrastructure matches the configuration.` A "changes made outside of
Terraform" block above it from azurerm 5's state upgrade (for example the storage container's `id` moving to
its ARM form) is a refresh, not an action.

**Stop on any change at all.** This is the state storage account. There is nothing to apply in this step.

**Impact:** none. Nothing is applied.

**If your fork differs:** the module's breaking changes in 6.0.0 and 7.0.0 concern the inputs
`customer_managed_key` (now takes `key_vault_key_id`) and `private_endpoint` (replaced by the
`private_endpoints` map). The reference `module "tfstate_sa"` uses neither. If your copy does, migrate those
inputs before planning; the module changelog in `terraform-modules` describes the replacement.

## Step 2: day-1 (network and Log Analytics)

**What changed, network** ([#103](https://github.com/Unique-AG/hello-azure-v2/pull/103)):

- AVM module `Azure/avm-res-network-virtualnetwork` moves from `v0.7.1` to `0.22.3`. The module input
  `resource_group_name` became `parent_id`, and the subnet key `delegation` became `delegations`. Both are
  already adjusted in `02_infrastructure/day-1/02-locals.tf` and `20-networking.tf`.
- The `azapi` provider constraint moves from `2.2.0` to `~> 2.12`.
- `snet-psql` now declares the `Microsoft.Storage` service endpoint. In Unique's environment the endpoint
  already existed on the subnet and every day-1 apply used to remove it.
- `AzureBastionSubnet` gets `ignore_body_changes = ["properties.networkSecurityGroup"]`, so future day-1
  applies leave the NSG that day-3 attaches alone. This setting only takes effect **after** the first apply.
- `resource_provider_registrations = "legacy"` on the azurerm provider.

**What changed, Log Analytics** ([#112](https://github.com/Unique-AG/hello-azure-v2/pull/112)):

- The workspace resource `azurerm_log_analytics_workspace.this` in `38-log-analytics.tf` is replaced by the
  module `azure-log-analytics-workspace` 1.2.1 (`module "log_analytics"`). A `moved` block in the same file
  renames the workspace in state; nothing is recreated.
- The module also manages the two Basic-plan tables `ContainerLogV2` and `AKSControlPlane`. Until now the
  AKS module in day-2 managed them; `azure-kubernetes-service` 7.0.0 and later no longer does (see step 4).
  The resource type `azurerm_log_analytics_workspace_table` does not create tables, it only sets `plan` and
  retention on tables Azure provides, so the apply writes the values that are already live (Basic, 30 days).
  Do not try `terraform import` for these two resources: the azurerm 4.x provider cannot import this type
  (its read requires `workspace_id` in state, which import does not set). Letting the apply "create" them is
  the intended path.
- New variable `log_analytics_local_authentication_enabled`, default `true`. The module default is `false`;
  the variable defaults to the value existing workspaces were created with so the migration changes nothing.
- The module's workspace-transform data collection rule is disabled (`data_collection_rule = { enabled = false }`).
  Nothing sends App Gateway logs to this workspace, so there is nothing for it to transform.

**What changed, azurerm 5** ([#109](https://github.com/Unique-AG/hello-azure-v2/pull/109)):

- azurerm constraint `~> 4.39` to `~> 5.5`. The vnet module is azapi-only; `azure-log-analytics-workspace`
  moves to 2.0.0 and `azure-defender` from 2.5.0 to 3.0.1, both constraint-only releases for azurerm 5.
- The two private DNS zone VNet links in `37-dns.tf` use `private_dns_zone_id` instead of
  `private_dns_zone_name` + `resource_group_name`, which azurerm 5 removed. The speech link now references the
  zone resource instead of a zone name from a variable; it is the same zone. azurerm 5 fills
  `private_dns_zone_id` from the existing link IDs during refresh, so this is a no-op.

```bash
cd 02_infrastructure/day-1
terraform init -upgrade -backend-config=../environments/<env>/backend-config-day-1.hcl
terraform state pull > <backup folder>/day-1-before-upgrade.tfstate
terraform plan \
  -var-file=../environments/<env>/00-config-day-1.auto.tfvars \
  -var-file=../environments/<env>/00-parameters-day-1.auto.tfvars
```

**Expected plan (Unique test environment, 10 subnets):** `Plan: 4 to add, 12 to change, 0 to destroy.`
The change count scales with your number of subnets: one change per subnet, plus the virtual network, plus
one telemetry resource. The four adds are fixed: two telemetry objects and the two Log Analytics tables.

Unique applied the parts separately on test (network: `2 to add, 12 to change`; Log Analytics:
`2 to add, 0 to change`; azurerm 5: `No changes`). In one run they add up to the counts above.

- `azurerm_log_analytics_workspace.this has moved to module.log_analytics.azurerm_log_analytics_workspace.this`:
  the workspace shows only this move line and `(16 unchanged attributes hidden)`. No attribute change.
- `+ module.log_analytics.azurerm_log_analytics_workspace_table.basic_log_table["AKSControlPlane"]` and
  `+ ...["ContainerLogV2"]`, each with exactly `plan = "Basic"` and `total_retention_in_days = 30` and the
  `workspace_id` of your workspace.
- Each subnet is annotated `(moved from module.vnet.module.subnet["<key>"].azapi_resource.subnet)`. This is a
  state move inside the module, not a replacement.
- `~` the virtual network and every subnet: only `type` (API version `2023-11-01` to `2024-07-01`), new
  `retry` and `timeouts` blocks and `response_export_values`; the subnets additionally get
  `ignore_missing_property` (`true` to `false`) and `list_unique_id_property`. `output` becomes "known after
  apply". The `body` of the subnets is unchanged, with one exception:
- `~ snet-psql` body: `serviceEndpoints` keeps `service = "Microsoft.Storage"` and drops the read-only
  `locations` and `provisioningState` fields from the request.
- `~ module.vnet.modtm_telemetry.telemetry[0]`: the `module_version` tag moves to `0.22.3`.
- `+ module.vnet.module.interfaces.modtm_telemetry.telemetry[0]` and `+ ...random_uuid.telemetry[0]`:
  AVM telemetry objects. They create nothing in Azure.

**Refresh noise you can ignore.** Above the plan, under "changes made outside of Terraform", the virtual
network and subnets show `output` differences: the subnet list may appear in a different order (two subnets
seem to swap address prefixes), `ipConfigurations` entries appear or disappear, and
`ignore_null_property = false` is added. These are read-only attributes, not actions. Check the real
addresses in the action list for each subnet resource.

**Differences you may see in your environment:**

- If the `Microsoft.Storage` endpoint does not exist on your PostgreSQL subnet yet, the plan shows
  `serviceEndpoints = null -> [{ service = "Microsoft.Storage" }]` on `snet-psql`. The apply then adds that
  endpoint. Either accept it or remove the `service_endpoints` line from `snet-psql` in your copy.
- If you removed optional subnets (for example the GitHub runner or Bastion subnet), the counts are lower.
- If the workspace shows `local_authentication_enabled: false -> true`, someone disabled workspace-key
  authentication in the portal. Do not apply that; set `log_analytics_local_authentication_enabled = false`
  in your day-1 tfvars instead and re-plan.
- If your day-2 passed a custom `retention_in_days` or `basic_log_tables` to the AKS module, the two table
  resources must show those values. Adjust `basic_log_tables` in `38-log-analytics.tf` until the planned
  `plan` and `total_retention_in_days` match what is live; a different value would change the tables.

**Stop if** the plan shows any `-/+` or "forces replacement", or any body change to `addressPrefix(es)`,
`delegations`, `networkSecurityGroup`, `routeTable`, `natGateway`, `defaultOutboundAccess` or the network
policy fields of any subnet. The only allowed body change is the `snet-psql` service endpoint described above.
Also stop if the workspace shows any attribute change, or if a table shows a `plan` or retention other than
what is live today. Stop if either `azurerm_private_dns_zone_virtual_network_link` shows `-/+`: a replaced
link interrupts private name resolution for PostgreSQL and Speech inside the VNet while it is recreated. The
fallback is `terraform state rm` plus `terraform import` of that link, which changes nothing in Azure.

**Impact:** none. Subnets are updated in place with unchanged prefixes, delegations and policies; existing
NICs and traffic are unaffected. The table writes carry the live values. The only window is the Bastion NSG
between this apply and step 3: the subnet runs without its NSG for a few minutes, Bastion itself keeps working.

**Apply**, then continue with step 3 right away:

```bash
terraform apply \
  -var-file=../environments/<env>/00-config-day-1.auto.tfvars \
  -var-file=../environments/<env>/00-parameters-day-1.auto.tfvars
```

**Why step 3 must follow immediately.** The subnet update sends the full subnet body to Azure without a
network security group reference. If day-3 has attached the Bastion NSG, this first apply detaches it, and
the plan does not necessarily show that, because the old module never tracked the property. The
`ignore_body_changes` setting introduced here prevents this from the second apply onwards.

## Step 3: day-3 (Bastion), directly after step 2

Skip this step only if you do not run day-3 at all. The step restores the NSG association and proves that
day-1 now ignores it; it also carries day-3's own provider move.

**What changed** ([#111](https://github.com/Unique-AG/hello-azure-v2/pull/111)): azurerm constraint `~> 4.20`
to `~> 5.5` and `resource_provider_registrations = "legacy"`. No resource change; the Bastion host, public IP,
NSG, association and diagnostic setting are unaffected by azurerm 5's removals (the diagnostic setting
already uses the `enabled_log`/`enabled_metric` form). The same PR moves `02_infrastructure/gh-test`
(the GitHub runner networking root) to azurerm `~> 5.5`; if you use that root, run `init -upgrade` and plan
it the same way with `00-config-gh.auto.tfvars` and `00-parameters-gh.auto.tfvars`, expected `No changes`.

```bash
cd 02_infrastructure/day-3
terraform init -upgrade -backend-config=../environments/<env>/backend-config-day-3.hcl
terraform state pull > <backup folder>/day-3-before-upgrade.tfstate
terraform plan \
  -var-file=../environments/<env>/00-config-day-3.auto.tfvars \
  -var-file=../environments/<env>/00-parameters-day-3.auto.tfvars
```

**Expected plan:** `Plan: 1 to add, 0 to change, 0 to destroy.`, where the one resource is
`azurerm_subnet_network_security_group_association.bastion`. If the plan says `No changes`, the NSG was still
attached; that is fine too. The provider move itself adds nothing (Unique's day-3 plan on azurerm 5 was
`No changes`).

**Stop on** any destroy or replace, in particular of the Bastion host, its public IP or the NSG itself.

**Impact:** none. Attaching the NSG restores the filtering that step 2 removed; Bastion sessions continue.

Apply, then verify:

```bash
terraform apply \
  -var-file=../environments/<env>/00-config-day-3.auto.tfvars \
  -var-file=../environments/<env>/00-parameters-day-3.auto.tfvars

# 1. The NSG is attached again.
az network vnet subnet show -g <vnet resource group> --vnet-name <vnet name> -n AzureBastionSubnet \
  --query networkSecurityGroup.id -o tsv

# 2. day-1 no longer wants to detach it.
cd ../day-1
terraform plan \
  -var-file=../environments/<env>/00-config-day-1.auto.tfvars \
  -var-file=../environments/<env>/00-parameters-day-1.auto.tfvars
```

The second day-1 plan must say `No changes`. If it shows the Bastion subnet again, stop.

## Step 4: day-2 (platform)

**What changed** ([#105](https://github.com/Unique-AG/hello-azure-v2/pull/105),
[#106](https://github.com/Unique-AG/hello-azure-v2/pull/106),
[#107](https://github.com/Unique-AG/hello-azure-v2/pull/107) and
[#110](https://github.com/Unique-AG/hello-azure-v2/pull/110)). The "via" column is the last azurerm 4 release
each module passed through in Step A; the "To" column is what the release ships:

| Module | From | via (Step A) | To (Step B) |
|---|---|---|---|
| `azure-storage-account` (`ingestion_cache`, `ingestion_storage`, `audit_storage`) | 5.1.0 | 7.1.1 | 8.0.1 |
| `azure-postgresql` | 3.4.0 | 3.5.0 | 4.1.0 |
| `azure-application-gateway` | 6.0.0 | 6.7.0 | 8.1.0 |
| `azure-kubernetes-service` | 5.7.1 | 8.0.0 | 9.2.0 |
| `azure-entra-app-registration` (GitOps / Argo CD app) | 4.0.0 | `azure-entra-app-registration-argocd` 1.0.0 | `azure-entra-app-registration-argocd` 2.2.0 |
| `azure-redis` | 2.1.0 | unchanged | 3.0.0 |
| `azure-openai` | 3.5.0 | unchanged | 4.0.0 |
| `azure-document-intelligence` | 3.4.0 | unchanged | 4.0.0 |
| `azure-speech-service` | 4.3.0 | unchanged | 5.0.0 |

- azurerm constraint `~> 4.39` to `~> 5.5`, plus `resource_provider_registrations = "legacy"`. The unused
  `modtm` provider requirement is removed (no module in day-2 uses it and the state holds no `modtm` resource).
- `azurerm_federated_identity_credential.afic_workloads`: `parent_id` became `user_assigned_identity_id`
  and `resource_group_name` was dropped (both removed in azurerm 5). Same identity, new argument names.
- Storage 7.1.1 makes `data_protection_settings.change_feed_enabled` take effect. 5.1.0 ignored it. 8.0.1 maps
  the unchanged `public_network_access_enabled` input to azurerm 5's renamed attribute.
- Redis 3.0.0, OpenAI 4.0.0, Document Intelligence 4.0.0, Speech 5.0.0 and PostgreSQL 4.0.0 are provider
  constraint bumps only. PostgreSQL 4.1.0 adds an optional `private_endpoint` input that day-2 does not set.
- AKS 8.0.0, with the inputs in `22-kubernetes.tf` set so the running cluster keeps its behaviour:
  - `default_node_pool` object replaces `kubernetes_default_node_size` / `_zones`; `vm_size` and `zones`
    come from the same variables, min 2 / max 5 are the old defaults. Without `vm_size` the pool would fall
    back to `Standard_D2s_v5` and be rebuilt.
  - `data_plane_logs = { enabled = true }` keeps Container Insights on (7.0.0 turns it off by default, which
    would destroy its data collection rule).
  - `control_plane_logs.categories` lists the seven diagnostic categories the old version sent (the new
    default is one).
  - The module no longer manages the two Log Analytics tables; day-1 does since step 2. They have to be
    removed from day-2 state **before the plan** (below). Otherwise Terraform plans to destroy them, and for
    this resource type "destroy" means resetting the tables' retention to the workspace default.
  - The autoscaler default `scale_down_delay_after_delete` moved from `10s` to `120s` (module default since 6.2).
- AKS 9.2.0 on top of that: `node_provisioning_profile { mode = "Manual" }` is now always sent (the live
  default, no change), and the configured control-plane log categories are validated against the categories
  Azure reports for the cluster. That validation is a plan-time precondition; an unsupported category fails
  the plan with the supported list in the message. Grafana's new default major version does not apply, since
  day-2 passes `grafana_major_version` explicitly.
- App Gateway 8.0.0 removed the module's default 5xx metric alert. `20-application-gateway.tf` re-declares it
  under the same key with the same values, so the existing alert is kept unchanged. 8.1.0 adds WAF defaults:
  `/public/chat/openai-proxy` joins the exempted URIs (request bodies above the WAF's 2000 KB ceiling pass on
  that path), the chat-field exclusion widens from rule 944250 to the whole CRS 944 group, plus 944 on
  `messages.*` argument names and 944110 on the `User-Agent` header.
- The GitOps app registration in `11-application-registration.tf` moves to the successor module
  `azure-entra-app-registration-argocd` (1.0.0 in Step A, 2.2.0 in Step B); the generic module was deleted
  from `terraform-modules`. All resource addresses are identical, so nothing is moved. `admin_consent_enabled
  = false` (the old module granted nothing either, and the Terraform identity cannot create consent grants).
  The `explicit_*` names keep the Key Vault secret names Argo CD reads and the password display name prefix.
- **Client secret rotation (argocd module 2.2.0).** The single client secret is replaced by two overlapping
  secrets named `<display name>-YYYYMMDD` for the current and the previous rotation epoch, and the module
  rotates them: on the first apply after each epoch boundary it creates the next one, drops the oldest and
  points the Key Vault secret at the current one. Epochs are 365-day periods counted from 1970-01-01, so the
  boundary falls on **18 December** each year (2025-12-18, 2026-12-18, ...). The dated names in your plan
  therefore depend on the day you apply, and the Key Vault secret gets an `expiration_date` two years after
  the current epoch start. Consumers of the secret (Argo CD SSO via the Key Vault secret) must pick up the new
  value after every rotation; on this reference setup the CSI driver does that within minutes.

```bash
cd 02_infrastructure/day-2
terraform init -upgrade -backend-config=../environments/<env>/backend-config-day-2.hcl
terraform state pull > <backup folder>/day-2-before-upgrade.tfstate

# One-off: hand the two Basic-plan tables over to day-1 (state only, nothing happens in Azure).
terraform state rm \
  'module.kubernetes_cluster.azurerm_log_analytics_workspace_table.basic_log_table["AKSControlPlane"]' \
  'module.kubernetes_cluster.azurerm_log_analytics_workspace_table.basic_log_table["ContainerLogV2"]'

terraform plan \
  -var-file=../environments/<env>/00-config-day-2.auto.tfvars \
  -var-file=../environments/<env>/00-parameters-day-2.auto.tfvars \
  -var-file=../environments/<env>/prometheus-rules.auto.tfvars
```

The `state rm` must print `Successfully removed 2 resource instance(s).` If it reports that an address does
not exist, run `terraform state list | grep basic_log_table` to find the actual addresses; your day-2 may
have passed different table names to the AKS module.

**Expected plan:** `Plan: 4 to add, 4 to change, 1 to destroy.`

Unique applied the four parts separately on test (#105: `2 to add, 1 to change`; #106: `0 to add, 1 to
change`; #107: `0 to add, 1 to change`; #110: `2 to add, 2 to change, 1 to destroy`). In one run they add up
to the counts above; the WAF policy counts once although two PRs change it.

- `+ module.postgresql.azurerm_postgresql_flexible_server_configuration.parameters["metrics.collector_database_activity"]`
  with value `ON`.
- `+ module.postgresql.azurerm_postgresql_flexible_server_configuration.parameters["pgms_wait_sampling.query_capture_mode"]`
  with value `ALL`. Both parameters are dynamic; the server does not restart.
- `~ module.application_gateway.azurerm_web_application_firewall_policy.wafpolicy[0]`, in place:
  `/html-store/` and `/public/chat/openai-proxy` are added to the `FurtherCheckingExemptedURIs` custom rule,
  and the managed-rule exclusion list grows: OWASP 930 and the whole 944 group on the chat input fields, 944
  on `messages.*` argument names, 944110 on the `User-Agent` header, 931100 on `redirect_uri` and
  `redirect_uris`, 941130 on `crawlerConfig.contentTypes.xhtml`. Terraform diffs this list positionally, so
  existing exclusions appear "modified" into new ones and re-added further down as `+ exclusion` blocks. Read
  the final list, not the diff lines: the `__Host-uniqueid.useragent` cookie exclusions (941, 942) must still
  be present. The policy mode is not in the diff.
- `- module.application_registration.azuread_application_password.aad_app_password[0]`: the single old
  client secret. **This is the only destroy in the whole upgrade.**
- `+ ...aad_app_password["<previous epoch>"]` and `+ ...aad_app_password["<current epoch>"]`: the two
  rotating secrets, named `unique-enterprise-gitops-app-key-YYYYMMDD`. Applied between 2025-12-18 and
  2026-12-17 the keys are `20241218` and `20251218`; after that `20251218` and `20261218`, and so on.
- `~ ...azurerm_key_vault_secret.aad_app_gitops_client_secret[0]`: new value (the current epoch's secret)
  and a new `expiration_date` (2027-12-18 for the `20251218` epoch).
- `~ module.kubernetes_cluster.azurerm_kubernetes_cluster.cluster`, in place, with exactly one attribute:
  `auto_scaler_profile.scale_down_delay_after_delete: "10s" -> "120s"`. Everything else on the cluster reads
  `unchanged`. The apply takes two to three minutes while AKS reconciles the control plane.
- `~ module.application_registration.azuread_application.this`, in place: `web.implicit_grant`
  `access_token_issuance_enabled` and `id_token_issuance_enabled` go `true -> false`, and the
  `optional_claims.saml2_token` block (`groups`) is removed. Argo CD uses the authorization-code flow with
  the client secret, so neither was in use.

**Refresh noise you can ignore:** `module.kubernetes_cluster.azurerm_kubernetes_cluster.cluster` may show a
newer `kubernetes_version` / `orchestrator_version` under "changes made outside of Terraform" if AKS
auto-upgraded, and azurerm 5 adds `oms_agent.retina_flow_logs_enabled = false` there on first read. Neither
is in the action list. Warnings about undeclared variables from `prometheus-rules.auto.tfvars` are harmless.

**Must not appear in the action list:** the three storage accounts and their customer-managed key resources,
Key Vault keys or secrets, `azurerm_federated_identity_credential.afic_workloads[...]`, the PostgreSQL server,
the application gateway, public IPs. On the AKS side: the `default_node_pool` block, the node pools `rapid` and
`steady`, `oms_agent`, `azurerm_monitor_data_collection_rule.ci_dcr[0]` and its association,
`azurerm_monitor_diagnostic_setting.aks_diagnostic_logs[0]`, `kubernetes_version`. The two
`basic_log_table` resources must not appear at all; if they show as destroyed, the `state rm` above did not
run. On the app registration side: `azurerm_key_vault_secret.aad_app_gitops_client_id[0]`,
`azuread_service_principal.this`, the app roles and role assignments; the client-secret Key Vault entry may
only be updated in place, never replaced; and nothing named `delegated_permission_grant`, `external_apis`,
`time_sleep` or `aad_app_password_expiry` may be created. Also absent: Redis, the OpenAI, Document
Intelligence and Speech accounts and deployments, the 5xx metric alert.

**Differences you may see in your environment:**

- `change_feed_enabled`: if any of your `*_data_protection_settings` sets `change_feed_enabled = false`
  while `change_feed_retention_days > 0`, the apply now really disables the change feed, which 5.1.0 silently
  kept on. The plan shows `blob_properties.change_feed_enabled: true -> false` on that storage account.
  Decide whether that is what you want before applying. The reference values (`false` with retention `0`,
  or `-1` on the audit account) produce no change.
- If your fork sets `private_endpoint` or `customer_managed_key` on a storage module call, migrate those
  inputs first (see step 1). The reference uses `self_cmk`, whose interface did not change.
- If you override `parameter_values` on the PostgreSQL module, the two new parameters do not appear.
- If your WAF policy runs in `Prevention` mode, the new exclusions and the exempted URI take effect on live
  traffic immediately. They only relax the rules; nothing becomes stricter.
- If your day-2 overrides the AKS default node pool size or zones through the old variables
  `kubernetes_default_node_size` / `kubernetes_default_node_zones`, those values now feed the
  `default_node_pool` object in `22-kubernetes.tf`. Confirm the plan does not touch `default_node_pool`.
- If your day-2 passed `diagnostic_logs_categories`, `container_insights_streams` or `retention_in_days` to
  the AKS module, those inputs no longer exist. Map them to `control_plane_logs.categories`,
  `data_plane_logs.streams`, and the day-1 `basic_log_tables` respectively before planning.

- If your fork does not run Argo CD SSO against this app registration, the `azuread_application.this`
  change and the secret rotation are still expected (they are the module's new behaviour); they just have no
  consumer. If your fork removed the `application_registration` module entirely, those lines are absent and
  the counts are lower (`2 to add, 3 to change, 0 to destroy`).
- If your PostgreSQL server was created with a storage type other than `Premium_LRS`, check that azurerm 5's
  new `storage_type` attribute on `azurerm_postgresql_flexible_server` does not plan a replacement. On the
  reference environment it reads the live value and plans nothing.
- If your fork removed the `metric_alerts` re-declaration from the App Gateway module call, the plan destroys
  `azurerm_monitor_metric_alert.application_gateway_metric_alerts["default_5xx_error_alert"]`. Decide
  whether you want that alert before applying.

**Stop if** `afic_workloads` shows `-/+` (that would interrupt workload identity for the cluster), if any
storage account, key or secret other than the Argo CD client secret changes, if the PostgreSQL server, Redis,
a cognitive account or deployment, or the application gateway appears in the action list, or if the AKS
cluster shows anything beyond the single autoscaler attribute. A change to `default_node_pool`, a node pool,
`oms_agent` or the Container Insights resources is a stop. Any destroy other than `aad_app_password[0]` is a
stop, and so is any `-/+`. A precondition error about unsupported control-plane log categories is a stop.

**Impact:** no workload impact. The PostgreSQL parameters are dynamic (no restart). The WAF policy is updated
in place; in Detection mode the new exclusions only change what is logged. The autoscaler delay is a
control-plane setting; no node is drained or replaced. The `state rm` touches state only. **Argo CD SSO only:**
the old client secret is deleted during the apply, so new Argo CD SSO logins fail until Argo CD has picked up
the new Key Vault value; on the reference setup the CSI driver re-syncs within about two minutes and
`argocd-server` reloads it. Existing sessions keep working. If your Argo CD does not use this app
registration for login, nothing is affected.

**Apply** and re-plan:

```bash
terraform apply \
  -var-file=../environments/<env>/00-config-day-2.auto.tfvars \
  -var-file=../environments/<env>/00-parameters-day-2.auto.tfvars \
  -var-file=../environments/<env>/prometheus-rules.auto.tfvars
```

Expected: `Apply complete! Resources: 4 added, 4 changed, 1 destroyed.` A second plan must say `No changes`
(apart from the refresh noise described above).

If Argo CD SSO uses this app registration: about three minutes after the apply, sign in to Argo CD with SSO.
If it still fails after five minutes, restart the pod that syncs the Key Vault secret (the Argo CD "keeper"),
then `kubectl -n <argocd namespace> rollout restart deploy/argocd-server`. Then smoke-test chat.

Afterwards, confirm that container logs still arrive. In the Log Analytics workspace, Logs blade:

```kusto
ContainerLogV2 | where TimeGenerated > ago(10m) | count
```

A count above zero means the Container Insights pipeline survived the module change.

## If a plan does not match

- Do not apply. Save the plan with `-no-color` and share it with Unique.
- Do not "fix" a mismatch by checking out the previous release and applying. After the day-1 apply, the
  subnets live under new state addresses and a new API version; going back is not a plain revert.
- The state backups from "Before you start" and the blob versions on the state storage account are the
  rollback path for state. The only Azure resource this guide destroys is the old Argo CD client secret in
  step 4, and the module creates its replacements in the same apply.
- A state file written by azurerm 5 cannot be read by azurerm 4 without restoring the backup. Once a root
  has been planned or applied on azurerm 5, going back to the previous release also means restoring that
  root's state backup.
- If the day-2 `state rm` was run but the plan then had to be stopped for another reason, the two tables are
  recorded in day-1 state only (after step 2) and in Azure. That is the target state; nothing to undo.

## PRs covered

| PR | Root | Merged | Applied on Unique test | Covered in |
|---|---|---|---|---|
| [#103](https://github.com/Unique-AG/hello-azure-v2/pull/103) AVM vnet 0.22.3 | day-1 (+ day-3 re-apply) | 2026-10-20 | yes | steps 2 and 3 |
| [#104](https://github.com/Unique-AG/hello-azure-v2/pull/104) azure-storage-account 7.1.1 | day-0 | 2026-10-20 | plan `No changes` | step 1 |
| [#105](https://github.com/Unique-AG/hello-azure-v2/pull/105) storage 7.1.1, PostgreSQL 3.5.0, App Gateway 6.7.0 | day-2 | 2026-10-20 | yes | step 4 |
| [#112](https://github.com/Unique-AG/hello-azure-v2/pull/112) azure-log-analytics-workspace 1.2.1 | day-1 | 2026-10-27 | yes | step 2 |
| [#106](https://github.com/Unique-AG/hello-azure-v2/pull/106) azure-kubernetes-service 8.0.0 | day-2 | 2026-10-27 | yes | step 4 |
| [#107](https://github.com/Unique-AG/hello-azure-v2/pull/107) azure-entra-app-registration-argocd 1.0.0 | day-2 | 2026-10-27 | yes | step 4 |
| [#108](https://github.com/Unique-AG/hello-azure-v2/pull/108) azurerm 5, azure-storage-account 8.0.1 | day-0 | 2026-10-27 | plan `No changes` | step 1 |
| [#109](https://github.com/Unique-AG/hello-azure-v2/pull/109) azurerm 5, azure-defender 3.0.1, azure-log-analytics-workspace 2.0.0, DNS link arguments | day-1 | 2026-10-27 | plan `No changes` | step 2 |
| [#111](https://github.com/Unique-AG/hello-azure-v2/pull/111) azurerm 5 | day-3, gh-test | 2026-10-27 | plan `No changes` | step 3 |
| [#110](https://github.com/Unique-AG/hello-azure-v2/pull/110) azurerm 5 and latest module releases, Argo CD secret rotation | day-2 | 2026-10-27 | yes | step 4 |
