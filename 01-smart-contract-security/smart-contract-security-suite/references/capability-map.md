# Capability Map

This skill merges the intent of Trail of Bits `building-secure-contracts` into one Codex-first router.

## Routing Table

| User intent | Use this mode | Focus |
|---|---|---|
| "Scan this chain/project for vulns" | Vulnerability Scan | Chain-specific bug classes |
| "Prepare for audit" | Audit Prep | Checklist, docs, tool readiness |
| "Assess maturity" | Code Maturity | Structured scorecard and gaps |
| "Review upgradeability / proxy / delegatecall" | Guidelines | Architecture and implementation risks |
| "Do a pre-release security pass" | Secure Workflow | End-to-end security validation |
| "Review weird ERC20 / token integration" | Token Integration | Non-standard token behaviors and assumptions |

## Platform Mapping

| Platform | Main scan focus |
|---|---|
| Algorand / TEAL / PyTeal | rekey, fee validation, grouped transaction assumptions |
| Cairo / StarkNet | arithmetic, reentrancy, initialization, auth |
| Cosmos SDK / CosmWasm / IBC / Cosmos EVM | state validation, IBC, privilege boundaries, rounding |
| Solana / Anchor | CPI, PDA validation, signer/owner/sysvar checks |
| Substrate / FRAME | origin validation, weight, panic/overflow, unsigned tx |
| TON / FunC / Tact | replay, sender validation, gas forwarding |
| EVM tokens / integrations | weird ERC20/ERC721 behavior, admin powers, transfer assumptions |

## Output Expectations

- Always distinguish confirmed findings from review leads.
- Always include `file:line` evidence when you claim a code issue.
- If a chain is unsupported or mixed, say so explicitly and narrow scope instead of hallucinating.
- When the user asks broadly, prioritize attack surface and privilege boundaries before lower-risk style guidance.
