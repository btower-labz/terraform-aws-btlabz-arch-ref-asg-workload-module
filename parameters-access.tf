data "aws_iam_policy_document" "parameters" {
  statement {
    sid = "1"
    actions = [
      "ssm:DescribeParameters"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid = "2"
    actions = [
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]
    resources = [
      "arn:aws:ssm:*:*:parameter${var.config_path}/*"
    ]
  }
}

resource "aws_iam_role_policy" "parameters" {
  name   = "parameters"
  role   = aws_iam_role.main.id
  policy = data.aws_iam_policy_document.parameters.json
}
