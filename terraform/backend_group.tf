#Создание Backend Group:
 
 resource "yandex_alb_backend_group" "my_backend_group" {
  name = "my-backend-group"
 
  http_backend {
    name             = "http-backend"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_alb_target_group.target-group.id]
 
    load_balancing_config {
      panic_threshold = 90
    }
 
    healthcheck {
      timeout  = "10s"
      interval = "2s"
      healthy_treshold = 10
      unhealthy_threshold = 15
      http_healthcheck {
        path = "/"
     }
    }
  }
}
