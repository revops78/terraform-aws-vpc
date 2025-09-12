module "backend_alb" {
  source = "terraform-aws-modules/alb/aws"
  internal = true

  name    = "${var.project}-${var.environment}-backend-alb"
  vpc_id  = local.vpc_id
  subnets = local.private_subnet_ids
  enable_deletion_protection = false
  create_security_group = false #in default it is true so we make it false and giving already created sg groups
  security_groups = [local.backend_alb_sg_id]
  
  
tags = merge(
  local.common_tags,
  {
    Name = "${var.project}-${var.environment}-backend-alb"
  }
)

}

# we used fixed response listener because we dont have target group
resource "aws_lb_listener" "backend_alb" {
  load_balancer_arn = module.backend_alb.arn #arn is amazon resourse name
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "<h1>Hello,i am from backend_alb"
      status_code  = "200"
    }
  }
   
}


resource "aws_route53_record" "backend_alb" {
  zone_id = var.zone_id
  name    = "*.backend-dev.${var.zone_name}"
  type    = "A"

  alias {
    name                   = module.backend_alb.dns_name # dns_name of backend module from git
    zone_id                = module.backend_alb.zone_id #zone id of bacend_alb module from git
    evaluate_target_health = true
  }
   
}
