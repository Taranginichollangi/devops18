resource "aws_launch_template" "web_server_as" {
    name = "myproject"
    image_id           = "ami-06cfeaaa22092f09d"
    vpc_security_group_ids = [aws_security_group.web_server.id]
    instance_type = "t3.micro"
    key_name = "march-kp"
    tags = {
        Name = "DevOps"
    }
    
}
   


  resource "aws_elb" "web_server_lb"{
     name = "web-server-lb"
     security_groups = [aws_security_group.web_server.id]
     subnets = ["subnet-0228996547d984551", "subnet-099f8c0298eb0dc40"]
     listener {
      instance_port     = 8000
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
    }
    tags = {
      Name = "terraform-elb"
    }
  }
resource "aws_autoscaling_group" "web_server_asg" {
    name                 = "web-server-asg"
    min_size             = 1
    max_size             = 3
    desired_capacity     = 2
    health_check_type    = "EC2"
    load_balancers       = [aws_elb.web_server_lb.name]
    availability_zones    = ["eu-north-1a", "eu-north-1b"] 
    launch_template {
        id      = aws_launch_template.web_server_as.id
        version = "$Latest"
      }
    
    
  }

