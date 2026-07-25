terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  # Параметры cloud_id, folder_id и token не указываются, так как
  # провайдер автоматически подхватит их из переменных окружения

  zone = "ru-central1-d"
}

#https://yandex.cloud/ru/docs/terraform/
#######################################
# Команда для получения images:
# yc compute image list --folder-id standard-images

# при использовании family возьмется latest образ в семействе
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_disk" "boot-disk" {
  name     = "boot-disk-${var.environment}"
  type     = "network-hdd"
  zone     = "ru-central1-d"
  size     = var.disk_size
  #image_id = "fd806c8slu9j1pa87msc"
  image_id = data.yandex_compute_image.ubuntu.image_id
}

resource "yandex_compute_instance" "vm" {
  name = "vm-${var.environment}"

  platform_id = "standard-v2"


  resources {
    cores  = var.num_cores
    memory = var.memory_size
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1[var.subnet_id].id
    nat       = true
  }

  metadata = {
    #ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    ssh-keys = var.ssh_key
  }
  
  #Yandex uses labels. Other providers - tags.
  labels = {
    environment = var.environment
    name = "${var.environment}-vm"
  }

}

#Сеть
resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

#Подсеть
resource "yandex_vpc_subnet" "subnet-1" {

  for_each = tomap ({
    "subnet_dev"="192.168.10.0/24"
    "subnet_prod"="192.168.11.0/24"
    "subnet_stage"="192.168.12.0/24"})
  
  name           = "${each.key}"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.network-1.id
  #v4_cidr_blocks = [var.cidr_block]
  v4_cidr_blocks = [each.value]
  

}

  