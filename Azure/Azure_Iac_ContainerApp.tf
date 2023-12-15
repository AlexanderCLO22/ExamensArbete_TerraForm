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

resource "null_resource" "execute_script" {
  triggers = {
    conntainer_app_id = azurerm_container_app.ContainerApp.id
  }

  provisioner "local-exec" {
    command = "apply_ingress.sh"
    
  }
}