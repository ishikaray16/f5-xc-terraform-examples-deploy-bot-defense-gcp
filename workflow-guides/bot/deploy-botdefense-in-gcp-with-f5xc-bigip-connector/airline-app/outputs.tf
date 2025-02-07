#output "app_ip" {
  #value     = local.lb_ip
#  value      = nonsensitive(kubectl_manifest.app-service)
#  sensitive  = true
#}

output "test" {
  value      = kubectl_manifest.app-service
}