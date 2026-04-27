---
name: apipost-api-security-testing
description: Use when the user wants to use APIPost for authorized API security testing, evidence collection, or repeatable request workflows involving authentication, access control, input validation, header/body tampering, assertions, variables, or automated API test cases. Only rely on APIPost features confirmed in official APIPost docs or explicitly shown by the user; never invent unsupported scanners, fuzzers, or automation capabilities.
---

# APIPost API Security Testing

Use this skill when the user wants to perform API security testing with APIPost itself, not with a generic testing stack.

This skill is intentionally conservative:

- Use only APIPost capabilities that are confirmed in official docs or directly shown by the user.
- Treat APIPost as a request orchestration, scripting, variable, assertion, and automated test tool.
- Do not describe APIPost as having built-in vulnerability scanning, crawler discovery, passive scanning, or exploit detection unless the user provides current evidence for that exact feature.

## Before You Start

1. Confirm the test is authorized and in scope.
2. Confirm the target protocol and workflow are actually supported by APIPost in the available docs and user environment.
3. Read [references/official-capabilities.md](references/official-capabilities.md) before claiming a feature exists or giving APIPost-specific steps.
4. Read [references/test-case-templates.md](references/test-case-templates.md) when the user wants reusable APIPost security cases or a ready-made test pack.
5. Read [references/openapi-mapping.md](references/openapi-mapping.md) when the user provides an OpenAPI or Swagger description and wants to map endpoints to APIPost security templates.
6. Read [references/assertion-snippets.md](references/assertion-snippets.md) when the user wants APIPost assertion examples or post-execution checks.
7. Read [references/report-template.md](references/report-template.md) when the user wants a deliverable report, evidence summary, or retest output format.

If the user asks for an APIPost workflow that is not supported by the official docs you have, say that clearly and offer the closest documented alternative.

## Core Workflow

### 1. Build a Testable API Model

Collect the minimum inputs needed for a grounded APIPost workflow:

- Base URL and environments
- Authentication model
- Endpoints and methods
- Required headers, query params, and body schemas
- Test identities and roles that the user is authorized to use
- Expected success and failure behaviors

When available, reuse user-provided:

- OpenAPI or Swagger specs
- cURL samples
- APIPost project exports
- Existing screenshots of APIPost UI

Do not invent endpoints, tokens, roles, or request fields.

### 2. Map Security Goals to Documented APIPost Features

Use APIPost features in these grounded ways:

- Variables: store base URLs, tokens, IDs, and chained values
- Pre-execution scripts: derive signatures, mutate params, send prerequisite requests when documented
- Post-execution assertions: validate status, body fields, headers, cookies, and response times
- Variable extraction: capture tokens, IDs, nonces, or workflow state from prior responses
- Automated tests: turn repeated security checks into reusable cases
- Optional performance testing: only when the user explicitly wants rate-limit or resilience observation and the APIPost client version supports it

### 3. Execute Security Test Categories

#### Authentication and Session Handling

Use APIPost to verify:

- Missing token behavior
- Expired token behavior
- Invalid signature behavior
- Cookie and header combinations
- Replay of previously captured tokens or request elements, if the user is authorized to test that scenario

APIPost patterns:

- Environment or global variables for token swapping
- Pre-execution scripts for timestamp, nonce, or signature generation
- Assertions for expected `401`, `403`, redirect, or error body behavior

#### Authorization and Access Control

Use APIPost to compare authorized identities the user already has:

- User A token accessing User B resource
- Low-privilege token invoking admin-only route
- Object ID substitution in path, query, or body
- Missing tenant or scope boundary checks

APIPost patterns:

- Separate environments or variables per role
- Chained requests that extract one role's object ID and attempt access with another role's token
- Assertions that sensitive data must not be returned

Do not fabricate identities or recommend bypass techniques beyond authorized comparative request testing.

#### Input Validation and Request Tampering

Use APIPost to send controlled negative cases such as:

- Missing required fields
- Wrong field types
- Boundary lengths
- Empty strings and nulls
- Duplicate parameters
- Unexpected enum values
- Malformed JSON or XML
- Content-Type mismatch
- Unsupported HTTP methods
- Header tampering

APIPost patterns:

- Manual body edits
- Pre-execution script changes to query, body, or headers when documented
- Assertion checks for status code, validation message, and server error leakage

#### Response Hardening Checks

Use post-execution assertions to verify:

- Status code correctness
- No stack traces or debug leakage
- No sensitive fields in body
- Expected security headers when applicable
- Response time thresholds for basic regression checks

Use APIPost assertions for evidence. Do not claim a finding is confirmed until the response and assertion output support it.

#### Stateful Workflow Testing

Use variable extraction and chained requests for workflows such as:

- Login -> token extraction -> privileged endpoint
- Create -> capture object ID -> fetch -> update -> delete
- Obtain nonce -> sign request -> submit

This is especially useful for testing authorization drift, object ownership checks, and workflow-dependent security controls.

