output "ip" {
  value = "${aws_instance.kafka.public_ip}"
}
