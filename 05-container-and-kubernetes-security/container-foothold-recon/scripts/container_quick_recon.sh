#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

section() {
  printf '\n== %s ==\n' "$1"
}

safe_cat() {
  if [ -r "$1" ]; then
    cat "$1"
  else
    printf '[unreadable] %s\n' "$1"
  fi
}

section "Identity"
id || true
uname -a || true

section "Container Hints"
[ -e /.dockerenv ] && ls -l /.dockerenv || printf '/.dockerenv not present\n'
safe_cat /proc/1/cgroup

section "Capabilities And Process Flags"
grep -E '^(Cap(Inh|Prm|Eff|Bnd|Amb)|NoNewPrivs|Seccomp):' /proc/1/status || true

CAP_EFF=$(awk '/^CapEff:/ {print $2}' /proc/1/status 2>/dev/null || true)
if [ -n "${CAP_EFF:-}" ] && command -v python3 >/dev/null 2>&1; then
  printf '\nDecoded CapEff:\n'
  python3 "$SCRIPT_DIR/decode_caps.py" "$CAP_EFF" || true
fi

section "Kubernetes Hints"
env | grep -E '^(KUBERNETES_|KUBE_)' || printf 'No obvious Kubernetes env vars\n'
if [ -d /var/run/secrets/kubernetes.io/serviceaccount ]; then
  ls -l /var/run/secrets/kubernetes.io/serviceaccount || true
  printf '\nnamespace: '
  safe_cat /var/run/secrets/kubernetes.io/serviceaccount/namespace
else
  printf 'No mounted serviceaccount directory\n'
fi

section "DNS"
safe_cat /etc/resolv.conf

section "Runtime Sockets"
for sock in \
  /var/run/docker.sock \
  /run/containerd/containerd.sock \
  /var/run/containerd/containerd.sock \
  /run/crio/crio.sock \
  /var/run/crio/crio.sock
do
  [ -S "$sock" ] && ls -l "$sock"
done

section "Interesting Mounts"
grep -E '/(var/lib/kubelet|etc/kubernetes|etc/kubernetes/manifests|proc|sys)($|/)|docker\.sock|containerd\.sock|crio\.sock' /proc/1/mountinfo || printf 'No obvious high-value mounts matched\n'

section "Unix Sockets Snapshot"
safe_cat /proc/net/unix | grep -E 'docker|containerd|crio|kubelet' || printf 'No matching unix socket names\n'
