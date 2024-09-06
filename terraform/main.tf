terraform {
  required_version = "= 1.9.2"
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "= 0.73"
    }
  }
}
 
provider "yandex" {
  token     = "y0_AgAAAxxxxxxxxxxxxxx-xxx-xx-x-xxxxxxxxxxxxk9lgY"
  cloud_id  = "b1gt41qe1o37635d6cud"
  folder_id = "b1gvr82mdeak63g576i3"
  zone      = "ru-central1-a"
}
resource "yandex_compute_instance" "web-1" {
  name         = "vm-1"
  zone         = "ru-central1-a"
  platform_id  = "standard-v2"
  allow_stopping_for_update = true
 
 
resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }
 
  boot_disk {
    initialize_params {
      image_id = "fd8l04iucc4vsh00rkb1"    # Ubuntu-22.04
    }
  }
 
  network_interface {
    subnet_id =  yandex_vpc_subnet.subnet_web-1.id
    nat       = true
 
    security_group_ids = [yandex_vpc_security_group.internal.id]
    ip_address         = "10.0.1.29"
 
}
 
metadata = {
    user-data = "${file("./meta.yml")}"
 }
 
}
resource "yandex_compute_instance" "web-2" {
  name         = "vm-2"
  zone         = "ru-central1-b"
  platform_id  = "standard-v2"
  allow_stopping_for_update = true
 
  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }
 
  boot_disk {
    initialize_params {
      image_id = "fd8l04iucc4vsh00rkb1"                     # Ubuntu-22.04
    }
  }
  network_interface {
    subnet_id =  yandex_vpc_subnet.subnet_web-2.id
    nat       = true
 
  security_group_ids = [yandex_vpc_security_group.internal.id]
  ip_address         = "10.0.2.15"
 
}
 
  metadata = {
    user-data = "${file("./meta.yml")}"
  }
 
}
