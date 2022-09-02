
output "vpc_id" {
  value = aws_vpc.kojitech_vpc.id
}

output "pub_subnetid" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnetid" {
  value = aws_subnet.private_subnet[*].id
}

output "database_subnetid" {
  value = aws_subnet.database_subnet[*].id
}