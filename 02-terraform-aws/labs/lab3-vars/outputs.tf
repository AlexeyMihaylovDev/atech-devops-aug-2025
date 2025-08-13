# פלטי מידע חשובים

output "vpc_id" {
  description = "ID של ה-VPC שנוצר"
  value       = aws_vpc.demo_vpc.id
}

output "subnet_id" {
  description = "ID של ה-Subnet שנוצר"
  value       = aws_subnet.demo_subnet.id
}

output "security_group_id" {
  description = "ID של ה-Security Group שנוצר"
  value       = aws_security_group.demo_sg.id
}

output "instance_id" {
  description = "ID של ה-EC2 Instance שנוצר"
  value       = aws_instance.demo_ec2.id
}

output "instance_public_ip" {
  description = "Public IP של ה-EC2 Instance"
  value       = aws_instance.demo_ec2.public_ip
}

output "instance_public_dns" {
  description = "Public DNS של ה-EC2 Instance"
  value       = aws_instance.demo_ec2.public_dns
}

output "ami_id" {
  description = "AMI ID שנבחר אוטומטית"
  value       = data.aws_ami.amazon_linux.id
}

output "ami_name" {
  description = "שם ה-AMI שנבחר"
  value       = data.aws_ami.amazon_linux.name
}

output "ami_owner" {
  description = "בעלים של ה-AMI"
  value       = data.aws_ami.amazon_linux.owners
}

output "availability_zone" {
  description = "Availability Zone שנבחרה אוטומטית"
  value       = data.aws_availability_zones.available.names[0]
}

output "ssh_command" {
  description = "פקודה לחיבור SSH לשרת"
  value       = "ssh -i demo-keypair.pem ec2-user@${aws_instance.demo_ec2.public_ip}"
}

output "private_key" {
  description = "Private Key לחיבור SSH (שמור בקובץ .pem)"
  value       = tls_private_key.demo_private_key.private_key_pem
  sensitive   = true
}

output "key_pair_name" {
  description = "שם ה-Key Pair שנוצר אוטומטית"
  value       = aws_key_pair.demo_key.key_name
}

output "web_url" {
  description = "URL לגישה לאפליקציה"
  value       = "http://${aws_instance.demo_ec2.public_ip}"
}

output "elastic_ip" {
  description = "Elastic IP של השרת"
  value       = aws_eip.demo_eip.public_ip
}

output "ebs_volume_id" {
  description = "ID של ה-EBS Volume"
  value       = aws_ebs_volume.demo_volume.id
}

output "ebs_volume_size" {
  description = "גודל ה-EBS Volume ב-GB"
  value       = aws_ebs_volume.demo_volume.size
}

output "web_url_eip" {
  description = "URL לגישה לאפליקציה דרך Elastic IP"
  value       = "http://${aws_eip.demo_eip.public_ip}"
}
