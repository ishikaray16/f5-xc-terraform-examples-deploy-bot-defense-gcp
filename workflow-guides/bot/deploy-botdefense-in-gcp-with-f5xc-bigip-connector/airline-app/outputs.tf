output "app_ip" {
  #value     = local.lb_ip
  value      = nonsensitive(kubectl_manifest.app-service)
}