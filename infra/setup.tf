
variable "hcloud_token" {}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

# # Create a server
resource "hcloud_server" "locus-n1" {
  name = "locus-n1"
  location = "hel1"
  image = "ubuntu-20.04"
  server_type = "cpx11"
  ssh_keys = ["Predator"]
}

