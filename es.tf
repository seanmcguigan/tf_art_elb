/*
variable "key_name" {}
variable "key_path" "/Users/seanmc/.ssh/tf_dev.pem"
*/

resource "aws_instance" "es" {
    ami = "ami-7172b611"
    count = 3
    instance_type = "t2.small"
    key_name = "tf_art"
    security_groups = ["${module.sg_elasticsearch.security_group_id}"]
  /*  subnet_id = "${module.vpc.private_subnets}" */
  /*  subnet_id = "${lookup(module.vpc.private_subnets, count.index)}" */
    subnet_id = "${element(split(",", module.vpc.private_subnets), count.index)}"
    associate_public_ip_address = false
    source_dest_check = false
    user_data = "${file("userdata.sh")}"
    tags {
        Name = "es-${count.index}"
    }
}

