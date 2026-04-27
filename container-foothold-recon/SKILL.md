---
name: container-foothold-recon
description: Use when triaging an authorized shell or filesystem view inside a Linux container or Kubernetes Pod. Helps determine whether the foothold is Docker or Kubernetes, enumerate capabilities, mounts, namespaces, service account artifacts, runtime sockets, and likely next-step validation paths without jumping straight into invasive exploitation. 适用于容器落点侦察、Pod shell 信息收集、容器内权限与挂载面判断。
---

# Container Foothold Recon

Use this skill when the user already has an authorized foothold in a container or Pod and wants to understand what that foothold can realistically reach.

Keep the work read-heavy and low-impact:

- Prefer local inspection of `/proc`, mounts, env vars, and mounted credentials.
- Do not mutate workloads, write persistence, or create new cluster resources unless the user explicitly asks and the scope is clearly authorized.
- Treat this skill as the decision layer before deeper review.

## Start Here

1. If you have shell access in the target container, run [scripts/container_quick_recon.sh](scripts/container_quick_recon.sh).
2. If the environment is stripped down and `capsh` is unavailable, use [scripts/decode_caps.py](scripts/decode_caps.py) with the hex values from `/proc/1/status`.
3. Read [references/recon-checklist.md](references/recon-checklist.md) when you need command interpretation or the decision matrix.

## Core Workflow

### 1. Classify the execution surface

Decide which of these you are in:

- Standalone container
- Kubernetes Pod
- Container with host namespace leakage
- Node shell that only looks containerized

Base this on cgroup paths, service account mounts, DNS search domains, runtime socket exposure, and namespace behavior.

### 2. Inventory what is already granted

Focus on facts that materially change the next step:

- Effective user and groups
- Linux capabilities
- Mounted host paths
- Container runtime sockets
- Service account token, CA, and namespace files
- Network clues to API server or node-local services
- Whether `/proc`, `/sys`, or cgroup paths reveal host visibility

### 3. Turn artifacts into hypotheses

Use the recon output to decide the likely next review path:

- If you see runtime sockets, sensitive host mounts, `privileged`, or dangerous capabilities, switch to `$container-escape-review`.
- If you see a service account token, kubeconfig material, kubelet access, or node-level cluster artifacts, switch to `$kubernetes-privesc-review`.
- If the shell is low-value and isolated, say so clearly and avoid inventing escalation.

### 4. Keep evidence tidy

Capture only the artifacts that matter:

- `/proc/1/cgroup`
- `/proc/1/status`
- `/proc/1/mountinfo`
- Relevant environment variables
- Service account file presence
- Socket paths
- Node or control-plane reachability clues

Summarize what each artifact means instead of dumping raw output unless the user asked for it.

## Output Expectations

A good result from this skill should answer:

1. Are we in Docker, Kubernetes, or something host-adjacent?
2. What privileges are already present?
3. What is the most plausible next authorized validation step?
4. What does not appear reachable from this foothold?

Be conservative. The value of this skill is accurate classification, not aggressive guessing.
