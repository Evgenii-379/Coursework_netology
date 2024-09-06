resource "yandex_alb_load_balancer" "my_alb" {
  name        = "my-alb"
  network_id  = yandex_vpc_network.coursework.id
  security_group_ids = [yandex_vpc_security_group.public-load-balancer.id, yandex_vpc_security_group.internal.id]
 
 
 
  allocation_policy {
    location {
      zone_id = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.public.id
    }
}
 
  listener {
    name = "http-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.my_router.id
      }
    }
  }
}
