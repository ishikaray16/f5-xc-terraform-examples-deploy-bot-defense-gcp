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
  address                  = 10.0.0.51
#  address                 = local.app_ip
#  connection_limit        = "0"
#  dynamic_ratio           = "1"
#  monitor                 = "/Common/icmp"
  description             = "Terraform-Node"
#  rate_limit              = "disabled"
#  fqdn {
#    address_family        = "ipv4"
#    interval              = "3000"
#  }
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


# Creating the XC Bot Defense Profile on BIG-IP:
#
#resource "bigip_as3" "as3-example1" {
#  as3_json    = file("as3.json")
#}

#resource "bigip_ltm_bot_defense" "monitor" {
#  name                    = "/Common/terraform_monitor_bd"
#  parent                  = "/Common/https_443"
#}
#
#resource "bigip_ltm_bot_defense_pool" "protection_pool" {
#  name                    = "ibd-webus.fastcache.net"
#}
#
#resource "bigip_ltm__bot_defense_node" "node" {
#  name                    = "/Common/terraform_node_bd"
#  address                 = bigip_ltm_bot_defense_pool.protection_pool.name
#  connection_limit        = "0"
#  dynamic_ratio           = "1"
#  monitor                 = "/Common/icmp"
#  description             = "Terraform-Node-Bot-Defense"
#  rate_limit              = "disabled"
#  service_port            = "/https"
#  fqdn {
#    address_family        = "ipv4"
#    interval              = "3000"
#  }
#}
#
#resource "bigip_ltm_bot_defense_profile” “test_bot_defense” {
#  name                    = "/Common/test-bot-defense"
#  application_id          = “509df7c18c58484f82157ded358a8010”
#  tenant_id               = "treino-ufahspac"
#  api_key                 = "MkkKBKF3lvoiIGlUr-N-Szll4d5PhAYJTFEoF5kdrj0"
#  telemetry_header_prefix = "Xa4vrhYP3Q-"
#  shape_protection_pool   = ""   # didnt find this option under profile in demo-guide
#  ssl_profile             = ""   # didnt find this option under profile in demo-guide
#  js_uri                  = "/customer.js"
#  protected_endpoints {
#    name                  = “pend”
#    host                  = “abc.com”
#    path                  = "/user/signin"
#    endpoint_label        = "/login"
#    post                  = "enabled"
#    put                   = "enabled"
#    mitigation_action     = "/block"
#  }
#  configuration {
#    name                  = bigip_ltm_bot_defense_pool.protection_pool.name
#    monitors              = bigip_ltm_bot_defense.monitor.parent
#  }
#  advanced_features {
#    name                  = bigip_ltm_bot_defense_pool.protection_pool.name
#    ssl_profile           = "/serverssl"
#    cors_support          = "enabled"
#  }
#}

# Binding the XC Bot Profile to the Virtual Sever