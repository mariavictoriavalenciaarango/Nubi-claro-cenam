resource "aws_iam_role" "redshift-serverless-role" {
  name = "${var.app_name}-${var.Environment}-redshift-serverless-role-new"

assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "redshift.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}
