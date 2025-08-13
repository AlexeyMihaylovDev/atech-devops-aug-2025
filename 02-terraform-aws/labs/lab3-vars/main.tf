# יצירת EC2 Instance
resource "aws_instance" "demo_ec2" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.demo_subnet.id
  vpc_security_group_ids      = [aws_security_group.demo_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              
              # יצירת דף web פשוט
              cat > /var/www/html/index.html << 'HTML'
              <!DOCTYPE html>
              <html>
              <head>
                  <title>שרת Terraform</title>
                  <meta charset="utf-8">
                  <style>
                      body { font-family: Arial, sans-serif; margin: 40px; background-color: #f0f0f0; }
                      .container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
                      h1 { color: #2c3e50; text-align: center; }
                      .info { background: #ecf0f1; padding: 20px; border-radius: 5px; margin: 20px 0; }
                      .success { color: #27ae60; font-weight: bold; }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <h1>🚀 ברוכים הבאים לשרת Terraform!</h1>
                      <div class="info">
                          <p><strong>Instance ID:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
                          <p><strong>Instance Type:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-type)</p>
                          <p><strong>Availability Zone:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
                          <p><strong>Region:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/region)</p>
                      </div>
                      <p class="success">✅ השרת פועל בהצלחה!</p>
                      <p>שרת זה הוקם אוטומטית באמצעות Terraform עם:</p>
                      <ul>
                          <li>VPC מותאם אישית</li>
                          <li>Subnet ציבורי</li>
                          <li>Security Group עם כללי אבטחה</li>
                          <li>Apache Web Server</li>
                      </ul>
                  </div>
              </body>
              </html>
              HTML
              
              # הגדרת timezone לישראל
              timedatectl set-timezone Asia/Jerusalem
              
              # הוספת הודעת הצלחה ל-logs
              echo "✅ שרת web הותקן והופעל בהצלחה!" >> /var/log/user-data.log
              echo "🌐 דף הבית זמין ב: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)" >> /var/log/user-data.log
              EOF

  tags = {
    Name = "demo-ec2"
  }
}

# יצירת EBS Volume
resource "aws_ebs_volume" "demo_volume" {
  availability_zone = aws_subnet.demo_subnet.availability_zone
  size              = 20
  type              = "gp3"
  encrypted         = true

  tags = {
    Name = "demo-volume"
  }
}

# חיבור EBS Volume ל-EC2 Instance
resource "aws_volume_attachment" "demo_attachment" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.demo_volume.id
  instance_id = aws_instance.demo_ec2.id
}

# יצירת Elastic IP
resource "aws_eip" "demo_eip" {
  instance = aws_instance.demo_ec2.id
  domain   = "vpc"

  tags = {
    Name = "demo-eip"
  }
}
