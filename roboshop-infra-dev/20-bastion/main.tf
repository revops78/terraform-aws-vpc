resource "aws_instance" "bastion" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.bastion_sg_id] #we make it string by adding braceses
  subnet_id = local.public_subnet_ids[0]

  tags = merge (
    var.bastion_tags,
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}" # interpolation should always be in "" N should be capital in name
    }   
  )
} 