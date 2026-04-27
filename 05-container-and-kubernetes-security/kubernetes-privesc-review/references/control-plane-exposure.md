# Control Plane Exposure Notes

Use this reference when the likely issue is not the application container itself, but a nearby Kubernetes control component or API surface.

## API Server

- Why it matters:
  - It is the main cluster control surface
- Safe validation:
  - Confirm reachability, TLS, and whether credentials are required
  - Review kubeconfigs and certs before assuming anonymous access
- Evidence:
  - Listening address, auth mode clues, kubeconfig material, reachable version or health responses

## kubelet

- Why it matters:
  - It bridges workload control and node execution
- Safe validation:
  - Review kubelet config for anonymous auth or weak authz posture
  - Confirm exposed ports and whether requests are gated
- Evidence:
  - Port exposure, config snippets, reachable read-only or authenticated endpoints

## Dashboard

- Why it matters:
  - UI access may inherit powerful backend rights if misbound
- Safe validation:
  - Confirm whether skip-login is enabled and what service account backs the session
- Evidence:
  - Login mode, service account binding, reachable namespace or cluster actions

## etcd

- Why it matters:
  - It stores cluster state and often highly sensitive data
- Safe validation:
  - Confirm listening scope and transport security
  - Prefer config review and certificate inspection first
- Evidence:
  - Bind address, TLS posture, accessible keyspace metadata if already authorized

## Docker Remote API

- Why it matters:
  - Runtime control can become node impact quickly
- Safe validation:
  - Confirm whether the TCP listener exists and whether it is protected
- Evidence:
  - Listener config, service unit, or safe read-only banner responses

## kubectl proxy

- Why it matters:
  - It can expose API server capabilities through a locally started proxy
- Safe validation:
  - Confirm bind address and intended audience
- Evidence:
  - Process args, listening port, and proxy scope

## Reporting Tip

When these components are exposed, report both:

- The exposure itself
- The currently confirmed privilege level behind the exposure

That distinction keeps the finding accurate and actionable.
