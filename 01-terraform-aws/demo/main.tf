# יצירת שרת קטן ב-AWS
provider "aws" {
  region = "ca-central-1"
}

resource "aws_instance" "web" {
  ami           = "ami-05d4121edd74a9f06"
  instance_type = "t3.micro"

  tags = {
    Name = "demo2"
    Environment = "production"
    Framework = "terraform"
    
  }
}

output "instance_id" {
    description = "The ID of the EC2 instance"
    value = aws_instance.web.id
}

output "ec2_name_tag" {
    description = "The name tag of the EC2 instance"
    value = "Instance Name: ${aws_instance.web.tags.Name}"
}

