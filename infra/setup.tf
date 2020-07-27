
variable "hcloud_token" {}
variable "ssh_keys" {}

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
  ssh_keys = var.ssh_keys

  provisioner "local-exec" {
    command = "echo ${hcloud_server.locus-n1.ipv4_address}"
  }
}

resource "null_resource" "setup_k3s" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "cd ansible && ansible-playbook playbooks/k3s.yml -u root -i ${hcloud_server.locus-n1.ipv4_address}, -v && cd ../cert-manager && sh install_cert_manager.sh && kubectl apply -f issuer.yaml" # TODO add sleep 60 in the end just for safety
  }
}

resource "null_resource" "install_drone" {
  depends_on = [null_resource.setup_k3s]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "cd drone && kubectl apply -f secret.yaml && kubectl apply -f drone-master && kubectl apply -f drone-runner && kubectl apply -f ingress.yaml"
  }
}

