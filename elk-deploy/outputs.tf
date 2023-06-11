output "public-dns" {
  value = aws_elb.elk_elb.dns_name + ":5601"
}