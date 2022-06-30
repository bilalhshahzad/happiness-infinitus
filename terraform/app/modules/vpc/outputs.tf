output "subnet_public-a_id" {
  description = ""
  value       = aws_subnet.public-a.id
}

output "subnet_public-b_id" {
  description = ""
  value       = aws_subnet.public-b.id
}

output "subnet_private-a_id" {
  description = ""
  value       = aws_subnet.private-a.id
}

output "subnet_private-b_id" {
  description = ""
  value       = aws_subnet.private-b.id
}

output "vpc_id" {
  description = ""
  value       = aws_vpc.this.id
}