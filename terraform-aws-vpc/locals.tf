locals {
    common_tags ={
        environment = var.environment
        project = var.project
        Terraform = "true"
    }
az_names=slice(data.aws_availability_zones.available.names,0,2)# i got error here today because i keep "" for the slice,it is a list for the list we cant keep like that 
    
}