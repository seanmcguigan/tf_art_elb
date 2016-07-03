resource "aws_instance" "es" {
    ami = "${var.ami}"
    count = "${var.count}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    security_groups = ["${var.security_groups}"]
  /*  subnet_id = "${module.vpc.private_subnets}" */
  /*  subnet_id = "${lookup(module.vpc.private_subnets, count.index)}" */
  //  subnet_id = "${var.subnet_id}"
    subnet_id = "${element(split(",", var.subnet_id), count.index)}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    source_dest_check = "${var.source_dest_check}"
    user_data = "${var.user_data}"
    tags {
        Name = "es-${count.index}"
    }
}