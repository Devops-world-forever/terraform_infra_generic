terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.50.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = "f63f9a72-32ba-4cf2-acf0-446dad259c1b"
}
provider "random" {}
