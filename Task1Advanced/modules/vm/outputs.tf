output "internal_ip_address_vm" {
  value = yandex_compute_instance.vm.network_interface.0.ip_address
}

output "external_ip_address_vm" {
  value = yandex_compute_instance.vm.network_interface.0.nat_ip_address
}

output "vm_subnet_id" {
  value = yandex_compute_instance.vm.network_interface.0.subnet_id
}

output "vm_tag" {
  value = yandex_compute_instance.vm.labels.name
}

output "my_image_id" {
  value = data.yandex_compute_image.ubuntu.id
}