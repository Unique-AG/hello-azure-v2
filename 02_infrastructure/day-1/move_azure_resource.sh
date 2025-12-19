#!/bin/bash
set -euo pipefail

# move the resource to the new location
OLD_STATE_PATH="tf-main.tfstate"
NEW_STATE_PATH="new.tfstate"

# move the resource to the new location
terraform state mv -state=${OLD_STATE_PATH} -state-out=${NEW_STATE_PATH} \
    module.vnet.random_uuid.telemetry \
    module.vnet.random_uuid.telemetry
terraform state mv -state=${OLD_STATE_PATH} -state-out=${NEW_STATE_PATH} \
    module.vnet.modtm_telemetry.telemetry \
    module.vnet.modtm_telemetry.telemetry
    
terraform state mv -state=${OLD_STATE_PATH} -state-out=${NEW_STATE_PATH} \
    module.identities.azurerm_user_assigned_identity.aks_workload_identity \
    azurerm_user_assigned_identity.aks_workload_identity
terraform state mv -state=${OLD_STATE_PATH} -state-out=${NEW_STATE_PATH} \
    module.identities.azurerm_user_assigned_identity.document_intelligence_identity \
    azurerm_user_assigned_identity.document_intelligence_identity
terraform state mv -state=${OLD_STATE_PATH} -state-out=${NEW_STATE_PATH} \
    module.identities.azurerm_user_assigned_identity.grafana_identity \
    azurerm_user_assigned_identity.grafana_identity
terraform state mv -state=${OLD_STATE_PATH} -state-out=${NEW_STATE_PATH} \
    module.identities.azurerm_user_assigned_identity.ingestion_cache_identity \
    azurerm_user_assigned_identity.ingestion_cache_identity
terraform state mv -state=${OLD_STATE_PATH} -state-out=${NEW_STATE_PATH} \
    module.identities.azurerm_user_assigned_identity.ingestion_storage_identity \
    azurerm_user_assigned_identity.ingestion_storage_identity
terraform state mv -state=${OLD_STATE_PATH} -state-out=${NEW_STATE_PATH} \
    module.identities.azurerm_user_assigned_identity.psql_identity \
    azurerm_user_assigned_identity.psql_identity

# it might be applicable to move vnet (including subnets) resources as well but this has to be verified