#output "app_ip" {
  #value     = local.lb_ip
#  value      = nonsensitive(kubectl_manifest.app-service.manifest["status"]["loadBalancer"]["ingress"][0]["ip"])
#  sensitive  = true
#}

output "app_ip" {
  value = data.kubernetes_manifest.lb_service_status.manifest["status"]["loadBalancer"]["ingress"][0]["ip"]
}
