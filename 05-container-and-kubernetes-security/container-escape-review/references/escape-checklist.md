# Escape Checklist

This checklist is distilled from recurring container escape themes: over-privileged workloads, sensitive host mounts, runtime socket exposure, cgroup abuse preconditions, and kernel-adjacent features such as eBPF.

## High-Risk Signals

### Privilege model

- `privileged: true`
- `allowPrivilegeEscalation: true`
- Running as root without a strong reason
- `runAsNonRoot: false`
- Unconfined seccomp or loosened AppArmor

### Dangerous capabilities

Treat these as especially important:

- `SYS_ADMIN`
- `SYS_PTRACE`
- `DAC_READ_SEARCH`
- `BPF`
- `PERFMON`
- `SYS_MODULE`

They do not all imply the same impact, but each can materially change the path to host visibility or kernel-adjacent abuse.

### Namespace and mount exposure

- `hostPID`, `hostIPC`, `hostNetwork`
- `hostPath` mounts into:
  - `/`
  - `/proc`
  - `/sys`
  - `/var/lib/kubelet`
  - `/etc/kubernetes`
  - `/etc/kubernetes/manifests`
- Runtime socket mounts:
  - Docker
  - containerd
  - CRI-O

### Cgroup and kernel-adjacent signals

- Writable cgroup paths
- Controllers that look rooted or unexpectedly exposed
- eBPF prerequisites such as `CAP_BPF`, `CAP_PERFMON`, or `CAP_SYS_ADMIN`
- Weak `kernel.unprivileged_bpf_disabled` posture

The cgroup and eBPF paths are especially version-sensitive. Report the present preconditions and version clues instead of assuming exploitability.

## Safe Validation Sequence

1. Review manifests or workload spec first.
2. Confirm live mounts with `/proc/1/mountinfo`.
3. Confirm live privileges with `/proc/1/status`.
4. Confirm socket exposure with filesystem inspection and `/proc/net/unix`.
5. If needed, collect kernel or runtime version clues from the host or image metadata.

## Evidence To Capture

- The exact YAML or config line that grants the privilege
- The mounted path or socket path
- The relevant capability hex and decoded names
- The seccomp or AppArmor signal
- The kernel or runtime version clue when discussing cgroup or eBPF-related risk

## Suggested Conclusions

Use one of these phrasings:

- Immediate node-impact risk
- Strong host-interaction risk
- Conditional escape precondition
- Hardening gap with no direct path confirmed

That keeps the review honest and useful.
