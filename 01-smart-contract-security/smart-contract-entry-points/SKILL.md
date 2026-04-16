---
name: smart-contract-entry-points
description: 基于 Trail of Bits entry-point-analyzer 的 Codex 版状态变更入口点分析 skill。Use when auditing Solidity, Vyper, Solana, Move, TON, or CosmWasm contracts and you need to identify state-changing externally callable functions, classify access control, map privileged operations, or build an audit attack-surface report.
---

# Smart Contract Entry Points

把智能合约代码库里所有“会改状态”的可外部调用入口点系统化找出来，并按访问级别分类，帮助后续安全审计建立真正的攻击面地图。

原始 Trail of Bits README 保存在 [references/trailofbits-entry-point-analyzer-readme.md](references/trailofbits-entry-point-analyzer-readme.md)。

## 何时使用

- 开始审计一个新的智能合约项目
- 想知道哪些函数真的能改状态
- 想梳理 public、owner/admin、governance、guardian、callback 等权限面
- 想先画出攻击面，再继续做漏洞分析

## 核心范围

只关注“状态变更入口点”，默认排除只读逻辑：

- Solidity: `view`, `pure`
- Vyper: `@view`, `@pure`
- Solana: 没有可变账户上下文的只读路径
- Move: 非 `entry` 的模块内部可调用路径
- TON: `get` methods 或只读 receiver
- CosmWasm: `query` 及其只读 handler

如果某条路径是否改状态存在歧义，标为“需要人工复核”，不要想当然删掉。

## 工作流程

### 1. 识别语言和范围

优先用快速命令确认代码类型和目录范围：

```bash
rg --files -g '*.sol' -g '*.vy' -g '*.rs' -g '*.move' -g '*.fc' -g '*.func' -g '*.tact'
```

必要时再补：

```bash
rg -n "pragma solidity|@external|entry fun|#[program]|instantiate|execute|receive|fallback|modifier |onlyOwner|onlyRole|hasRole|assert_owner"
```

如果用户指定目录，只分析该目录，并在报告里写清楚 scope。

### 2. Solidity 优先尝试 Slither

先检查：

```bash
which slither
```

如果存在，优先运行：

```bash
slither . --print entry-points
```

把它当成基础清单，再用人工分析补下面这类 Slither 不一定能完整表达的内容：

- 动态访问控制
- 回调信任边界
- 继承链上拿到的 modifier 语义
- 初始化函数首次调用限制

如果 `slither` 不存在或跑不通，就直接走手工分析，并说明原因。

### 3. 读取对应语言参考

根据语言读取对应参考文件：

- Solidity: [references/solidity.md](references/solidity.md)
- Vyper: [references/vyper.md](references/vyper.md)
- Solana/Rust: [references/solana.md](references/solana.md)
- Move on Sui: [references/move-sui.md](references/move-sui.md)
- Move on Aptos: [references/move-aptos.md](references/move-aptos.md)
- TON: [references/ton.md](references/ton.md)
- CosmWasm: [references/cosmwasm.md](references/cosmwasm.md)

混合项目时分语言分别统计，再汇总。

### 4. 提取入口点

必须覆盖所有“外部可达且会改状态”的函数或 handler。常见包括：

- `external` / `public` state-changing functions
- receive / fallback / callback handlers
- governance / admin executors
- upgrade / config setters
- token mint / burn / pause / sweep / rescue flows
- Solana instructions
- Move `public entry fun`
- CosmWasm `execute`, `migrate`, `reply`, `sudo`

### 5. 分类访问级别

至少分成四类：

1. Public (Unrestricted)
2. Role-Restricted
3. Restricted (Review Required)
4. Contract-Only

常见角色关键词：

- `owner`
- `admin`
- `governance`
- `guardian`
- `operator`
- `manager`
- `minter`
- `pauser`
- `keeper`
- `relayer`
- `strategist`

如果只看到动态条件，例如 `authorized[msg.sender]`、外部 registry、可变白名单，不要硬判具体角色，直接放进 `Review Required`。

### 6. 输出报告

输出跟用户语言保持一致，但表格字段要清楚、紧凑。

推荐结构：

```markdown
# Entry Point Analysis: [Project]

**Scope**: [full repo or subdir]
**Languages**: [detected languages]
**Focus**: state-changing functions only

## Summary
| Category | Count |
|---|---:|
| Public (Unrestricted) | X |
| Role-Restricted | X |
| Restricted (Review Required) | X |
| Contract-Only | X |
| Total | X |

## Public Entry Points
| Function | Location | Notes |

## Role-Restricted Entry Points
| Function | Location | Restriction | Role |

## Restricted (Review Required)
| Function | Location | Pattern | Why review |

## Contract-Only
| Function | Location | Expected caller |

## Files Analyzed
- ...
```

## 审计时的几个硬规则

- 不要因为“看起来标准”就跳过函数
- 不要只看 modifier 名字，要追具体实现
- 不要漏 callback、hook、reply、fallback
- 不要把只读函数混进总数里
- 不确定访问控制时，宁可标 `Review Required`

## 与其他 skill 的配合

完成入口面梳理后，常见下一步是：

- 做整体安全审查：`$smart-contract-security-suite`
- 做更深层上下文或漏洞分析：现有 Trail of Bits 安全类 skill

## 说明

本 skill 改编自 Trail of Bits `entry-point-analyzer`，但做了几项 Codex 适配：

- 去掉 Claude 专用 `allowed-tools` 元数据
- 改成 Codex 常用的 `rg` / shell 工作流
- 明确要求输出 `file:line` 证据和访问级别表格
- 保留原始多链参考资料在 `references/`
