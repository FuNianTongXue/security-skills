# APIPost Assertion Snippet Library

Use this file when the user wants APIPost post-execution assertions or reusable validation snippets.

These snippets are intentionally simple and grounded in assertion forms already confirmed in official docs, such as:

```javascript
apt.assert('response.raw.status==200');
apt.assert('response.raw.type=="json"');
apt.assert('response.json.errcode==0');
apt.assert('response.raw.responseTime<100');
```

Adjust field names conservatively. Do not invent response properties that the API has not shown.

## Usage Notes

- Prefer one assertion per line.
- Use API-specific field names only when the user has provided them or they are visible in responses.
- If a check needs a field whose existence is not confirmed, describe it as a suggested adaptation instead of a fixed snippet.

---

## 1. Status Code Assertions

### Exact 200

```javascript
apt.assert('response.raw.status==200');
```

### Exact 201

```javascript
apt.assert('response.raw.status==201');
```

### Auth Denied

```javascript
apt.assert('response.raw.status==401||response.raw.status==403');
```

### Object Access Denied or Hidden

```javascript
apt.assert('response.raw.status==403||response.raw.status==404');
```

### Validation Error Range

```javascript
apt.assert('response.raw.status>=400');
apt.assert('response.raw.status<500');
```

### Method Not Allowed

```javascript
apt.assert('response.raw.status==405');
```

### Rate-Limited

```javascript
apt.assert('response.raw.status==429');
```

---

## 2. Content-Type and Basic Response Shape

### Expect JSON

```javascript
apt.assert('response.raw.type=="json"');
```

### Expect XML

```javascript
apt.assert('response.raw.type=="xml"');
```

### Success Baseline

```javascript
apt.assert('response.raw.status==200');
apt.assert('response.raw.type=="json"');
```

---

## 3. Business Field Assertions

Only use these after confirming field names in the actual API.

### Example: `errcode == 0`

```javascript
apt.assert('response.json.errcode==0');
```

### Example: `code == 0`

```javascript
apt.assert('response.json.code==0');
```

### Example: `success == true`

```javascript
apt.assert('response.json.success==true');
```

### Example: message field exists conceptually

Because direct existence helpers are not confirmed in the official docs used for this skill, prefer adapting to concrete known values instead of asserting on undocumented helpers.

---

## 4. Negative Security Assertions

### No Server Error on Negative Test

```javascript
apt.assert('response.raw.status<500');
```

Use this for:

- missing field cases
- malformed body cases
- wrong type cases
- unauthorized access attempts

### Unauthorized Request Should Not Succeed

```javascript
apt.assert('response.raw.status!=200');
```

Use only when the API's success code is known to be `200`.

### Privileged Endpoint Should Not Succeed for Low Privilege User

```javascript
apt.assert('response.raw.status==401||response.raw.status==403||response.raw.status==404');
```

### Replayed Request Should Not Succeed

```javascript
apt.assert('response.raw.status!=200&&response.raw.status!=201');
```

Use only when the replayed baseline was previously observed to succeed with those codes.

---

## 5. Performance and Timing Assertions

Treat timing only as a regression signal, not proof of a vulnerability.

### Fast Response Guard

```javascript
apt.assert('response.raw.responseTime<500');
```

### General Stability Guard

```javascript
apt.assert('response.raw.responseTime<2000');
```

### Rate-Limit Observation Guard

```javascript
apt.assert('response.raw.status==429||response.raw.responseTime<5000');
```

Use carefully and adapt to actual service behavior.

---

## 6. Ready-to-Use Packs

### Baseline Success Pack

```javascript
apt.assert('response.raw.status==200');
apt.assert('response.raw.type=="json"');
apt.assert('response.raw.responseTime<2000');
```

### Authentication Failure Pack

```javascript
apt.assert('response.raw.status==401||response.raw.status==403');
apt.assert('response.raw.status<500');
```

### Validation Failure Pack

```javascript
apt.assert('response.raw.status>=400');
apt.assert('response.raw.status<500');
```

### Object-Level Authorization Failure Pack

```javascript
apt.assert('response.raw.status==403||response.raw.status==404');
apt.assert('response.raw.status<500');
```

---

## 7. Adaptation Rules

When tailoring snippets:

1. Start from status code and content type.
2. Add business-field checks only after a real response confirms field names.
3. Use timing assertions only to guard regression or resilience expectations.
4. Avoid undocumented helpers or deep response traversal patterns unless the user has shown them working in their APIPost environment.

## 8. Anti-Hallucination Rules

1. Do not assume response helper functions exist beyond what the official docs or user environment show.
2. Do not invent `response.json.data.*` fields.
3. Do not infer success schema from endpoint names alone.
4. Do not use timing assertions as evidence of a security flaw.
