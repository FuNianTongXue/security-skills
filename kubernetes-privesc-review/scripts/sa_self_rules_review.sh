#!/usr/bin/env sh
set -eu

SA_DIR=/var/run/secrets/kubernetes.io/serviceaccount

if [ ! -d "$SA_DIR" ]; then
  printf 'serviceaccount directory not found: %s\n' "$SA_DIR" >&2
  exit 1
fi

if [ -z "${KUBERNETES_SERVICE_HOST:-}" ]; then
  printf 'KUBERNETES_SERVICE_HOST is not set\n' >&2
  exit 1
fi

TOKEN=$(cat "$SA_DIR/token")
CA="$SA_DIR/ca.crt"
DEFAULT_NS=$(cat "$SA_DIR/namespace")
NAMESPACE=${1:-$DEFAULT_NS}
PORT=${KUBERNETES_SERVICE_PORT:-443}
URL="https://${KUBERNETES_SERVICE_HOST}:${PORT}/apis/authorization.k8s.io/v1/selfsubjectrulesreviews"
BODY=$(printf '{"kind":"SelfSubjectRulesReview","apiVersion":"authorization.k8s.io/v1","spec":{"namespace":"%s"}}' "$NAMESPACE")

printf 'Requesting effective rules for namespace: %s\n' "$NAMESPACE" >&2

RESPONSE=$(curl -sS --fail --cacert "$CA" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Content-Type: application/json' \
  -X POST \
  -d "$BODY" \
  "$URL")

if command -v python3 >/dev/null 2>&1; then
  printf '%s' "$RESPONSE" | python3 -m json.tool
else
  printf '%s\n' "$RESPONSE"
fi
