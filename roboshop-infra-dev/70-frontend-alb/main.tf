module "frontend_alb" {
  source = "terraform-aws-modules/alb/aws" #real time of problem i have today is i copied the backend alb module
                                             #and change name to frontend but when i apply i my backend was deleting
                                            #the issue was i didnt use terraform reconfigure for the file so it is using same state file
  internal = false

  name    = "${var.project}-${var.environment}-frontend-alb"
  vpc_id  = local.vpc_id
  subnets = local.public_subnet_ids
  enable_deletion_protection = false
  create_security_group = false #in default it is true so we make it false and giving already created sg groups
  security_groups = [local.frontend_alb_sg_id]
  
  
tags = merge(
  local.common_tags,
  {
    Name = "${var.project}-${var.environment}-frontend-alb"
  }
)

}

# we used fixed response listener because we dont have target group
resource "aws_lb_listener" "frontend_alb" {
  load_balancer_arn = module.frontend_alb.arn #arn is amazon resourse name
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = local.acm_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "<h1>Hello,i am from frontend_alb using https"
      status_code  = "200"
    }
  }
   
}


resource "aws_route53_record" "frontend_alb" {
  zone_id = var.zone_id
  name    = "*.${var.zone_name}"
  type    = "A"

  alias {
    name                   = module.frontend_alb.dns_name # dns_name of frontend module from git
    zone_id                = module.frontend_alb.zone_id #zone id of frontend_alb module from git
    evaluate_target_health = true
  }
}
