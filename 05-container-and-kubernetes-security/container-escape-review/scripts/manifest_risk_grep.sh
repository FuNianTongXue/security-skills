#!/usr/bin/env sh
set -eu

TARGET=${1:-.}

run_search() {
  label=$1
  pattern=$2
  printf '\n== %s ==\n' "$label"
  if command -v rg >/dev/null 2>&1; then
    rg -n -H -S \
      --glob '*.yml' \
      --glob '*.yaml' \
      --glob '*.json' \
      --glob '*.tf' \
      --glob '*.tpl' \
      --glob '*.tmpl' \
      --glob '*.sh' \
      --glob 'Dockerfile*' \
      "$pattern" "$TARGET" || true
  else
    grep -RInE "$pattern" "$TARGET" || true
  fi
}

run_search "Privileged Containers" 'privileged:[[:space:]]*true'
run_search "Privilege Escalation" 'allowPrivilegeEscalation:[[:space:]]*true'
run_search "Host Namespace Sharing" 'host(PID|IPC|Network):[[:space:]]*true'
run_search "Root Execution Hints" 'runAsUser:[[:space:]]*0|runAsNonRoot:[[:space:]]*false'
run_search "Dangerous Capabilities" 'SYS_ADMIN|SYS_PTRACE|DAC_READ_SEARCH|BPF|PERFMON|SYS_MODULE'
run_search "Sensitive Host Paths" '/var/run/docker\.sock|containerd\.sock|crio\.sock|/var/lib/kubelet|/etc/kubernetes/manifests|/etc/kubernetes|/proc|/sys'
run_search "Seccomp Or AppArmor" 'seccompProfile|apparmor\.security\.beta\.kubernetes\.io|Unconfined'
