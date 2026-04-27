# Runtime Risk Matrix

- `privileged: true`
  - Impact: Broad host interaction and frequent node-compromise potential
  - Safe validation: Manifest review plus `/proc/1/status` and mount inspection
  - Notes: Usually the clearest single red flag

- Sensitive `hostPath`
  - Impact: Host filesystem, kubelet state, or static manifest interaction
  - Safe validation: Confirm the exact host path and mount mode
  - Notes: `/etc/kubernetes/manifests` and `/var/lib/kubelet` deserve extra attention

- Runtime socket exposure
  - Impact: Control over sibling containers or host runtime actions depending on auth model
  - Safe validation: Confirm the mounted socket path and whether the process can access it
  - Notes: Socket presence alone is already high signal

- Dangerous capabilities
  - Impact: Varies by capability; some enable tracing, filesystem bypass, or kernel-adjacent workflows
  - Safe validation: Decode `CapEff` and map only the bits actually present
  - Notes: `SYS_ADMIN` is broad, but narrower capabilities can still matter a lot

- `hostPID` or similar namespace sharing
  - Impact: Greater host process visibility and operational abuse potential
  - Safe validation: Compare process visibility and namespace clues
  - Notes: Often paired with observability or security-agent workloads

- eBPF prerequisites
  - Impact: Potential kernel-adjacent abuse or observability interference
  - Safe validation: Check capability set, kernel posture, and whether tracefs or perf interfaces are reachable
  - Notes: Keep conclusions version-aware

- Cgroup controller anomalies
  - Impact: Historical and version-dependent escape families
  - Safe validation: Inspect mounted controllers and runtime/kernel support mismatches
  - Notes: Report as a precondition unless you have current proof
