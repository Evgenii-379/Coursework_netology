resource "yandex_compute_instance" "zabbix_vm" {
  name        = "zabbix-server"
  zone        = "ru-central1-b"
  allow_stopping_for_update = true
  platform_id = "standard-v2"
 
  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
 
  }
 
  boot_disk {
    initialize_params {
      image_id = "fd8lk4dibrqmhmn8rbc4"  # ID образа, Debian 11
    }
  }
 
  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat = true
 
  security_group_ids = [yandex_vpc_security_group.internal.id, yandex_vpc_security_group.public-zabbix.id]
  ip_address         = "10.0.4.6"
 
  }
 
  metadata = {
    user-data = "${file("./meta.yml")}"
    
  }
}
