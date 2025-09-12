module "vpc" {
    source = "../../terraform-aws-vpc"
    project=var.project
    environment = var.environment
    public_subnet_cidr =var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
    database_subnet_cidr=var.database_subnet_cidr
    is_pairing_required = true
    
}


