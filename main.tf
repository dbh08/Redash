provider "scaleway" {
  region = "${var.region}"
  organization = "${var.organization}"
  token        = "${var.scw_token}"
}

data "scaleway_image" "terraformdaoud" {
  architecture = "x86_64"
  name         = "Ubuntu Bionic"
}

resource "scaleway_server" "terraformdaoud" {
  name  = "terraformdaoud"
  image = "${data.scaleway_image.terraformdaoud.id}"
  type  = "START1-S"
}
resource "scaleway_ip" "ip" {
  server = "${scaleway_server.daoud.id}"
}


resource "scaleway_volume" "terraformdaoud" {
  name       = "terraformdaoudvolume"
  size_in_gb = 50
  type       = "l_ssd"
}

resource "scaleway_security_group" "http" {
  name        = "http"
  description = "allow HTTP and HTTPS traffic"
}

resource "scaleway_security_group_rule" "http_accept" {
  security_group = "${scaleway_security_group.http.id}"

  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 80
}

resource "scaleway_security_group_rule" "https_accept" {
  security_group = "${scaleway_security_group.http.id}"

  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 443
}