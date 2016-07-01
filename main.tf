/* define the provider */

provider "aws" {
 /*   region = "${var.region}" */
 region = "us-west-2"
}

module "vpc" {
  source = "./tf_aws_vpc"
  name = "art-lb-vpc"
  cidr = "10.0.0.0/16"
  private_subnets = "10.0.1.0/24,10.0.2.0/24,10.0.3.0/24"
  public_subnets  = "10.0.4.0/24,10.0.5.0/24,10.0.7.0/24"/*,10.0.8.0/24" */
  azs = "us-west-2a,us-west-2b,us-west-2c"
}

module "sg_elasticsearch" {
  source = "./sg_elasticsearch"
  security_group_name = "sg_elasticsearch"
  vpc_id = "${module.vpc.vpc_id}"
  source_cidr_block = "0.0.0.0/0"
}


//["${element(aws_instance.es.*.private_ip, count.index)}"]

/*  output references module outputs */ 

output "vpc_id" {
      value = "${module.vpc.vpc_id}"
}

output "private_subnets" {
      value = "${module.vpc.private_subnets}"
}

output "public_subnets" {
      value = "${module.vpc.public_subnets}"
}

output "public_route_table_id" {
      value = "${module.vpc.public_route_table_id}"
}

output "private_route_table_id" {
      value = "${module.vpc.private_route_table_id}"
}

output "nat_gateway_id" {
      value = "${module.vpc.aws_nat_gateway}"
}

output "elb_dns_name" {
  value = "${aws_elb.art.dns_name}"
}














