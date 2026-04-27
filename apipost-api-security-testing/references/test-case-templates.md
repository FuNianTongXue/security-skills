# APIPost API Security Test Case Templates

Use this file when the user wants reusable APIPost-ready security cases instead of a one-off plan.

These templates are designed to stay inside documented APIPost capabilities:

- variables
- pre-execution scripts
- post-execution assertions
- variable extraction
- chained requests
- automated test cases

Do not convert these templates into findings until the behavior is reproduced and evidenced.

## How to Use These Templates

For each template:

1. Replace placeholders with real values from the user, spec, or prior responses.
2. Create or reuse variables for identities, tokens, IDs, timestamps, and signatures.
3. Add assertions for both:
   - expected secure behavior
   - unacceptable insecure behavior
4. Save successful patterns as APIPost automated cases or collections.

Suggested placeholder naming:

- `{{base_url}}`
- `{{token_admin}}`
- `{{token_user_a}}`
- `{{token_user_b}}`
- `{{resource_id_a}}`
- `{{tenant_id_a}}`
- `{{tenant_id_b}}`
- `{{nonce}}`
- `{{timestamp}}`
- `{{signature}}`

---

## 1. Authentication Templates

### AUTH-01 Missing Token

Goal:

- Verify protected endpoints reject unauthenticated requests.

APIPost setup:

- Create a normal authenticated request first.
- Duplicate it and remove `Authorization` or session cookie.

Expected secure behavior:

- `401` or equivalent authenticated-failure response
- no business data returned

Suggested assertions:

```javascript
apt.assert('response.raw.status==401||response.raw.status==403');
```

Evidence to capture:

- request without token
- response code
- body snippet showing denial

### AUTH-02 Invalid Token Format

Goal:

- Verify malformed or obviously invalid tokens are rejected.

Mutation ideas:

- `Authorization: Bearer invalid`
- truncated JWT
- token with modified last segment

Expected secure behavior:

- request rejected
- no fallback to guest access unless endpoint is truly public

### AUTH-03 Expired Token

Goal:

- Verify expired credentials do not remain usable.

Precondition:

- User provides an expired token or a reproducible way to obtain one.

Expected secure behavior:

- explicit auth failure
- no successful data access

### AUTH-04 Replay Candidate

Goal:

- Check whether tokens, nonces, or one-time request elements can be replayed.

APIPost pattern:

- capture a valid value from response
- repeat the same request with identical nonce, timestamp, or signature if the user is authorized to test replay

Expected secure behavior:

- replay rejected or treated safely

Do not guess whether a workflow is intended to be one-time use; confirm from user context or API semantics.

---

## 2. Authorization Templates

### AUTHZ-01 Horizontal Access Control

Goal:

- Check whether User B can access User A's resource.

Workflow:

1. Use `{{token_user_a}}` to create or list a resource.
2. Extract and store `{{resource_id_a}}`.
3. Re-send the fetch or update request with `{{token_user_b}}`.

Typical path examples:

- `/orders/{{resource_id_a}}`
- `/users/{{resource_id_a}}/profile`
- `/documents/{{resource_id_a}}`

Expected secure behavior:

- denial response
- or filtered response with no sensitive content

Suggested assertions:

```javascript
apt.assert('response.raw.status==403||response.raw.status==404');
```

Evidence to capture:

- User A request and extracted ID
- User B replay request
- denied response

### AUTHZ-02 Vertical Access Control

Goal:

- Verify a lower-privilege user cannot invoke admin-only actions.

Mutation ideas:

- call `/admin/*`
- invoke role-management endpoint
- trigger export, delete, or privileged config endpoint using regular token

Expected secure behavior:

- `403` or equivalent denial

### AUTHZ-03 Tenant Boundary Check

Goal:

- Verify one tenant cannot access another tenant's data.

Mutation points:

- path tenant ID
- query tenant ID
- body tenant ID
- header tenant ID

Expected secure behavior:

- request rejected
- or server ignores attacker-supplied tenant and binds to token context

### AUTHZ-04 Method-Level Authorization Drift

Goal:

- Check whether one method is protected while another is not.

Example pattern:

- `GET /resource/{id}` denied
- `PATCH /resource/{id}` unexpectedly allowed

APIPost setup:

- duplicate the same endpoint with different methods
- keep token constant

---

## 3. Input Validation Templates

### INPUT-01 Required Field Omission

Goal:

- Verify missing required fields produce controlled validation failures.

Mutation ideas:

- remove required JSON field
- omit required query param
- omit required header

Expected secure behavior:

- `4xx` validation error
- no `500`
- no stack trace

Suggested assertions:

```javascript
apt.assert('response.raw.status>=400');
apt.assert('response.raw.status!=500');
```

Use a second manual check for leakage if needed. Do not claim leakage from status code alone.

### INPUT-02 Type Confusion

Goal:

- Check whether the API safely handles wrong data types.

Mutation examples:

- number instead of string
- object instead of scalar
- array instead of object
- boolean instead of enum

Expected secure behavior:

- structured validation error
- no server crash

### INPUT-03 Boundary Length

Goal:

- Check overly short, empty, and overly long values.

Test values:

- empty string
- whitespace only
- max length plus one
- very large numeric value where applicable

Expected secure behavior:

- controlled rejection
- no truncation-based privilege or logic anomaly

### INPUT-04 Duplicate Parameter Handling

