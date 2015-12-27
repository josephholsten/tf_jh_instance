resource "template_file" "user-data" {
    count = "${var.instance_count}"
    template = "${file(\"${path.module}/files/user-data.yaml\")}"
    vars {
      environment = "${var.environment}"
      role = "${var.role}"
      hostname = "${var.role}-${count.index+1}.${var.zone}"
      chef_server_url = "https://api.opscode.com/organizations/${var.chef_org}"
      chef_validation_client_name = "${var.chef_validation_client_name}"
      chef_validation_key = "${var.chef_validation_key}"
    }
}

resource "digitalocean_droplet" "server-instance" {
  count     = "${var.instance_count}"
  name      = "${var.role}-${count.index+1}"

  image     = "ubuntu-14-04-x64"
  region    = "${var.dc_region}"
  size      = "${var.instance_flavor}"

  ssh_keys  = ["${split(",", var.ssh_keys)}"]
  user_data = "${element(template_file.user-data.*.rendered, count.index)}"

  private_networking = true
  ipv6               = true
  backups            = false
}

resource "nsone_record" "ns-record-a" {
  count  = "${var.instance_count}"
  zone   = "${var.zone}"
  domain = "${var.role}-${count.index+1}.${var.zone}"
  type   = "A"
  answers {
    answer = "${element(digitalocean_droplet.server-instance.*.ipv4_address, count.index)}"
  }
}

resource "nsone_record" "ns-record-aaaa" {
  count  = "${var.instance_count}"
  zone   = "${var.zone}"
  domain = "${var.role}-${count.index+1}.${var.zone}"
  type   = "AAAA"
  answers {
    answer = "${element(digitalocean_droplet.server-instance.*.ipv6_address, count.index)}"
  }
}
