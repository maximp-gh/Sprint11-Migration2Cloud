#Используем локальный модуль
module "vm_module" {
  source      = "./modules/vm"
  environment = var.environment
  num_cores   = var.num_cores
  memory_size = var.memory_size
  disk_size   = var.disk_size
  subnet_id   = var.subnet_id
  #cidr_block  = var.cidr_block
  ssh_key = "ubuntu:${file("${var.ssh_key_path}")}"
}