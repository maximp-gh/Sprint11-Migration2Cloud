variable "environment" {
  type        = string
  description = "Deployment environment name"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "Environment must be dev, stage, or prod."
  }
}

variable "num_cores" {
  type = number
}

variable "memory_size" {
  type = number
}

variable "disk_size" {
  type = number
}

variable "cidr_block" {
  type        = string
  description = "subnet"
  default     = "192.168.10.0/24"
}

variable "ssh_key_path" {
  type = string
  #default = "~/.ssh/id_rsa.pub"
}

variable "subnet_id" {
  type = string
}