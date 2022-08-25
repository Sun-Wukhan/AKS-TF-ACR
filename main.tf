terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "bondbrandloyalty"
    workspaces {
      prefix = "juan-"
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.55"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "aks" {
  name     = "AKS-TF"
  location = "Canada Central"
  lifecycle {
    prevent_destroy = false
  }
}