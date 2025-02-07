#output "app_ip" {
  #value     = local.lb_ip
#  value      = nonsensitive(kubectl_manifest.app-service.manifest["status"]["loadBalancer"]["ingress"][0]["ip"])
#  sensitive  = true
#}


