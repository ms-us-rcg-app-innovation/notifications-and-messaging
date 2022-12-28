variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "app_name" {
  type = string
}

variable "host_sku" {
  type = string
  default = "Y1"
}

variable "app_settings" {
    type    = map(string)
    default = null
}

variable "sa_name" {
  type = string
}

variable "sa_key" {
  type = string
}



