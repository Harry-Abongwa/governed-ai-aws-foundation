# Governed AI AWS Foundation (Terraform + GitHub OIDC + AI Guardrails)

A production-style, governance-first AWS foundation that demonstrates how to run AI workloads with **real controls**:
- **Identity controls** (separate AI execution role)
- **Behavior controls** (explicit deny guardrails + AI kill switch)
- **Audit controls** (centralized CloudTrail + CloudWatch visibility)
- **Cost controls** (budget ceilings + alerting)
- **CI/CD** (GitHub Actions with AWS OIDC – no long-lived secrets)

This project is designed to be interview-ready: it shows you can build a secure platform where AI usage is governed at the control plane (IAM), not just in application code.

---

## Architecture (High Level)

**Environment structure**
- `infra/environments/dev` — composition layer (wires modules together)
- `infra/modules/*` — reusable implementation modules

**Modules**
- `network` — VPC + private subnet (foundation layer)
- `guardrails` — AI execution role, deny guardrails, kill switch (inactive by default), governed Bedrock permissions
- `logging` — CloudTrail + CloudWatch log group + S3 bucket for immutable audit storage
- `cost` — AWS budget + alert notifications (FinOps guardrails)

---

## Governance Controls

### 1) Identity Governance (Human vs AI Separation)
AI runs under a dedicated role:
- `*-ai-execution-role`

This prevents “AI as a human user” patterns and ensures every AI action is attributable and constrainable.

### 2) Behavior Governance (Explicit Deny Guardrails)
Guardrails include deny-first controls such as:
- preventing disabling CloudTrail
- preventing deletion of audit log groups
- preventing common privilege escalation actions

### 3) Emergency Control: AI Kill Switch (Inactive by default)
A policy exists that can instantly deny Bedrock usage when attached.  
It is *armed but inactive* by default to avoid disruption.

To activate:
- switch `count` from `0` to `1` in the kill switch attachment
- `terraform apply`

### 4) Auditability (Centralized Logging)
CloudTrail is configured for:
- multi-region management events
- durable S3 storage for logs
- CloudWatch streaming for near real-time visibility

### 5) Cost Governance (FinOps)
An AWS budget is configured for the platform with alerts at:
- 80% (warning)
- 100% (hard threshold)

---

## Deployment

### Prereqs
- Terraform >= 1.6 (tested with 1.14.x)
- AWS CLI configured locally for bootstrap steps
- GitHub repo configured with AWS OIDC role to deploy without secrets

### Terraform (dev)
From:
`infra/environments/dev`

Run:
- `terraform init`
- `terraform plan`
- `terraform apply`

---

## Demo Script (Interview-Friendly)

1) **Show AI role separation**
- Point to the AI execution role and explain why it exists.

2) **Show governance guardrails**
- Explain deny-first guardrails protect audit + IAM.

3) **Show centralized audit**
- Show CloudTrail -> S3 + CloudWatch log group.

4) **Show cost ceiling**
- Show budgets config + email alerts.

5) **Prove the kill switch**
- Activate kill switch → Bedrock calls fail instantly.
- Deactivate kill switch → AI restored.

---

## Why This Matters
Most “AI projects” demonstrate prompts or model calls. This project demonstrates how to run AI **responsibly** in a way that:
- security teams approve
- auditors can validate
- finance teams can control
- engineering can operate safely

