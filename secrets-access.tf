data "aws_iam_policy_document" "secrets" {
  statement {
    sid = "1"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      var.database_secret_arn,
      "arn:aws:secretsmanager:*:*:secret:${var.config_path}/database-*"
    ]
  }
}

resource "aws_iam_role_policy" "secrets" {
  name   = "secrets"
  role   = aws_iam_role.main.id
  policy = data.aws_iam_policy_document.secrets.json
}
