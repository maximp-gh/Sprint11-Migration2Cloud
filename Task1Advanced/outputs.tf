output "internal_ip_address_vm" {
  value = module.vm_module.internal_ip_address_vm
}

output "external_ip_address_vm" {
  value = module.vm_module.external_ip_address_vm
}

output "vm_subnet_id" {
  value = module.vm_module.vm_subnet_id
}

output "vm_tag" {
  value = module.vm_module.vm_tag
}

output "my_image_id" {
  value = module.vm_module.my_image_id
}