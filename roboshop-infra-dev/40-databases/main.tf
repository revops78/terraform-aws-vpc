resource "aws_instance" "mongodb" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.mongodb_sg_id] #we make it string by adding braceses
  subnet_id = local.database_subnet_ids[0]
  
  tags = merge (
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-mongodb" # interpolation should always be in "" N should be capital in name
    }   
  )
} 


resource "terraform_data" "mongodb" {
  # Replacement of any instance of the cluster requires re-provisioning
  triggers_replace = [
    aws_instance.mongodb.id
    
    ]

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.mongodb.private_ip
  }

   # Copies the myapp.conf file to /etc/myapp.conf
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb ${var.environment}"
    ]
  }
  
}

resource "aws_instance" "redis" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.redis_sg_id] #we make it string by adding braceses
  subnet_id = local.database_subnet_ids[0]
  
  tags = merge (
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-redis" # interpolation should always be in "" N should be capital in name
    }   
  )
} 


resource "terraform_data" "redis" {
  depends_on = [aws_instance.redis]
  # Replacement of any instance of the cluster requires re-provisioning
  triggers_replace = [
    aws_instance.redis.id
    
    ]

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.redis.private_ip
  }

   # Copies the myapp.conf file to /etc/myapp.conf
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh redis ${var.environment}"
    ]
  }
  
}
resource "aws_instance" "mysql" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.mysql_sg_id] #we make it string by adding braceses
  subnet_id = local.database_subnet_ids[0]
  iam_instance_profile = "EC2RoleToFetchSSMParameters" #we used this attach a role of ec2
  
  tags = merge (
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-mysql" # interpolation should always be in "" N should be capital in name
    }   
  )
} 


resource "terraform_data" "mysql" {
  depends_on = [aws_instance.mysql]
  # Replacement of any instance of the cluster requires re-provisioning
  triggers_replace = [
    aws_instance.mysql.id
    
    ]

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.mysql.private_ip
  }

   # Copies the myapp.conf file to /etc/myapp.conf
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mysql ${var.environment}"
    ]
  }
  
}

resource "aws_instance" "rabbitmq" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.rabbitmq_sg_id] #we make it string by adding braceses
  subnet_id = local.database_subnet_ids[0]
  
  tags = merge (
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-rabbitmq" # interpolation should always be in "" N should be capital in name
    }   
  )
} 


resource "terraform_data" "rabbitmq" {
  depends_on = [aws_instance.rabbitmq]
  # Replacement of any instance of the cluster requires re-provisioning
  triggers_replace = [
    aws_instance.rabbitmq.id
    
    ]

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.rabbitmq.private_ip
  }

   # Copies the myapp.conf file to /etc/myapp.conf
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh rabbitmq ${var.environment}"
    ]
  }
  
}


resource "aws_route53_record" "mongodb" {
  zone_id = var.zone_id
  name    = "mongodb-${var.environment}.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "redis" {
  zone_id = var.zone_id
  name    = "redis-${var.environment}.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.redis.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "mysql" {
  zone_id = var.zone_id
  name    = "mysql-${var.environment}.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mysql.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "rabbitmq" {
  zone_id = var.zone_id
  name    = "rabbitmq-${var.environment}.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.rabbitmq.private_ip]
  allow_overwrite = true
}