### 4. Record Evidence

For each suspected issue, capture:

- Request method and path
- Relevant headers and body deltas
- Variables used
- Response code and key response fields
- Assertion result
- Whether the behavior reproduced consistently

Prefer APIPost-native evidence such as:

- Saved interface cases
- Automated test cases
- Assertion results
- Extracted variable traces
- Screenshots the user provides from APIPost UI when needed

### 5. Report Conservatively

When reporting findings:

- Separate confirmed behavior from hypothesis
- State the exact APIPost steps used
- Name which parts came from official APIPost features and which came from user-supplied API knowledge
- If a result depends on an unverified APIPost capability, stop and say so instead of guessing

## APIPost Feature Boundaries

Read [references/official-capabilities.md](references/official-capabilities.md) when you need exact, source-backed feature boundaries.

The skill may rely on these documented capability families:

- Pre-execution and post-execution operations
- Script-based assertions
- Variable extraction
- Environment and global variables
- Script-based request mutation
- Pre-script request sending with `await $.ajax`
- Automated tests
- Optional client-side performance testing

## Reusable Test Templates

For concrete, reusable APIPost cases, read:

- [references/test-case-templates.md](references/test-case-templates.md)

Use those templates when the user asks for:

- a reusable APIPost security checklist
- a batch of negative cases
- authentication or authorization regression packs
- request signature or replay templates
- input validation and error-handling coverage

When adapting a template:

1. Replace placeholder paths, IDs, headers, and variables with only user-provided or documented values.
2. Keep the expected result conservative until confirmed by a real response.
3. Save the resulting request and assertion set as a repeatable APIPost case when the workflow is stable.

## OpenAPI Mapping

For spec-driven test planning, read:

- [references/openapi-mapping.md](references/openapi-mapping.md)

Use it when the user provides:

- an OpenAPI or Swagger file
- a Postman or cURL export that clearly represents the API contract
- a list of endpoints and wants them mapped to APIPost security cases

## Assertion Snippets

For concrete APIPost post-execution checks, read:

- [references/assertion-snippets.md](references/assertion-snippets.md)

Use it when the user asks for:

- assertion code examples
- response validation checks
- reusable post-execution snippet packs

## Reporting

For a structured output format, read:

- [references/report-template.md](references/report-template.md)

Use it when the user asks for:

- a test report
- a retest report
- evidence output
- a reusable reporting template

## Anti-Hallucination Rules

These rules are mandatory for this skill:

1. Never say APIPost has a built-in API vulnerability scanner unless the user provides current proof.
2. Never say APIPost has crawler-based asset discovery unless the user provides current proof.
3. Never claim APIPost automatically detects SQL injection, SSRF, deserialization, auth bypass, or business logic flaws.
4. Never assume undocumented script APIs exist. If a needed API is not in the official docs you have, label it unverified.
5. Never convert AI-generated cases into findings without validating them with actual APIPost requests and assertions.
6. Never fabricate exact UI buttons, menu names, or version behavior when the docs or user screenshots do not confirm them.
7. If APIPost version differences matter, call that out explicitly and anchor to the documented version note when one exists.

## When to Refuse or Narrow the Task

Narrow the workflow if the user asks for APIPost steps that require unverified features.

Examples:

- If the user asks for "use APIPost's built-in scanner", first confirm that scanner exists in the official docs you have.
- If the user asks for browser-driven auth flows inside APIPost and you do not have docs for that, say it is unverified.
- If the user asks for mass-abuse or destructive traffic, keep the workflow within authorized, bounded API testing.

## Minimal APIPost Security Testing Patterns

### Pattern A: Token swap access-control test

1. Store `token_user_a` and `token_user_b` in environment variables.
2. Send a request as User A to create or fetch a resource and extract the object ID.
3. Reuse the object ID with User B's token.
4. Assert that the second request is denied or returns no sensitive data.

### Pattern B: Signature and nonce test

1. In a pre-execution script, derive nonce, timestamp, or signature using documented scripting capabilities.
2. Send a valid request and assert success.
3. Modify one signed field or replay the signature with stale values.
4. Assert the request is rejected.

### Pattern C: Input validation regression pack

1. Build a set of negative cases around required fields, type confusion, empty values, and length boundaries.
2. Save them as automated test cases.
3. Assert no `500` responses, no stack traces, and correct validation messages or status codes.

### Pattern D: Rate-limit observation

Only if the user explicitly requests it and the client supports performance testing:

1. Start with small, authorized load.
2. Observe status codes, response times, and failure counts.
3. Check whether documented throttling or abuse protections activate.

Do not frame this as a denial-of-service workflow.

## Output Expectations

When using this skill, produce:

- A documented APIPost test plan tied to real endpoints and roles
- Exact APIPost feature usage steps
- Assertions and variable strategy
- Clear evidence requirements
- Explicit notes about any unverified APIPost capability the user asked about
