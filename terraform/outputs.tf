output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.app.dns_name
}

output "ecr_frontend_url" {
  description = "Frontend ECR URL"
  value       = "${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/devops-tc1-frontend"
}

output "ecr_backend_url" {
  description = "Backend ECR URL"
  value       = "${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/devops-tc1-backend"
}