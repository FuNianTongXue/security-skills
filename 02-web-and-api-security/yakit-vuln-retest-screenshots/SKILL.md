---
name: yakit-vuln-retest-screenshots
description: Retest authorized web or API vulnerabilities in Yakit, verify step-by-step success criteria, and save reproducible success screenshots plus evidence notes to the Desktop. Use when the user asks to复测漏洞、用 Yakit 重放请求、实际复现成功并截图、整理可提交的截图证据、或把 Yakit 复测结果写回报告。
---

# Yakit Vuln Retest Screenshots

## Overview

Use this skill to drive an authorized Yakit retest from concrete HTTP requests to final screenshot evidence. Favor deterministic, repeatable reproduction over ad hoc clicking.

Only use this skill in local labs or other explicitly authorized environments. Do not use it to probe unapproved targets.

## Workflow

### 1. Lock the reproduction scope

Before touching Yakit:

- Confirm the target is authorized and reproducible.
- Identify the exact vulnerability chain to retest.
- Write down the success condition for each step.
- Reset the lab state first if the vulnerability is stateful.

For every chain, capture:

- Target base URL
- Required headers or tokens
- Step order
- Expected success markers
- Preconditions required for success

If the user already has a formal report, update that report after screenshots are captured.

Read [references/checklist.md](references/checklist.md) before running a retest.

### 2. Prefer direct HTTP reproducibility

Build the reproduction from explicit HTTP requests first. Yakit is the presentation and evidence layer, not the source of truth.

Use a short sequence:

1. Confirm exposure or mode
2. Obtain required token or session
3. Access the sensitive endpoint
4. Trigger the vulnerable action
5. Re-read state to confirm success

Keep one request per screenshot whenever possible.

### 3. Prepare Yakit

If Yakit is already open, bring it to front. If not, start it first.

Useful local checks:

```bash
ps -axo pid,comm | rg 'Yakit'
osascript -e 'tell application "/Applications/Yakit.app" to activate'
osascript -e 'tell application "System Events" to tell process "Yakit" to get {position, size} of front window'
```

If Yakit's accessibility tree is too thin to script reliably, use the bundled coordinate helper instead of fighting the UI tree.

### 4. Use the bundled helper scripts

This skill ships with:

- `scripts/macclick.swift`: low-level macOS click, drag, key, and unicode text input helper
- `scripts/capture_yakit_window.sh`: capture the current Yakit front window region to a PNG

Compile the click helper once per session:

```bash
SWIFT_MODULECACHE_PATH=/tmp/swift-module-cache \
CLANG_MODULE_CACHE_PATH=/tmp/swift-clang-cache \
swiftc scripts/macclick.swift -o /tmp/macclick
```

Bring Yakit frontmost:

```bash
osascript -e 'tell application "/Applications/Yakit.app" to activate'
```

If you need the current Yakit window rectangle:

```bash
osascript -e 'tell application "System Events" to tell process "Yakit" to get {position, size} of front window'
```

Use `/tmp/macclick` to:

- focus the request editor
- select existing request text
- type a raw HTTP request using unicode-safe input
- click the send button

Do not rely on clipboard paste if the target app or input method behaves inconsistently. Prefer the helper's unicode text input path for full HTTP requests.

### 5. Capture screenshots only after success is visible

Do not take screenshots before the success marker is on screen.

Good success markers include:

- a `200` or `201` response with the expected JSON field
- a token being returned
- a sensitive ID or form token being visible
- a state flip such as `submitted:false -> submitted:true`
- a stored file object being created

Use the capture helper or `screencapture -x -R...` to save each screenshot as a numbered file on the Desktop.

Recommended naming:

- `01-...png`
- `02-...png`
- `03-...png`

Keep screenshot names aligned with report step numbers.

### 6. Always produce a minimal evidence bundle

At the end of a retest, make sure the Desktop bundle contains:

- ordered screenshots
- the final report or report draft
- the request pack if one exists
- a short note describing what each screenshot proves

If the user asks for formal submission material, add:

- complete `http://` or `https://` vulnerability links
- preconditions required for success
- success criteria
- impact summary

### 7. Failure handling

If reproduction fails:

- verify the lab state was reset
- verify tokens are fresh
- verify headers still match the target app
- verify deployment prerequisites are still met
- verify Yakit is showing the current request, not an old tab

If the vulnerability is stateful, re-run the reset step before trying again.

## Practical rules

- Prefer local or explicitly authorized targets only.
- Prefer raw HTTP requests over opaque UI-only actions.
- Prefer deterministic success markers over visual guesswork.
- Prefer one screenshot per successful step.
- Include the exact on-screen response that proves success.
- If the report already exists, update it with screenshots, preconditions, and success criteria before finishing.

## Resources

### scripts/

- `scripts/macclick.swift`
- `scripts/capture_yakit_window.sh`

### references/

- `references/checklist.md`
