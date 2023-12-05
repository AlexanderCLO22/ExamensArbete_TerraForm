provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "MyRG" {
  name     = "my-resource-group"
  location = "North Europe"
}
#Create Azure Container Enviroment
resource "azurerm_container_app_environment" "ContainerAppEnvironment"{
  name = "MyContainerAppEnviroment"
  resource_group_name = azurerm_resource_group.MyRG.name
  location            = azurerm_resource_group.MyRG.location
}
# Create an Azure Container App
resource "azurerm_container_app" "ContainerApp" {
  name                = "my-container-app"
  resource_group_name = azurerm_resource_group.MyRG.name
  container_app_environment_id = azurerm_container_app_environment.ContainerAppEnvironment.id
  revision_mode = "Single"

  ingress {
    target_port = 5000
    external_enabled = true
    allow_insecure_connections = true
    traffic_weight {
      percentage = 100
    }
  }
  
  template {
    container {
      name = "my-container"
      image = "aleoje/thesnakegame:latest"
      cpu    = "1.0"
      memory = "2Gi"
      env {
        name = "MONGODB_CONNECTION_STRING"
        value = "mongodb+srv://AleOje:sIS81pn7svhDCnUm@examensarbete.jv5yrm5.mongodb.net/"
      }
    }
  }
  
}