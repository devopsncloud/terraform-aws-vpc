output "azs" {
  value       = local.az_names
}


output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids"{
  value = aws_subnet.public[*].id
}

output "private_subnet_ids"{
  value = aws_subnet.private[*].id
}

output "db_subnet_ids"{
  value = aws_subnet.db[*].id
}