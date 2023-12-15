#!/bin/bash

# Assuming you have the necessary variables set
resource_group="ExamensArbeteRG"
app_name="exarb-container-app"
target_port=5000

# Configure ingress using Azure CLI
az containerapp ingress enable --name "$app_name" --resource-group "$resource_group" --target-port "$target_port" --type external --allow-insecure true --transport auto
