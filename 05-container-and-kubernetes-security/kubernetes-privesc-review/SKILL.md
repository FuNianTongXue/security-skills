---
name: kubernetes-privesc-review
description: Use when testing Kubernetes privilege-escalation paths in an authorized environment, especially Pod or node starting points that may lead to broader cluster control. Covers service account overreach, DaemonSet and node-agent RBAC risk, kubelet and control-plane exposure, dashboard or etcd misconfiguration, kubectl proxy exposure, and safe validation of node-to-cluster pivot opportunities. 适用于 K8s 提权审计、ServiceAccount 权限过大排查、节点到集群管理面的横向与控制面暴露检查。
---

# Kubernetes Privilege Escalation Review

Use this skill when the user wants to understand whether a Pod foothold, node shell, or exposed Kubernetes component can turn into broader cluster control.

Keep the workflow evidence-first:

- Prefer token introspection, config review, RBAC review, and read-only validation.
- Do not create new workloads, bind new roles, or exercise destructive cluster actions unless the user explicitly asks and the test is clearly authorized.
- Distinguish between "can observe", "can administer a namespace", and "can control the cluster."

## Start Here

1. Read [references/privesc-checklist.md](references/privesc-checklist.md) for the main workflow.
2. Read [references/control-plane-exposure.md](references/control-plane-exposure.md) when the issue may involve API server, kubelet, dashboard, etcd, Docker Remote API, or `kubectl proxy`.
3. If you are inside a Pod and have the mounted token, run [scripts/sa_self_rules_review.sh](scripts/sa_self_rules_review.sh) to ask the API server what the current principal can do.

## Core Workflow

### 1. Identify the starting point

Common starting points:

- Pod shell with service account mount
- Node shell with kubelet or kubeconfig artifacts
- Exposed control-plane component
- Dashboard access
- Runtime or orchestration API exposure

### 2. Review the identity actually in use

Focus on the real principal:

- Mounted service account token
- Kubeconfig credentials
- Node certificate or kubelet identity
- Anonymous or skip-login access paths

Do not assume the cluster is overexposed until you verify the active identity and its rights.

### 3. Look for the high-value Kubernetes permissions

Prioritize permissions that often collapse isolation boundaries:

- Secrets access, especially in privileged namespaces
- Pod create or workload mutation
- Pod exec or attach
- DaemonSet or Deployment control
- Nodes or node proxy access
- RoleBinding or ClusterRoleBinding changes
- ServiceAccount token minting or impersonation-adjacent rights

### 4. Review node-adjacent cluster artifacts

From a node shell, inspect for:

- `~/.kube/config`
- `/etc/kubernetes`
- `/var/lib/kubelet`
- Static Pod manifests
- Control-plane certs and kubeconfigs

These often matter more than speculative API abuse.

### 5. Review exposed components conservatively

When the path is an exposed component:

- Confirm whether it is truly reachable
- Confirm whether authentication is required
- Confirm what identity or backend privilege is actually being used
- Prefer health, version, config, and passive exposure evidence first

## Output Expectations

A good result from this skill should answer:

1. What identity is in play?
2. What cluster actions does that identity really have?
3. Is there a believable path to namespace admin, node control, or cluster admin?
4. Which control-plane or node artifacts make the path stronger?

Keep the conclusion scoped. "Interesting" is not the same as "cluster-admin equivalent."
