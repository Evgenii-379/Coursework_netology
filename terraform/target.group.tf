resource "yandex_alb_target_group" "target-group" {
  name     = "my-target-group"
 
  target {
    subnet_id = "e9bpt4uvnnr7ji9j2t6b"    #subnet 1
    ip_address = "10.0.1.29"
}
 
  target {
    subnet_id = "e2ldt0p3arsqhpcsivks"    #subnet 2   
    ip_address = "10.0.2.15"
 }
}
