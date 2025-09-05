
output "monitoring_vpc_id" {
  value = module.networking.vpc_id
}
output "monitoring_private_subnet_ids" {
  value = module.networking.private_subnet_ids
}
output "monitoring_security_group_id" {
  value = module.networking.security_group_id
}
output "platform_ecr_repository_url" {
  value = aws_ecr_repository.platform.repository_url
}
