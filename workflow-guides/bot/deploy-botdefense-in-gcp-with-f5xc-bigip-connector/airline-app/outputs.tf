output "app_ip" {
  #value     = local.lb_ip
  value     = kubectl_manifest.app-service
}