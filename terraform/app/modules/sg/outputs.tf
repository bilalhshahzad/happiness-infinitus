output "sg_web_obj" {
  description = ""
  value       = aws_security_group.website
}

output "sg_web_id" {
  description = ""
  value       = aws_security_group.website.id
}

output "sg_db_id" {
  description = ""
  value       = aws_security_group.database.id
}

output "sg_efs_id" {
  description = ""
  value       = aws_security_group.efs.id
}