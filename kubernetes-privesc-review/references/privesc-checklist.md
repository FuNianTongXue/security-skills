# Privilege Escalation Checklist

Use this checklist for authorized Kubernetes privilege review from either a Pod foothold or a node foothold.

## Starting From A Pod

### Identity and token

- Confirm whether `/var/run/secrets/kubernetes.io/serviceaccount/` exists
- Read the `namespace` file
- Confirm API server location from env vars or DNS
- Use [../scripts/sa_self_rules_review.sh](../scripts/sa_self_rules_review.sh) when possible

### High-value rights to look for

- `get`, `list`, or `watch` on `secrets`
- `create`, `update`, `patch`, or `delete` on Pods or workloads
- `create` on Pods in privileged namespaces
- `create` or mutation rights on DaemonSets
- `create` on `rolebindings` or `clusterrolebindings`
- Access to `nodes`, `nodes/proxy`, or kube-system workloads

### High-value workload families

Give extra scrutiny to `kube-system` or node-wide agents such as:

- CNI plugins
- Logging DaemonSets
- Monitoring agents
- Security agents
- Storage agents

These frequently combine broad RBAC with node visibility.

## Starting From A Node

### Local artifacts

Inspect for:

- `~/.kube/config`
- `/etc/kubernetes/admin.conf`
- `/etc/kubernetes/kubelet.conf`
- `/var/lib/kubelet/kubeconfig`
- `/etc/kubernetes/manifests`
- Client certs, bootstrap tokens, or other cluster credentials

### Services and exposure

Check listening services and local configs for:

- API server
- kubelet
- dashboard
- etcd
- Docker Remote API
- `kubectl proxy`

Prefer passive evidence such as config files and listening sockets before active probing.

## Evidence Language

Use precise labels:

- Namespace-level administrative risk
- Node-to-cluster pivot risk
- Cluster-admin equivalent risk
- Control-plane exposure with auth still intact
- Misconfiguration with no confirmed privilege path yet

## Common Honest Conclusions

- Token is mounted but rights are modest
- Token can administer a namespace but not the cluster
- Node artifacts likely outrank the current service account as a pivot
- Control-plane component is exposed, but reachable privilege still needs confirmation
