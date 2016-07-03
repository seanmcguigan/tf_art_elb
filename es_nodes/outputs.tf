output "aws_instance" {
  value = "${join(",", aws_instance.es.*.id)}"
}

output "aws_instance_ip" {
  value = "${join(",", aws_instance.es.*.private_ip)}"
}

//value = "${join(",", aws_instance.web.*.public_ip)}"