---
name: smart-contract-security-suite
description: 基于 Trail of Bits building-secure-contracts 的 Codex 版智能合约安全工作台。Use when auditing Solidity, Vyper, Solana, Move, TON, Cosmos, or Algorand contracts; running blockchain-specific vulnerability scans; preparing for audit; assessing code maturity; reviewing upgradeability, proxy patterns, token integrations, or secure development workflows.
---

# Smart Contract Security Suite

面向 Codex 的智能合约安全总入口。它把 Trail of Bits `building-secure-contracts` 里的多条能力线整合成一个更容易触发和执行的工作台。

先读 [references/capability-map.md](references/capability-map.md) 来决定当前任务属于哪一种模式，再执行对应分析。

## 何时使用

当用户在做下面这些事时使用本 skill：

- 审计 Solidity、Vyper、Solana、Move、TON、Cosmos、Algorand 合约
- 需要按链/框架扫描常见漏洞模式
- 想做审计前准备、清单梳理、文档补全
- 想评估代码成熟度、测试质量、安全工程成熟度
- 想审查升级代理、`delegatecall`、权限结构、事件覆盖、依赖与测试
- 想分析 Token 实现或集成里的奇怪 ERC20/ERC721 行为
- 想在发版前做一次系统化的 secure workflow check

## 不要这样用

下列场景不要把它当成唯一工具：

- 只想做入口点梳理时：优先用 `$smart-contract-entry-points`
- 只想做 PoC/利用链编写时：这个 skill 不负责 exploit 开发
- 非智能合约项目：不要强行套用

## 工作方式

### 1. 先识别目标链和任务类型

优先确认：

- 语言和框架：`sol`, `vy`, `rs`, `move`, `fc`, `func`, `tact`, `teal`, `pyteal`
- 项目目标：找漏洞、做审计准备、看升级/代理、评估成熟度、查 token 集成
- 分析范围：全仓库还是某个目录

优先用快速本地探测：

- `rg --files -g '*.sol' -g '*.vy' -g '*.rs' -g '*.move' -g '*.fc' -g '*.func' -g '*.tact'`
- `rg -n "pragma solidity|contract |interface |library |module |entry fun|#[program]|cosmwasm|delegatecall|proxy|onlyOwner|AccessControl"`

### 2. 选择模式

按用户意图选择一种主模式，不要把所有模式都机械跑一遍：

- 漏洞扫描：选择对应链的 vulnerability scan 模式
- 审计前准备：选择 audit prep 模式
- 架构/最佳实践/升级/代理：选择 guidelines 模式
- 成熟度评分：选择 code maturity 模式
- 持续检查或上线前核查：选择 secure workflow 模式
- Token 实现或集成：选择 token integration 模式

如果用户表述很宽泛，默认顺序是：

1. 先做范围和平台识别
2. 再做入口点或权限面梳理
3. 最后做链特定漏洞与治理/升级检查

### 3. 能用工具时优先用工具

如果是 Solidity，先检查本地工具：

```bash
which slither
```

如果存在，优先结合：

```bash
slither . --checklist
slither . --print inheritance-graph
slither . --print contract-summary
```

如果工具不可用，就退回代码级人工分析，但必须明确说明是手工结论还是工具结论。

### 4. 输出要以“可执行结论”为主

输出不要停留在泛泛最佳实践。至少要给出：

- 结论摘要
- 证据位置：`file:line`
- 风险或缺口为什么重要
- 修复方向
- 测试或验证建议

当用户明确要求 review 时，把“问题/风险/回归点”放在最前面。

## 各模式的执行准则

### A. Vulnerability Scan

根据平台选择对应攻击面：

- Algorand：rekey、fee、group、closing、时间相关检查
- Cairo/StarkNet：算术安全、重入、初始化、权限
- Cosmos/CosmWasm/IBC/EVM on Cosmos：状态校验、金额/舍入、IBC、跨模块权限
- Solana：任意 CPI、PDA 校验、signer/owner/sysvar 检查
- Substrate：origin、weight、panic/overflow、unsigned tx
- TON：replay、sender 校验、forward gas 处理

### B. Audit Prep

确认这些基础项是否到位：

- 构建和测试说明是否清晰
- 作用域是否明确
- 依赖和 commit 是否可冻结
- 关键流程、角色和术语是否有文档
- 静态分析和 lint 是否已经先清理明显问题

### C. Guidelines

重点看：

- 架构边界和链上/链下分工
- 升级策略和代理模式
- `delegatecall` 或存储布局风险
- 函数职责是否过大
- 继承和事件设计是否清晰
- 常见安全坑是否被系统检查过

### D. Code Maturity

按成熟度给出带证据的评价，至少覆盖：

- 算术安全
- 认证与权限
- 复杂度
- 文档
- 测试与验证
- 低级操作风险
- 交易顺序或治理类风险

### E. Secure Workflow

适合“上线前/迭代中例行检查”。优先组织成 5 步：

1. 已知安全问题扫描
2. 特殊特性检查：升级、ERC/接口一致性、token 集成
3. 可视化和结构梳理
4. 安全属性与测试策略
5. 手工高风险点复核

### F. Token Integration

重点排查：

- ERC20/ERC721 标准一致性
- fee-on-transfer、rebasing、blacklist、pause、mint/burn 等非标准行为
- 集成方是否假设转账返回值或金额行为“永远标准”
- owner 或 governance 特权是否破坏集成方假设

## 输出模板

默认使用和用户语言一致的报告。推荐结构：

```markdown
# Smart Contract Security Review: [project]

## Summary
- Platform / framework:
- Scope:
- Primary mode:
- Highest-risk areas:

## Findings
| Severity | Area | Location | Why it matters | Fix direction |

## Coverage Gaps
- Missing tests:
- Missing docs:
- Areas needing manual verification:

## Next Actions
1. ...
2. ...
3. ...
```

## 协同建议

以下组合最有价值：

- 入口面不清楚：先用 `$smart-contract-entry-points`
- 想看升级/权限风险：先梳理 entry points，再做 guidelines
- 上线前总检：先做 secure workflow，再补 token integration 或 maturity

## 来源

该 skill 改编自 Trail of Bits `building-secure-contracts` 插件。原始概览保存在 [references/trailofbits-building-secure-contracts-readme.md](references/trailofbits-building-secure-contracts-readme.md)。
