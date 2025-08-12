# AWS Configuration
aws_region = "us-east-1"

# Project Configuration
project_name = "production-webapp"
environment  = "production"

# Instance Configuration
instance_type = "t3.medium"
ami_id        = "ami-0c02fb55956c7d316" # Amazon Linux 2

# Network Configuration
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidr   = "10.0.1.0/24"
private_subnet_cidr  = "10.0.2.0/24"
availability_zone    = "us-east-1a"

# Security Configuration - Production Security
allowed_ssh_cidr  = ["10.0.0.0/8", "192.168.1.0/24"]  # Ограниченный доступ
allowed_http_cidr = ["0.0.0.0/0"]

# Storage Configuration
root_volume_size = 50
root_volume_type = "gp3"
encrypt_volumes  = true

# Production Features
enable_alb                  = true
enable_deletion_protection  = true
enable_s3_backup           = true
log_retention_days         = 30

# User Data - Production Web Server Setup
user_data = <<-EOF
            #!/bin/bash
            # Production Web Server Setup
            
            # Update system
            yum update -y
            
            # Install required packages
            yum install -y httpd php php-mysqlnd mysql
            
            # Configure Apache
            systemctl start httpd
            systemctl enable httpd
            
            # Create production web page
            cat > /var/www/html/index.php << 'PHP'
            <?php
            $instance_id = file_get_contents('http://169.254.169.254/latest/meta-data/instance-id');
            $az = file_get_contents('http://169.254.169.254/latest/meta-data/placement/availability-zone');
            $private_ip = file_get_contents('http://169.254.169.254/latest/meta-data/local-ipv4');
            $launch_time = date('Y-m-d H:i:s');
            ?>
            <!DOCTYPE html>
            <html>
            <head>
                <title>Production WebApp - Terraform</title>
                <style>
                    body { 
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
                        margin: 0; 
                        padding: 0; 
                        background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
                        color: white;
                        min-height: 100vh;
                    }
                    .container { 
                        max-width: 1200px; 
                        margin: 0 auto; 
                        padding: 20px; 
                    }
                    .header { 
                        text-align: center; 
                        margin-bottom: 40px; 
                        padding: 20px;
                        background: rgba(255,255,255,0.1);
                        border-radius: 15px;
                        backdrop-filter: blur(10px);
                    }
                    h1 { 
                        font-size: 3.5em; 
                        margin: 0; 
                        text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
                        background: linear-gradient(45deg, #ff6b6b, #4ecdc4);
                        -webkit-background-clip: text;
                        -webkit-text-fill-color: transparent;
                        background-clip: text;
                    }
                    .status-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                        gap: 20px;
                        margin-bottom: 30px;
                    }
                    .status-card {
                        background: rgba(255,255,255,0.1);
                        padding: 25px;
                        border-radius: 15px;
                        backdrop-filter: blur(10px);
                        border: 1px solid rgba(255,255,255,0.2);
                    }
                    .status-card h3 {
                        margin-top: 0;
                        color: #4ecdc4;
                        font-size: 1.5em;
                    }
                    .info-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                        gap: 15px;
                    }
                    .info-item {
                        background: rgba(255,255,255,0.05);
                        padding: 15px;
                        border-radius: 10px;
                        text-align: center;
                    }
                    .info-item strong {
                        color: #ff6b6b;
                        display: block;
                        margin-bottom: 5px;
                    }
                    .production-badge {
                        background: linear-gradient(45deg, #ff6b6b, #ee5a24);
                        color: white;
                        padding: 8px 16px;
                        border-radius: 20px;
                        font-size: 0.9em;
                        font-weight: bold;
                        display: inline-block;
                        margin-bottom: 20px;
                    }
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="header">
                        <div class="production-badge">🚀 PRODUCTION ENVIRONMENT</div>
                        <h1>Production WebApp</h1>
                        <p>Enterprise-grade infrastructure deployed with Terraform</p>
                    </div>
                    
                    <div class="status-grid">
                        <div class="status-card">
                            <h3>✅ System Status</h3>
                            <p><strong>Instance ID:</strong> <?php echo $instance_id; ?></p>
                            <p><strong>Availability Zone:</strong> <?php echo $az; ?></p>
                            <p><strong>Private IP:</strong> <?php echo $private_ip; ?></p>
                            <p><strong>Launch Time:</strong> <?php echo $launch_time; ?></p>
                        </div>
                        
                        <div class="status-card">
                            <h3>🛡️ Security Features</h3>
                            <ul style="list-style: none; padding: 0;">
                                <li>✓ Private Subnet Deployment</li>
                                <li>✓ NAT Gateway Access</li>
                                <li>✓ Encrypted EBS Volumes</li>
                                <li>✓ Restricted SSH Access</li>
                                <li>✓ Security Groups</li>
                            </ul>
                        </div>
                        
                        <div class="status-card">
                            <h3>📊 Monitoring & Logging</h3>
                            <ul style="list-style: none; padding: 0;">
                                <li>✓ CloudWatch Monitoring</li>
                                <li>✓ Application Logs</li>
                                <li>✓ Health Checks</li>
                                <li>✓ Load Balancer</li>
                                <li>✓ S3 Backup</li>
                            </ul>
                        </div>
                    </div>
                    
                    <div class="info-grid">
                        <div class="info-item">
                            <strong>Environment</strong>
                            Production
                        </div>
                        <div class="info-item">
                            <strong>Instance Type</strong>
                            t3.medium
                        </div>
                        <div class="info-item">
                            <strong>Storage</strong>
                            50GB GP3
                        </div>
                        <div class="info-item">
                            <strong>Network</strong>
                            VPC + Private Subnet
                        </div>
                    </div>
                </div>
            </body>
            </html>
            PHP
            
            # Set proper permissions
            chown -R apache:apache /var/www/html
            chmod -R 755 /var/www/html
            
            # Configure PHP
            sed -i 's/;date.timezone =/date.timezone = UTC/' /etc/php.ini
            
            # Restart Apache
            systemctl restart httpd
            
            # Install additional tools
            yum install -y curl wget git htop
            
            # Create application log directory
            mkdir -p /var/log/app
            chown apache:apache /var/log/app
            
            # Log successful setup
            echo "Production web server setup completed at $(date)" >> /var/log/user-data.log
            echo "Instance ID: $instance_id" >> /var/log/user-data.log
            EOF

# Tags
common_tags = {
  Environment = "production"
  Project     = "production-webapp"
  Owner       = "devops-team"
  Purpose     = "production"
  ManagedBy   = "terraform"
  CostCenter  = "production"
  Compliance  = "high"
  Backup      = "enabled"
  Monitoring  = "enabled"
}
