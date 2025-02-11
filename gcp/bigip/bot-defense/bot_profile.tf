# CREATING NODE, POOL & VIRTUAL SERVER FOR BACKEND APPLICATION

provider "bigip" {
    address               = local.bigip_ip
    username              = "admin"
    password              = local.bigip_password
    port                  = "8443"
}

resource "bigip_ltm_monitor" "monitor" {
  name                    = "/Common/terraform_monitor1"
  parent                  = "/Common/tcp"
}

resource "bigip_ltm_node" "node" {
  name                    = "/Common/terraform_node1"
  address                 = local.app_ip
  monitor                 = "none"
  description             = "Terraform-Node"
}

resource "bigip_ltm_pool" "pool" {
  name                      = "/Common/terraform_Pool1"
  load_balancing_mode       = "round-robin"
  minimum_active_members    = 1
  monitors                  = [bigip_ltm_monitor.monitor.parent]
}

resource "bigip_ltm_pool_attachment" "attach_node" {
  pool                      = bigip_ltm_pool.pool.name
  node                      = "${bigip_ltm_node.node.name}:80"
}

resource "bigip_ltm_virtual_server" "http" {
  name                       = "/Common/terraform_vs"
  destination                = local.bigip_private
  description                = "VS-terraform"
  port                       = 80
  pool                       = bigip_ltm_pool.pool.name
  profiles                   = ["/Common/tcp", "/Common/http"]
  source_address_translation = "automap"
  translate_address          = "enabled"
  translate_port             = "enabled"
}


# CREATING XC BOT DFEENSE PROFILE ON BIGIP

resource "bigip_as3" "as3-example1" {
  as3_json    = file("as3.json")
}

resource "bigip_xc_bot_defense_monitor" "monitor" {
  name                    = "/Common/terraform_monitor_bd"
  parent                  = "/Common/https_443"
}

resource "bigip_xc_bot_defense_node" "node" {
  name                    = var.bot_pool_name
  address                 = var.bot_pool_name
  monitor                 = "none"
  description             = "Terraform-Node-Bot-Defense"
}

resource "bigip_xc_bot_protection_pool" "protection_pool" {
  name                      = "/Common/terraform_protection_pool"
  load_balancing_mode       = "round-robin"
  minimum_active_members    = 1
  monitors                  = [bigip_xc_bot_defense_monitor.monitor.parent]
}

resource "bigip_xc_bot_defense_profile” “bot_profile” {
  name                    = "/Common/test_xc_bot_defense"
  application_id          = var.application_id
  tenant_id               = var.tenant_id
  api_key                 = var.api_key
  api_hostname            = var.bot_pool_name
  telemetry_header_prefix = var.telemetry_header_prefix
  ssl_profile             = "serverssl"
  protected_endpoints {
    name                  = “p_endpoint”
    host                  = “abc.com”
    path                  = "/user/signin"
    endpoint_label        = "/login"
    post                  = "enabled"
    put                   = "enabled"
    mitigation_action     = "block"
  }
}

resource "bigip_xc_bot_protection_pool_attachment" "attach_node" {
  pool                      = bigip_xc_bot_protection_pool.protection_pool.name
  node                      = "${bigip_xc_bot_defense_node.node.name}:443"
}

# BINDING THE XC BOT PROFILE TO VIRTUAL SERVER

resource "bigip_xc_bot_defense_virtual_server" "https" {
  name                       = "/Common/terraform_bd"
  destination                = local.bigip_private
  description                = "VS-terraform-xc-bot"
  port                       = 443
  bot_defense                = "enabled"
  pool                       = bigip_xc_bot_protection_pool.protection_pool.name
  profiles                   = [bigip_xc_bot_defense_profile.bot_profile]
  source_address_translation = "automap"
  translate_address          = "enabled"
  translate_port             = "enabled"
}
