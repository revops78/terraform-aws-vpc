variable "project"{
    default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "bastion_tags" {
type = map(string)

  default = {}
}
variable "zone_id" {
  default = "Z01675523V0BXK5MIKKGB"
}

variable "zone_name" {
  default = "chinni.fun"
}