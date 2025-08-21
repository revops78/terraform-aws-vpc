variable "project"{
    default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "frontend_sg_name" {
  default = "frontend"
}

variable "frontend_sg_description" {
  default = "created sg instance for frontend"
}

variable "sg_tags" {
  type=map(string)
  default = {}
  }


variable "bastion_sg_name" {
  default = "bastion"
}

variable "bastion_sg_description" {
  default = "created sg instance for bastion"
}