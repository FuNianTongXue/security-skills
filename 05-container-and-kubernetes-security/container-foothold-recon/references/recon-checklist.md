# Recon Checklist

Use this checklist after you obtain an authorized shell or filesystem view in a container or Pod.

## Quick Questions

- Is this actually a container, or a host shell inside a lightly isolated process tree?
- Is it Kubernetes-managed?
- Is there a mounted service account token?
- Are there host mounts, runtime sockets, or dangerous capabilities already present?
- Is the current value in the container itself, or in what it can reach?

## High-Value Artifacts

### Container identity

- `/proc/1/cgroup`
  - Docker usually exposes paths containing `/docker/`
  - Kubernetes commonly exposes `/kubepods/`
- `/.dockerenv`
  - Useful signal, but not authoritative
- `/etc/hostname`
  - Sometimes matches Pod naming patterns

### Capability and privilege state

- `/proc/1/status`
  - Read `CapEff`, `CapPrm`, `CapBnd`, `NoNewPrivs`, `Seccomp`
- `/proc/self/status`
  - Useful when PID 1 is not the current shell process
- `id`
  - Root vs non-root still matters, but capabilities and mounts matter more

If `capsh` is missing, decode the hex values with [../scripts/decode_caps.py](../scripts/decode_caps.py).

### Kubernetes clues

- `/var/run/secrets/kubernetes.io/serviceaccount/`
  - `token`, `ca.crt`, and `namespace` are the key files
- `env`
  - Look for `KUBERNETES_SERVICE_HOST`, `KUBERNETES_PORT`, or namespace-specific service env vars
- `/etc/resolv.conf`
  - Search domains such as `svc.cluster.local`

### Mounts and host visibility

- `/proc/1/mountinfo`
- `/proc/self/mounts`
- `/etc/mtab`

Pay special attention to:

- `/var/run/docker.sock`
- `/run/containerd/containerd.sock`
- `/run/crio/crio.sock`
- `/var/lib/kubelet`
- `/etc/kubernetes`
- `/etc/kubernetes/manifests`
- `/proc`
- `/sys`
- `/`

### Network and process hints

- `/proc/net/unix`
  - Good for socket discovery in stripped-down images
- `ss -lntp` or `netstat -lntp` if available
- `ps aux`
  - Helps spot whether host processes are exposed through `hostPID` or unusual namespace sharing

## Interpretation Shortcuts

- Service account token present:
  - Move toward `$kubernetes-privesc-review`
- Runtime socket or sensitive host mount present:
  - Move toward `$container-escape-review`
- `SYS_PTRACE`, `SYS_ADMIN`, `DAC_READ_SEARCH`, `BPF`, or `PERFMON` present:
  - Review escape surface and host-observation risk carefully
- `hostPID`-like process visibility:
  - Treat the foothold as materially closer to node impact
- No token, no socket, no host mount, no dangerous caps:
  - Say the foothold looks comparatively contained

## Reporting Shape

Keep the summary short and decision-oriented:

- Environment type
- Privilege indicators
- High-value reachable artifacts
- Most likely next safe validation path
- Important negative findings

The goal is to reduce ambiguity for the next step, not to produce a raw data dump.
