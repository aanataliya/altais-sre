variable "cidr" {
  type = string
}

variable "public_subnets" {
  type = list
}

variable "private_subnets" {
  type = list
}

variable "region" {
  type = string
}

variable "azs" {
  type = list
}

variable "apache-ami" {
  type = string
}

# variable "cidr_blocks" {
#   type = list
# }
