output "vpc_id" {
  value = aws_vpc.main.id
  # id of the VPC" {

}

output "public_subnet_1_id" {
  value = aws_subnet.public_1.id
  # id of the public subnet 1" {

}
output "public_subnet_2_id" {
  value = aws_subnet.public_2.id
  # id of the public subnet 2" {

}
output "private_subnet_1_id" {
  value = aws_subnet.private_1.id
  # id of the private subnet 1" {

}
output "private_subnet_2_id" {
  value = aws_subnet.private_2.id
  # id of the private subnet 2" {

}