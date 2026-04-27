# Yakit Retest Checklist

Use this checklist before and after every authorized Yakit retest.

## Before retesting

- Confirm the target is authorized.
- Confirm the environment is the intended lab or approved host.
- Identify whether the vulnerability is stateful.
- Reset the affected state if needed.
- Write down the exact success condition for each step.
- Decide the screenshot file names before starting.

## During retesting

- Keep one request per screenshot when possible.
- Wait until the expected response is visible before capturing.
- Record the exact token, ID, or changed field that proves success.
- Re-read state after the write action if the chain requires proof of persistence.

## After retesting

- Verify screenshots are in chronological order.
- Verify screenshot names match report step numbers.
- Add the exact `http://` or `https://` links used in reproduction.
- Add vulnerability preconditions.
- Add success criteria.
- Add impact and remediation notes if the report needs them.

## Common success markers

- `{"accessMode":"public"}`
- `{"access_token":"..."}`
- `form_token`
- `submitted:false`
- `submitted:true`
- `file_type`
- `file_length`
- `201 CREATED`
- file object `id`
