output "ip" {
  value = "${aws_resource.kafka.public_ip}"
}
