output "public-dns" {
  # value = aws_elb.elk_elb.dns_name
  value = aws_elb.elk_elb.dns_name + ":" + tostring(5601)
}