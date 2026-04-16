# OpenAPI to APIPost Security Mapping Rules

Use this file when the user provides an OpenAPI or Swagger document and wants a grounded APIPost security test plan.

This file does not assume APIPost automatically generates security coverage from the spec. Instead, it explains how to map API contract elements into APIPost request cases and reusable security templates.

## Goal

Turn a documented API contract into:

- a prioritized APIPost request list
- security test cases mapped per endpoint
- variables and chaining strategy
- assertion coverage

## Inputs to Extract from the Spec

For each operation, extract:

- path
- method
- operationId if present
- tags or module grouping
- authentication requirement
- path parameters
- query parameters
- header parameters
- request body schema
- response codes and schemas
- examples
- object ownership hints
- tenant or scope hints

Do not invent semantics that are not in the spec. If ownership or role behavior is not documented, mark it as a hypothesis and ask the user to confirm only if necessary.

## Mapping Workflow

### 1. Group Endpoints by Security Shape

Group operations into categories such as:

- public read
- authenticated read
- authenticated write
- admin or privileged operation
- object-scoped operation
- tenant-scoped operation
- login or token endpoint
- signed request endpoint
- file upload or binary endpoint

This helps choose templates quickly.

### 2. Identify High-Risk Endpoints First

Prioritize endpoints involving:

- authentication
- token issuance or refresh
- password reset
- user or role management
- payment or order changes
- export or bulk actions
- object fetch/update/delete by ID
- tenant-switching or cross-scope headers
- callback, webhook, or signed request flows

### 3. Map Each Endpoint to a Template Family

| Endpoint shape | Primary templates | Secondary templates |
| --- | --- | --- |
| Login or token issuance | `AUTH-01` `AUTH-02` `AUTH-03` | `FLOW-01` |
| Object read by ID | `AUTHZ-01` | `RESP-02` |
| Object update or delete by ID | `AUTHZ-01` `AUTHZ-04` | `INPUT-01` `INPUT-02` |
| Admin endpoint | `AUTHZ-02` | `RESP-02` |
| Tenant-aware endpoint | `AUTHZ-03` | `RESP-02` |
| Signed request endpoint | `SIG-01` `SIG-02` `SIG-03` `SIG-04` | `FLOW-03` |
| Create endpoint | `INPUT-01` `INPUT-02` `INPUT-03` | `FLOW-02` |
| Search or list endpoint | `INPUT-04` `INPUT-05` | `RESP-03` |
| File upload endpoint | `INPUT-05` `INPUT-03` | `RESP-01` |

Template identifiers refer to [test-case-templates.md](test-case-templates.md).

## Per-Operation Planning Format

Use this format when turning spec items into APIPost tasks:

```markdown
### `GET /orders/{orderId}`

- Security shape: authenticated object-scoped read
- Inputs:
  - path: `orderId`
  - auth: bearer token
  - success: `200`
  - expected denial: `403` or `404`
- APIPost variables:
  - `{{token_user_a}}`
  - `{{token_user_b}}`
  - `{{order_id_a}}`
- Primary templates:
  - `AUTHZ-01`
- Assertions:
  - denial for cross-user access
  - no sensitive data exposure
- Evidence:
  - request as User A
  - extracted `order_id_a`
  - request as User B
  - denial response
```

## Variable Strategy from OpenAPI

Derive variables from the contract:

- Base environment:
  - `{{base_url}}`
- Auth:
  - `{{token_admin}}`
  - `{{token_user_a}}`
  - `{{token_user_b}}`
- Resource IDs:
  - `{{user_id_a}}`
  - `{{order_id_a}}`
  - `{{document_id_a}}`
- Multi-tenant context:
  - `{{tenant_id_a}}`
  - `{{tenant_id_b}}`
- Signature flow:
  - `{{timestamp}}`
  - `{{nonce}}`
  - `{{signature}}`

Only create variables that correspond to real API elements or workflow outputs.

## Authentication Mapping Rules

Look for security schemes in the spec:

- bearer auth
- API key in header
- API key in query
- cookie auth
- OAuth scopes

Then map to APIPost cases:

- missing credential
- invalid credential
- wrong-scope credential
- stale credential if applicable

If the spec defines scopes but not role behavior, note that scope mismatch tests are contract-based while role mismatch tests may need user clarification.

## Authorization Mapping Rules

When the spec exposes identifiers like:

- `/users/{id}`
- `/orders/{orderId}`
- `/files/{fileId}`

assume these are candidates for object-level access checks and apply `AUTHZ-01` unless the endpoint is explicitly public.

When the spec contains:

- `/admin/*`
- `/roles/*`
- `/tenants/*`
- `/internal/*`

prioritize vertical and tenant-boundary checks.

## Input Validation Mapping Rules

Map parameter types to negative cases:

- `required: true`
  -> omission tests
- `type: integer`, `type: boolean`, `type: object`
  -> type confusion tests
- `enum`
  -> unexpected enum tests
- `minLength`, `maxLength`, `minimum`, `maximum`
  -> boundary tests
- `format`
  -> malformed format tests

If the spec lacks constraints, do not invent exact numeric limits. Use generic negative tests such as null, empty, wrong type, or malformed structure.

## Response Mapping Rules

Map documented responses into APIPost assertions:

- expected success code
- expected auth failure code
- expected validation error code
- expected content type
- required response fields

Also derive security observations:

- whether sensitive fields should be absent
- whether error responses should be structured
- whether undocumented `500` behavior should never appear

## Recommended APIPost Collection Structure

Organize APIPost requests like this:

1. `00-auth-baselines`
2. `01-role-contexts`
3. `10-object-access-control`
4. `20-input-validation`
5. `30-signature-and-replay`
6. `40-response-hardening`
7. `50-rate-limit-observation`

Within each folder:

- keep one baseline request
- add duplicated negative variants
- keep assertions local to each case

## Output Format for Spec-Driven Planning

When using this file, produce:

- a short summary of API security shapes
- the highest-risk endpoints first
- a mapping table from operation to APIPost template
- variables required
- any assumptions or missing contract details

## Anti-Hallucination Rules

1. Do not infer hidden endpoints from naming patterns alone.
2. Do not assume the documented auth scheme is the only enforcement mechanism.
3. Do not infer exact admin roles or tenant logic if the spec does not define them.
4. Do not invent response schemas for undocumented error cases.
5. Do not claim APIPost can import and auto-generate this security coverage unless the user has shown that feature in their environment.
