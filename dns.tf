# Elasticsearch art private DNS

/*
resource "aws_route53_record" "es01" {
  zone_id = "Z1OHUWGBSB0K7B"
  name    = "es01.art.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.es.private_ip}"] 
}

resource "aws_route53_record" "es02" {
  zone_id = "Z1OHUWGBSB0K7B"
  name    = "es02.art.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.es.private_ip}"]
}

resource "aws_route53_record" "es03" {
  zone_id = "Z1OHUWGBSB0K7B"
  name    = "es03.art.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.es.private_ip}"]
}
*/

resource "aws_route53_zone" "primary" {
   name = "art.com"
   vpc_id = "${module.vpc.vpc_id}"
}

resource "aws_route53_record" "es" {
  // same number of records as instances
  count = 3
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name = "es0${count.index}.art.com"
  type = "A"
  ttl = "300"
  records = ["${element(aws_instance.es.*.private_ip, count.index)}"]
}