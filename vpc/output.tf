output "id" {
  value = module.vpc.vpc_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "cidr_block" {
  value = var.cidr_block
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "public_subnets_ids_az" {
  value = zipmap(local.sliced_azs, module.vpc.public_subnets)
}

output "private_subnets_ids_az" {
  value = zipmap(local.sliced_azs, module.vpc.private_subnets)
}

output "nat_gateway_public_ips" {
  value = module.vpc.nat_public_ips
}
