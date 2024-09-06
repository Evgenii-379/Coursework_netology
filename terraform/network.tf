#                      VPC
 
resource "yandex_vpc_network" "coursework" {
  name = "cours_project"
  description = "new network for the project"
}
 
resource "yandex_vpc_route_table" "inner-to-nat" {
  network_id = yandex_vpc_network.coursework.id
 
 
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.bastion.network_interface.0.ip_address
  }
}
 
#                      subnet
 
resource "yandex_vpc_network" "my_network" {
  name = "my_network"
}
 
resource "yandex_vpc_subnet" "subnet_web-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.coursework.id
  v4_cidr_blocks = ["10.0.1.0/24"]
  route_table_id = yandex_vpc_route_table.inner-to-nat.id
 
}
 
resource "yandex_vpc_subnet" "subnet_web-2" {
  name           = "subnet2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.coursework.id
  v4_cidr_blocks = ["10.0.2.0/24"]
  route_table_id = yandex_vpc_route_table.inner-to-nat.id
}
 
resource "yandex_vpc_subnet" "private" {
  name           = "internal-subnet"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.coursework.id
  v4_cidr_blocks = ["10.0.3.0/24"]
  route_table_id = yandex_vpc_route_table.inner-to-nat.id
}
 
resource "yandex_vpc_subnet" "public" {
  name           = "public-subnet"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.coursework.id
  v4_cidr_blocks = ["10.0.4.0/24"]
}
