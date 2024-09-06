# Создание HTTP Router
 
resource "yandex_alb_http_router" "my_router" {
  name = "my-http-router"
}
 
# Создание Virtual Host for the HTTP Router
 
resource "yandex_alb_virtual_host" "my_virtual_host" {
  name           = "my-virtual-host"
  http_router_id = yandex_alb_http_router.my_router.id
 
  route {
    name = "my-route"
    http_route {
      http_match {
        path {
          prefix = "/"
        }
      }
 
     http_route_action {
        backend_group_id = yandex_alb_backend_group.my_backend_group.id
      }
    }
  }
}
