output "public-dns" {
  value = format("%s:%d", aws_elb.elk_elb.dns_name, 5601)
}