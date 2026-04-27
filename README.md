# Security Skills

Security work gets messy when the model jumps straight to tools. This repo collects Codex skills that slow the workflow down in the right places: define scope, collect evidence, separate confirmed findings from guesses, and leave behind artifacts another reviewer can inspect.

The skills here are written for authorized security engineering, compliance review, and defensive validation. They are not meant to help fake reports, bypass consent, hide activity, or run unbounded attacks.

## What Is Included

| Skill | Use it for | What it tries to produce |
| --- | --- | --- |
| `android-privacy-compliance-audit` | Android APK privacy review against GB/T 41391-2022 and GB/T 35273-2020 | Static evidence, dynamic test plan, standard mapping, risk table |
| `apipost-api-security-testing` | Authorized API security cases in APIPost | Repeatable request workflows, assertions, evidence notes |
| `container-escape-review` | Container, Pod, and runtime escape-risk review | Manifest/runtime risk findings with safe validation steps |
| `container-foothold-recon` | First-pass triage from an authorized container or Pod shell | Capabilities, mounts, namespaces, service-account artifacts |
| `exploit-focused-code-audit` | Code audit for reachable high-impact vulnerabilities | Attack-surface map and exploitability-ranked findings |
| `kubernetes-privesc-review` | Kubernetes privilege-escalation and control-plane exposure review | RBAC, kubelet, dashboard, etcd, node-to-cluster risk analysis |
| `pentest-automation-safe` | Scope-gated external security baseline automation | Inventory/baseline reports without brute force or exploitation |
| `security-best-practices` | Python, JavaScript/TypeScript, and Go security guidance | Framework-aware hardening advice and focused fixes |
| `security-ownership-map` | Git-history based ownership analysis for sensitive code | CSV/JSON maps, bus-factor signals, sensitive ownership hotspots |
| `yakit-vuln-retest-screenshots` | Authorized vulnerability retesting in Yakit | Reproducible retest notes and screenshot evidence |

## Why These Skills Exist

Most security prompts fail in one of two ways: they are too vague to be actionable, or they ask the model to sound certain before the evidence exists. These skills are opinionated about that gap. A finding should say how it was observed. A blocked test should say what blocked it. A report should not quietly turn "not tested" into "safe."

The common thread is evidence discipline:

- Scope before action.
- Local artifacts over memory.
- `confirmed-risk`, `inconclusive`, `not-observed`, and `not-tested` over vague pass/fail language.
- Small helper scripts for repeatable collection.
- Refusal paths for forged evidence, deceptive UX, unauthorized targets, and fake compliance claims.

## Install

Clone the repository:

```bash
git clone https://github.com/FuNianTongXue/security-skills.git
```

Copy the skill directories you want into your Codex skills directory:

```bash
mkdir -p ~/.codex/skills
cp -R security-skills/* ~/.codex/skills/
```

Or install only one skill:

```bash
cp -R security-skills/container-escape-review ~/.codex/skills/
```

Restart Codex after adding new skills so the skill index is refreshed.

## Quick Examples

Run the Android static privacy collector:

```bash
security-skills/android-privacy-compliance-audit/scripts/android_static_privacy_scan.sh /path/to/app.apk
```

Review a Kubernetes service account from inside an authorized Pod:

```bash
security-skills/kubernetes-privesc-review/scripts/sa_self_rules_review.sh
```

Build a sensitive-code ownership map:

```bash
python3 security-skills/security-ownership-map/scripts/run_ownership_map.py \
  --repo /path/to/repo \
  --out /tmp/security-ownership
```

Run a scope-gated external baseline:

```bash
security-skills/pentest-automation-safe/scripts/run_authorized_baseline.sh \
  --mode baseline \
  --target example.com \
  --scope-file /path/to/scope.txt
```

## How To Pick A Skill

Start with the object you actually have:

- APK or privacy policy mismatch: `android-privacy-compliance-audit`
- OpenAPI collection or request workflow: `apipost-api-security-testing`
- Container manifest, Pod spec, or shell: `container-escape-review` or `container-foothold-recon`
- Kubernetes RBAC or node-to-cluster concern: `kubernetes-privesc-review`
- Source repository with unknown exploitable paths: `exploit-focused-code-audit`
- Secure coding guidance for a concrete stack: `security-best-practices`
- Security ownership and bus-factor questions: `security-ownership-map`
- Need to prove a web/API issue still reproduces: `yakit-vuln-retest-screenshots`

If the target, authorization, or expected artifact is unclear, the right next step is to narrow the scope before running tools.

## Repository Rules

Skills in this collection should:

- stay inside authorized testing, review, or compliance work;
- say when evidence is missing;
- avoid invented tool capabilities;
- prefer reproducible scripts and saved outputs;
- keep destructive actions out of default paths;
- refuse forged screenshots, fake audit trails, and false compliance language.

Contributions are welcome when they make a workflow more verifiable, safer to run, or easier to hand to another reviewer.
