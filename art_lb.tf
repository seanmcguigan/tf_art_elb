resource "aws_elb" "art" {
  name = "art-elb"
  //availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  security_groups = ["${module.sg_elasticsearch.security_group_id}"]
  listener {
    instance_port = 9200
    instance_protocol = "http"
    lb_port = 9200
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:9200/"
    interval = 30
  }

  //count = 3
  
  //instances = ["${element(aws_instance.es.*.id, count.index)}"]
  //instances = ["${aws_instance.es.*.id}"]

  instances = ["${split(",", module.es_nodes.aws_instance)}"]


  //subnets = ["subnet-30b7d454", "subnet-ff5a97a7", "subnet-d56dd7a3"]

  //subnets = ["${element(split(",", module.vpc.public_subnets), count.index)}"] 

  subnets = ["${split(",", module.vpc.public_subnets)}"]

  //subnets = ["${module.vpc.public_subnets}"]

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "es ELB"
  }
}