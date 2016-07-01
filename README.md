#tf_elb

Fault tolerant extension of community tf_aws_vpc adding NAT service gateway routing https://github.com/terraform-community-modules/tf_aws_vpc.
x3 az, x3 public subnets, x3 private subnets.
All elasticsearch nodes are in private subnets, within each availability zone.
Security group sg_elasticsearch allows ingress on tcp,9300,9200,22 from anywhere. Change ssh ingress to your office pubic ip/s.

example output
```
Outputs:

  elb_dns_name           = art-elb-2002197915.us-west-2.elb.amazonaws.com
  nat_gateway_id         = nat-0a1e8f1d0f8d53952
  private_route_table_id = rtb-297b594d
  private_subnets        = subnet-31b7d455,subnet-d26dd7a4,subnet-fe5a97a6
  public_route_table_id  = rtb-d67a58b2
  public_subnets         = subnet-30b7d454,subnet-d56dd7a3,subnet-ff5a97a7
  vpc_id                 = vpc-b988fbdd
```
#provisioner

No time to build a provisioning tool so userdata used to configure elasticsearch, not ideal would prefer to provision with chef/chef server, example provisoner.
```
resource "aws_instance" "es_graylog_srv_dev01" {
    ami = "ami-a36b89cc"
    availability_zone = "eu-central-1a"
    instance_type = "m4.2xlarge"
    key_name = "${var.key_name}"
    security_groups = ["${aws_security_group.backend.id}"]
    subnet_id = "${aws_subnet.eu-central-1a-private.id}"
    associate_public_ip_address = false
    source_dest_check = false

    provisioner "chef" {
    server_url = "https://chefserver.foo.co.uk/organizations/foo"
    validation_client_name = "foo-validator"
    validation_key = "~/.chef/foo-validator.pem"
    node_name = "es_graylog_srv_dev01"
    version = "12.8.1"
 
    client_options = [ "audit_mode  :enabled" ]
    skip_install = true 

    secret_key = "${var.databag_key_name}"

    use_policyfile = true
    policy_group = "dev"
    policy_name = "es-graylog"

    connection {
    bastion_host = "${aws_eip.bastion-server.public_ip}" 
    user = "centos"
    key_file = "~/.ssh/tf_dev.pem"
    agent = "false"
    }
}

    provisioner "local-exec" {
        command = "knife tag create es_graylog_srv_dev01 essrv"
    }


    tags {
        Name = "es_graylog_srv_dev01"
    }
}
```
#es cluster
Nodes dont automatically join cluster as multicast is disabled on AWS. Using DNS hosts mapped by aws_route53_zone resource for discovery.zen.ping.unicast.hosts
```
discovery.zen.ping.unicast.hosts: ['es00.art.com', 'es01.art.com', 'es02.art.com']

```  
http://art-elb-2143963483.us-west-2.elb.amazonaws.com:9200/_cluster/health?pretty=true

```
{
  "cluster_name" : "artirix",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 3,
  "number_of_data_nodes" : 3,
  "active_primary_shards" : 0,
  "active_shards" : 0,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
```


