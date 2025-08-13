# משתנים לפרויקט

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}

variable "key_name" {
  description = "Existing EC2 Key Pair name"
  type        = string
}
