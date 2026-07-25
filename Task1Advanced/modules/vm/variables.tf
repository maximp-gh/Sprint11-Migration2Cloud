#Реализовать модуль vm_module (в папке modules/vm/) со следующими параметрами:
#Количество ядер;
#Объём RAM;
#Подключаемый диск;
#Subnet ID;
#SSH-ключ.

variable "yandex_zone" {
  type        = string
  description = "Yandex zone"
  default     = "ru-central1-d"
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
  default     = "dev"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "Environment must be dev, stage, or prod."
  }
}

variable "num_cores" {
  type = number
  validation {
    condition     = var.num_cores >= 2 && var.num_cores <= 16
    error_message = "Cores must be between 2 and 16."
  }
}

variable "memory_size" {
    type = number
}

variable "disk_size" {
  type = number
}

#https://yandex.cloud/ru/docs/terraform/data-sources/vpc_subnet
#variable "cidr_block" {
#  type = string
#  description = "subnet"
#  default = "192.168.10.0/24"
#}

variable "subnet_id" {
  type = string
  description = "Одна из создаваемых подсетей subnet_dev, subnet_prod, subnet_stage"
  validation {
    condition     = contains(["subnet_dev", "subnet_stage", "subnet_prod"], var.subnet_id)
    error_message = "subset_id must be subnet_dev, subnet_prod, subnet_stage."
  }
}

variable "ssh_key" {
  type = string
  #default = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
}