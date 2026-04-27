# Publish Checklist

## Before creating the GitHub repo

- Decide whether the repository should be `private` or `public`
- Confirm the repo name you want to use, for example: `shayshen-security-skills`
- Review [NOTICE.md](NOTICE.md)

## Content review

- Check every `SKILL.md` for internal-only paths, system names, usernames, or machine-specific instructions
- Check `references/` for copied third-party content that may need attribution or trimming
- Remove accidental cache files, screenshots, or temporary artifacts
- Keep existing per-skill `LICENSE.txt` files where present

## Suggested repository metadata

- Repository name: `shayshen-security-skills`
- Short description: `A categorized bundle of Codex security skills for smart contracts, web/API testing, privacy compliance, containers, Kubernetes, and security engineering workflows.`
- Topics:
  - `codex`
  - `skills`
  - `security`
  - `smart-contract-security`
  - `api-security`
  - `privacy-compliance`
  - `kubernetes-security`
  - `container-security`
  - `web3`

## Recommended first commit layout

- `README.md`
- `NOTICE.md`
- `PUBLISH_CHECKLIST.md`
- categorized skill directories

## Suggested upload steps

```bash
git init
git add .
git commit -m "Add categorized security skills bundle"
git branch -M main
gh repo create shayshen-security-skills --private --source . --remote origin --push
```

If you want a public repo, replace `--private` with `--public` only after the content and licensing review is complete.
