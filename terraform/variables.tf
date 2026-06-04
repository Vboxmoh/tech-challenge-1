variable "aws_region" {
  default = "eu-west-3"
}

variable "account_id" {
  description = "AWS Account ID"
}

variable "frontend_image" {
  description = "Frontend ECR image URI"
}

variable "backend_image" {
  description = "Backend ECR image URI"
}