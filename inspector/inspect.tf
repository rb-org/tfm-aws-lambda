resource "aws_inspector_resource_group" "main" {
  tags = {
    Inspector = "true"
  }
}

resource "aws_inspector_assessment_target" "main" {
  name               = "Assessment-Target-All-Instances"
  resource_group_arn = "${aws_inspector_resource_group.main.arn}"
}

resource "aws_inspector_assessment_template" "main" {
  name       = "Inspector Rules"
  target_arn = "${aws_inspector_assessment_target.main.arn}"
  duration   = "${var.duration}"

  rules_package_arns = "${data.aws_inspector_rules_packages.rules.arns}"
}
