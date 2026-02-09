resource "aws_iam_policy" "core_guardrails" {
  name        = "${var.project_name}-${var.env}-core-guardrails"
  description = "Core governance guardrails to protect audit, IAM, and AI foundations"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyDisablingCloudTrail"
        Effect = "Deny"
        Action = [
          "cloudtrail:StopLogging",
          "cloudtrail:DeleteTrail"
        ]
        Resource = "*"
      },
      {
        Sid    = "DenyDeletingLogs"
        Effect = "Deny"
        Action = [
          "logs:DeleteLogGroup",
          "logs:DeleteLogStream"
        ]
        Resource = "*"
      },
      {
        Sid    = "DenyPrivilegeEscalation"
        Effect = "Deny"
        Action = [
          "iam:CreatePolicyVersion",
          "iam:SetDefaultPolicyVersion",
          "iam:AttachRolePolicy",
          "iam:AttachUserPolicy"
        ]
        Resource = "*"
      }
    ]
  })
}
