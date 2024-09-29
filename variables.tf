variable "cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
    type = bool
    default = true
}
  
variable "common_tags"{
    type = map
    default = {}
}

variable "vpc_tags"{
    type = map
    default = {}
}

variable "project_name"{
    type        = string
}
variable "environment"{
    type        = string
}

variable "igw_tags"{
    type = map
    default = {}
}


variable "public_subnets_cidr" {
    type = list
    validation{
        condition = length(var.public_subnets_cidr) == 2
        error_message = "Please provide two valid subnet cidrs"
    }
}

variable "public_subnets_tags"{
    default = {}
}

variable "private_subnets_cidr" {
    type = list
    validation{
        condition = length(var.private_subnets_cidr) == 2
        error_message = "Please provide two valid subnet cidrs"
    }
}

variable "private_subnets_tags"{
    default = {}
}

variable "db_subnets_cidr" {
    type = list
    validation{
        condition = length(var.db_subnets_cidr) == 2
        error_message = "Please provide two valid subnet cidrs"
    }
}

variable "db_subnets_tags"{
    default = {}
}

variable "nat_gw_tags"{
    default = {}
}

variable "public_rt_tags"{
    default = {}
}

variable "private_rt_tags"{
    default = {}
}

variable "db_rt_tags"{
    default = {}
}

################################ 

variable "is_peering_required"{
    type = bool
    default = false
}

variable "acceptor_vpc_id" {
    type = string
    default = ""
}

variable "vpc_peering_tags"{
    default = {}
}