
data "template_file" "user_data_script" {
  template = "${file("${path.module}/user-data-script.sh")}"
}

resource "aws_instance" "kafka" {
  ami           = "ami-4836a428"
  instance_type = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.kafka_instance_profile.name}"
  vpc_security_group_ids = ["sg-888dabf1"]
  subnet_id = "subnet-24f6877c"
  associate_public_ip_address = true
  key_name = "dev"
  user_data = "${data.template_file.user_data_script.rendered}"
  tags {
    Name = "kafka"
  }
}
