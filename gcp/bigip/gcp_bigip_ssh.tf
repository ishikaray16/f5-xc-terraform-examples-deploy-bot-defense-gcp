resource "github_user_ssh_key" "ssh_key" {
  title = "Creating ssh_key file"
  key   = file(var.id_rsa.pub)
}