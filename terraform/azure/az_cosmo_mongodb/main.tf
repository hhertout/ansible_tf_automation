resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = "France Central"
}

resource "azurerm_cosmosdb_account" "mongodb" {
  name                       = var.cosmodb_db_name
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  kind                       = "MongoDB"
  offer_type                 = "Standard"
  free_tier_enabled          = true
  analytical_storage_enabled = false
  mongo_server_version       = "7.0"

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level = "Strong"
  }

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_mongo_database" "root" {
  name                = "root"
  resource_group_name = azurerm_cosmosdb_account.mongodb.resource_group_name
  account_name        = azurerm_cosmosdb_account.mongodb.name
}

resource "azurerm_cosmosdb_mongo_collection" "example_collection" {
  name                = "my-collection"
  resource_group_name = azurerm_cosmosdb_account.mongodb.resource_group_name
  account_name        = azurerm_cosmosdb_account.mongodb.name
  database_name       = azurerm_cosmosdb_mongo_database.root.name

  default_ttl_seconds = "777"
  shard_key           = "uniqueKey"

  index {
    keys   = ["_id"]
    unique = true
  }
}