Goal:

- Check whether duplicate query or body params create ambiguous behavior.

Examples:

- `?role=user&role=admin`
- duplicate JSON-equivalent fields if transport permits

Expected secure behavior:

- deterministic handling
- no privilege escalation or parser confusion

### INPUT-05 Content-Type Mismatch

Goal:

- Check whether the server validates body format against declared content type.

Examples:

- send JSON body as `text/plain`
- send malformed JSON with `application/json`
- send form body with JSON header

Expected secure behavior:

- request rejected or safely parsed

### INPUT-06 Unsupported Method

Goal:

- Verify undefined methods are rejected.

Examples:

- send `PUT` where only `GET/POST` are expected
- send `TRACE` or `OPTIONS` only when authorized and safe to test

Expected secure behavior:

- `405` or controlled rejection

---

## 4. Signature and Anti-Replay Templates

### SIG-01 Valid Signature Baseline

Goal:

- Establish the known-good signed request before doing negative tests.

APIPost pre-execution pattern:

```javascript
let ts = Date.now().toString();
let signBase = request.request_url + ts;
let sig = $.md5(signBase);
apt.setRequestHeader("X-Timestamp", ts);
apt.setRequestHeader("X-Signature", sig);
```

Note:

- Only use script helpers that are documented or shown by the user.
- If the workflow needs the timestamp or signature reused later, store them only through a variable-setting method that is documented for the user's APIPost version.

### SIG-02 Signature Tampering

Goal:

- Verify that changing one signed element breaks verification.

Mutation ideas:

- change one body field after signature generation
- modify timestamp only
- modify query param only

Expected secure behavior:

- request rejected

### SIG-03 Stale Timestamp

Goal:

- Verify expired timestamp windows are enforced when the API uses them.

Precondition:

- timestamp validity exists in the API design or user context

Expected secure behavior:

- stale request rejected

### SIG-04 Reuse of Nonce

Goal:

- Verify one-time nonce or anti-replay value is not accepted twice.

Workflow:

1. Send valid signed request.
2. Re-send same nonce and signature if the API model says nonce should be single use.

Expected secure behavior:

- second request denied or safely ignored

---

## 5. Response Hardening Templates

### RESP-01 No Stack Trace Leakage

Goal:

- Ensure validation failures and server-side errors do not expose stack traces.

Trigger methods:

- malformed JSON
- missing required field
- unexpected enum

Things to check manually or with assertions:

- no exception class names
- no framework stack traces
- no file system paths

### RESP-02 Sensitive Field Exposure

Goal:

- Ensure non-admin or unrelated callers do not receive sensitive fields.

Field examples:

- password hash
- secret key
- internal role metadata
- token internals
- hidden flags

Assertion idea:

- confirm absence of known sensitive key names when user provides them

### RESP-03 Security Header Observation

Goal:

- Observe whether expected security-related response headers are present where applicable.

Examples:

- `Cache-Control`
- `Set-Cookie` attributes
- API gateway or trace headers that should or should not appear

Note:

- Do not invent header requirements for every API. Anchor checks to the user's standard or the API contract.

---

## 6. Workflow and State Templates

### FLOW-01 Login -> Extract -> Use Token

Goal:

- Build the baseline authenticated chain.

APIPost usage:

1. send login request
2. extract token from JSON or header
3. save token to environment or temporary variable
4. call protected endpoint

This is the base chain that many other tests depend on.

### FLOW-02 Create -> Extract ID -> Access with Another Identity

Goal:

- Build a reusable object-level authorization chain.

APIPost usage:

1. create object as User A
2. extract ID
3. access with User B
4. assert denial

### FLOW-03 Multi-Step Signed Workflow

Goal:

- Build a chain for APIs that require nonce, challenge, or preflight state.

APIPost usage:

1. pre-execution request obtains state
2. extract challenge or nonce
3. generate signature
4. send business request
5. assert success or denial depending on the case

---

## 7. Rate-Limit and Resilience Observation Templates

Only use these when the user explicitly requests them and the APIPost client version supports the documented performance testing feature.

### PERF-01 Throttling Observation

Goal:

- Observe whether repeated requests activate expected throttling.

Expected secure behavior:

- controlled `429` or equivalent throttling signal
- stable rejection instead of service failure

### PERF-02 Abuse-Control Observation by Identity

Goal:

- Check whether throttling is applied per token, IP context, or route as expected.

Use carefully:

- keep traffic bounded
- stay within authorization and agreed test limits

Do not describe this as a DoS exercise.

---

## 8. Assertion Snippet Library

These are starting points only. Adjust per API.

### Denial Check

```javascript
apt.assert('response.raw.status==401||response.raw.status==403||response.raw.status==404');
```

### No Server Error on Negative Case

```javascript
apt.assert('response.raw.status<500');
```

### JSON Success Baseline

```javascript
apt.assert('response.raw.status==200');
apt.assert('response.raw.type=="json"');
```

### Basic Timing Guard

```javascript
apt.assert('response.raw.responseTime<2000');
```

Use timing checks only as regression signals, not as proof of a security flaw.

---

## 9. Evidence Checklist

For every template that produces a suspected issue, capture:

- target endpoint and method
- auth context used
- exact mutated input
- extracted variables involved
- full response code
- key response snippet
- assertion result
- reproduction count
- whether the observed behavior is confirmed, inconsistent, or still hypothesis
