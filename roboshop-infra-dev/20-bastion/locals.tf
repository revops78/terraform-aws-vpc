locals {
  ami_id = data.aws_ami.joindevops.id
  bastion_sg_id= data.aws_ssm_parameter.bastion_sg_id.value
  public_subnet_ids = split("," , data.aws_ssm_parameter.public_subnet_ids.value)
  #we use split function because ssm paramater was giving string list output ,but we need list 
  #here so use split function we get as list and we are taking first id by index 
}

locals {
    common_tags ={
        environment = var.environment
        project = var.project
        Terraform = "true"
}
}