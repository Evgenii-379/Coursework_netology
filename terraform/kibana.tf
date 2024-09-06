resource "yandex_compute_instance" "kibana_vm" {
  name        = "kibana-server"
  zone        = "ru-central1-b"
  allow_stopping_for_update = true
  platform_id = "standard-v2"
 
  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
 
  }
 
  boot_disk {
    initialize_params {
      image_id = "fd8l04iucc4vsh00rkb1"  # ID образа, ubuntu 22.04
    }
  }
 
  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat = true
 
#  security_group_ids = [yandex_vpc_security_group.internal.id, yandex_vpc_security_group.public-kibana.id]
#  ip_address         = "10.0.4.16"
 
  }
 
  metadata = {
    user-data = "${file("./meta.yml")}"
 
  }
}
