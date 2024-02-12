variable "region" {
  type        = string
   default = "ap-south-1"
}

variable "key_name" {
  type        = string
  default = "demo"
}

variable "instance_type" {
  type        = string
  default = "t2.micro"
}


variable "subnet_id" {
  type        = string
  default =   "subnet-035ef63e88e49bd80"
}

variable "vpc_id" {
  type        = string
  default = "vpc-0048122967d683320"
}

variable "security_group_id" {
  type        = string
  default = "sg-0a06fb89e3730bd7d"
}
