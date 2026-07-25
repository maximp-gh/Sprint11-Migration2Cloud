terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "maximp-tf-state-bucket"
    region = "ru-central1"
    key    = "terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.

  }
}

provider "yandex" {
  # Параметры cloud_id, folder_id и token не указываются, так как
  # провайдер автоматически подхватит их из переменных окружения

  zone = "ru-central1-d"
}


# при использовании family возьмется latest образ в семействе
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_disk" "boot-disk" {
  name     = "boot-disk"
  type     = "network-hdd"
  zone     = "ru-central1-d"
  size     = 16
  #image_id = "fd806c8slu9j1pa87msc"
  image_id = data.yandex_compute_image.ubuntu.image_id
}

resource "yandex_compute_instance" "vm" {
  name = "vm-backend"
  platform_id = "standard-v2"

  resources {
    cores  = 2
    memory = 8
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  #Yandex uses labels. Other providers - tags.
  labels = {
    environment = "backend"
    name = "backend-vm"
  }

}

#Сеть
resource "yandex_vpc_network" "network-1" {
  name = "network-backend"
}

#Подсеть
resource "yandex_vpc_subnet" "subnet-1" {

  name           = "backend"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.13.0/24"]
}

  