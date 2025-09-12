locals {
  ami_id = data.aws_ami.joindevops.id
  mongodb_sg_id= data.aws_ssm_parameter.mongodb_sg_id.value
  redis_sg_id= data.aws_ssm_parameter.redis_sg_id.value
  mysql_sg_id= data.aws_ssm_parameter.mysql_sg_id.value
  rabbitmq_sg_id= data.aws_ssm_parameter.rabbitmq_sg_id.value
  database_subnet_ids = split("," , data.aws_ssm_parameter.database_subnet_ids.value)
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