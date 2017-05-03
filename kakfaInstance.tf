data "aws_ami" "kafka" {
  most_recent = true

  filter {
    name   = "name"
    values = ["kafka-*"]
  }

  owners = ["self"]
}

resource "aws_instance" "kafka" {
  ami           = "${data.aws_ami.kafka.id}"
  instance_type = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.kafka_instance_profile.name}"
  vpc_security_group_ids = ["sg-888dabf1"]
  subnet_id = "subnet-24f6877c"
  associate_public_ip_address = true
  key_name = "dev2"
  tags {
    Name = "kafka"
  }
}
