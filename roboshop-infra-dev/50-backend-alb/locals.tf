locals {
  vpc_id= data.aws_ssm_parameter.vpc_id.value
  private_subnet_ids = split("," , data.aws_ssm_parameter.private_subnet_ids.value)
  backend_alb_sg_id = data.aws_ssm_parameter.backend_alb_sg_id.value
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