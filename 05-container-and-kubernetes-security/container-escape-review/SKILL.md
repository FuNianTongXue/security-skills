---
name: container-escape-review
description: Use when reviewing a container, Pod manifest, runtime configuration, or node-adjacent shell for container escape and node-compromise risk during an authorized assessment. Focus on privileged containers, dangerous capabilities, host namespaces, hostPath mounts, runtime sockets, cgroup abuse preconditions, eBPF-related risk, and safe validation rather than destructive exploitation. 适用于容器逃逸面审计、宿主机暴露检查、Pod 权限过大与 runtime 风险评估。
---

# Container Escape Review

Use this skill to assess whether a containerized workload is one misconfiguration away from node impact.

This skill should stay validation-first:

- Prefer manifest review, mount inspection, capability analysis, and runtime exposure checks.
- Do not create privileged Pods, write host files, or exercise persistence unless the user explicitly asks and the environment is clearly authorized for that level of testing.
- Explain why a condition matters before suggesting a follow-up check.

## Start Here

1. Read [references/escape-checklist.md](references/escape-checklist.md) for the main workflow.
2. Read [references/runtime-risk-matrix.md](references/runtime-risk-matrix.md) when you need a compact risk-to-impact map.
3. If the user has manifests or IaC locally, run [scripts/manifest_risk_grep.sh](scripts/manifest_risk_grep.sh) on the relevant path.

## Core Workflow

### 1. Identify the control plane for the workload

Figure out whether you are looking at:

- A Pod spec or Helm chart
- `docker inspect` or runtime config
- A live shell inside the container
- A node shell with container artifacts

The best evidence is configuration plus live state together.

### 2. Rank the biggest escape surfaces first

Prioritize these categories:

- `privileged: true`
- Host namespace sharing such as `hostPID`, `hostIPC`, or `hostNetwork`
- Sensitive `hostPath` mounts
- Runtime sockets such as Docker, containerd, or CRI-O
- Dangerous capabilities such as `SYS_ADMIN`, `SYS_PTRACE`, `DAC_READ_SEARCH`, `BPF`, `PERFMON`, `SYS_MODULE`
- Unconfined seccomp or AppArmor relaxation
- Writable cgroup or unusual controller exposure
- eBPF prerequisites on modern kernels
- Node control artifacts such as `/etc/kubernetes/manifests` or `/var/lib/kubelet`

### 3. Validate safely

Prefer low-impact checks:

- Read manifests
- Read `/proc/1/mountinfo`
- Read `/proc/1/status`
- Inspect runtime socket mounts
- Inspect cgroup and seccomp state
- Inspect kernel and runtime version clues

Avoid turning a risky condition into an active host takeover unless the user explicitly wants an authorized reproduction.

### 4. Separate immediate risk from conditional risk

Be explicit about which findings are:

- Immediate node-compromise enablers
- Strong escape preconditions that still need another weakness
- High-value hardening gaps
- Historical exploit families that are not obviously reachable in the present environment

### 5. Hand off when the dominant issue is Kubernetes RBAC

If the main story becomes service account overreach, DaemonSet privilege, kubelet exposure, or node-to-cluster pivoting, switch to `$kubernetes-privesc-review`.

## Output Expectations

A good result from this skill should answer:

1. Which escape surfaces are actually present?
2. Which of them look immediately actionable in an authorized test?
3. What evidence supports each conclusion?
4. What hardening change would most reduce risk?

Favor concrete evidence over exploit mythology.
