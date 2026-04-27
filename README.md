# Shayshen Security Skills

A categorized bundle of Codex security skills for people who need evidence, repeatability, and sane boundaries.

这个仓库整理了一组面向 Codex 的安全类自定义 skills。它不是“提示词合集”，更像是一套可复用的安全工作流：先确认授权和范围，再收集证据，最后把结论写成别人能复核的报告。

## Why Star This

Most security prompts fail because they rush from a vague goal to a powerful tool. These skills try to fix that habit.

- Scope-first workflows for audits, retests, compliance checks, and security engineering reviews.
- Evidence language that separates `confirmed-risk`, `inconclusive`, `not-observed`, and `not-tested`.
- Helper scripts for repeatable collection instead of one-off command memory.
- Guardrails against fake compliance claims, forged screenshots, unauthorized scanning, and unsupported tool features.
- Coverage across smart contracts, web/API testing, privacy compliance, container/Kubernetes review, and security governance.

If you use Codex for real security work, this repository gives you starting points that already care about evidence quality.

## Skills Index

| Category | Skill | Best for |
| --- | --- | --- |
| Smart Contract Security | `smart-contract-entry-points` | Mapping state-changing entry points, permissions, and audit attack surface |
| Smart Contract Security | `smart-contract-security-suite` | Audit prep, secure workflow guidance, upgrade review, and vulnerability pattern triage |
| Smart Contract Security | `web3-security-pm` | Web3 security product planning, specs, and delivery workflows |
| Web and API Security | `apipost-api-security-testing` | Authorized APIPost API security cases, assertions, and evidence collection |
| Web and API Security | `exploit-focused-code-audit` | Reachable high-impact code audit from an attacker-with-low-privilege perspective |
| Web and API Security | `pentest-automation-safe` | Scope-gated external inventory and baseline scanning without brute force or exploitation |
| Web and API Security | `yakit-vuln-retest-screenshots` | Authorized vulnerability retesting in Yakit with reproducible screenshot evidence |
| Privacy and Compliance | `android-privacy-compliance-audit` | Android APK privacy review against GB/T 41391-2022 and GB/T 35273-2020 |
| Security Engineering and Governance | `security-best-practices` | Python, JavaScript/TypeScript, and Go secure-by-default guidance |
| Security Engineering and Governance | `security-ownership-map` | Git-history based sensitive-code ownership, bus factor, and maintainer analysis |
| Container and Kubernetes Security | `container-escape-review` | Container, Pod, and runtime escape-risk review |
| Container and Kubernetes Security | `container-foothold-recon` | Authorized shell triage inside Linux containers or Kubernetes Pods |
| Container and Kubernetes Security | `kubernetes-privesc-review` | ServiceAccount overreach, kubelet/control-plane exposure, and node-to-cluster risk |

See [docs/skills-index.md](docs/skills-index.md) for the compact directory index.

## Repository Layout

```text
security-skills/
├── 01-smart-contract-security/
├── 02-web-and-api-security/
├── 03-privacy-and-compliance/
├── 04-security-engineering-and-governance/
├── 05-container-and-kubernetes-security/
├── docs/
├── NOTICE.md
└── PUBLISH_CHECKLIST.md
```

## Install

Clone the repository:

```bash
git clone https://github.com/FuNianTongXue/security-skills.git
```

Install one skill by copying its directory into Codex:

```bash
mkdir -p ~/.codex/skills
cp -R security-skills/05-container-and-kubernetes-security/container-escape-review ~/.codex/skills/
```

Install a whole category:

```bash
cp -R security-skills/02-web-and-api-security/* ~/.codex/skills/
```

Restart Codex after adding skills so the skill index is refreshed.

## Quick Examples

Run the Android static privacy collector:

```bash
security-skills/03-privacy-and-compliance/android-privacy-compliance-audit/scripts/android_static_privacy_scan.sh /path/to/app.apk
```

Review a Kubernetes service account from inside an authorized Pod:

```bash
security-skills/05-container-and-kubernetes-security/kubernetes-privesc-review/scripts/sa_self_rules_review.sh
```

Build a sensitive-code ownership map:

```bash
python3 security-skills/04-security-engineering-and-governance/security-ownership-map/scripts/run_ownership_map.py \
  --repo /path/to/repo \
  --out /tmp/security-ownership
```

Run a scope-gated external baseline:

```bash
security-skills/02-web-and-api-security/pentest-automation-safe/scripts/run_authorized_baseline.sh \
  --mode baseline \
  --target example.com \
  --scope-file /path/to/scope.txt
```

## Design Rules

Skills in this collection should:

- stay inside authorized testing, review, or compliance work;
- say when evidence is missing;
- avoid invented tool capabilities;
- prefer reproducible scripts and saved outputs;
- keep destructive actions out of default paths;
- refuse forged screenshots, fake audit trails, and false compliance language.

## Before Publishing Publicly

Read [PUBLISH_CHECKLIST.md](PUBLISH_CHECKLIST.md) and [NOTICE.md](NOTICE.md). Some folders include adapted third-party material or per-skill license notes, so do not assume a single repository-wide license covers every file.

Suggested repository topics:

```text
codex, skills, security, smart-contract-security, api-security,
privacy-compliance, kubernetes-security, container-security, web3
```

Contributions are welcome when they make a workflow more verifiable, safer to run, or easier to hand to another reviewer.
