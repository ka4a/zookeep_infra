resource "aws_instance" "web" {
  key_name                    = "ubuntu"
  count                       = var.ec2_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.security_groups]

  #provisioner "remote-exec" {
  #inline = [
  #  "sudo apt-get -y update",
  #  "sudo add-apt-repository ppa:ondrej/nginx -y",
  #  "sudo apt-get -y install nginx rabbitmq-server supervisor certbot python3-certbot-nginx python3.9 pipenv postgresql-client",
  #  "sudo service nginx start", 
  #  "sudo certbot --nginx -d staging.zookeep.com --non-interactive --agree-tos -m support@hccr.com",
  #  "sudo systemctl enable nginx rabbitmq-server supervisor",
  #  "sudo rabbitmqctl add_user staginguser XXXXXXXXXX && sudo rabbitmqctl add_vhost staging",
  #  "sudo rabbitmqctl set_permissions -p staging staginguser \".*\" \".*\" \".*\"",
  #  "sudo curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && sudo echo \"deb https://dl.yarnpkg.com/debian/ stable main\" | sudo tee /etc/apt/sources.list.d/yarn.list && sudo apt update && sudo apt install yarn -y",
  #  "sudo chown ubuntu:ubuntu -R /etc/supervisor && sudo chown -R ubuntu:ubuntu /etc/nginx/ && mkdir ~/configs",
    
  #]
  #  connection {
  #  user = "ubuntu"  
  #  host = self.public_ip
  #}
  #}

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.root_device_size
    volume_type           = var.root_device_type
  }

  tags = {
    "Name"       = "${var.environment}-instance"
    "Managed_by" = "terraform"
  }
}

resource "aws_eip" "lb" {
  instance = aws_instance.web[0].id
  vpc      = true

  tags = {
    "Name"       = "${var.environment}-instance"
    "Managed_by" = "terraform"
  }
}

resource "aws_cloudwatch_metric_alarm" "CPU" {
  alarm_name                = "CPU Highload"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "90"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
}

resource "aws_budgets_budget" "ec2" {
  name              = "budget-ec2-monthly"
  budget_type       = "COST"
  limit_amount      = "100"
  limit_unit        = "USD"
  time_period_end   = "2087-06-15_00:00"
  time_period_start = "2021-06-01_00:00"
  time_unit         = "MONTHLY"

  cost_filters = {
    Service = "Amazon Elastic Compute Cloud - Compute"
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = ["alert@reustle.co"]
  }
}
