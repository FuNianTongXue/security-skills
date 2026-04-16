# Shayshen Security Skills

一个面向 Codex 的安全类自定义 skills 仓库整理包，按安全领域做了分层，适合直接作为 GitHub 仓库上传和维护。

## 目录结构

```text
shayshen-security-skills/
├── 01-smart-contract-security/
├── 02-web-and-api-security/
├── 03-privacy-and-compliance/
├── 04-security-engineering-and-governance/
├── docs/
├── .gitignore
├── NOTICE.md
└── PUBLISH_CHECKLIST.md
```

## Skills Index

| Category | Skill | Purpose |
|---|---|---|
| Smart Contract Security | `smart-contract-entry-points` | 梳理状态变更入口点、权限面和审计攻击面 |
| Smart Contract Security | `smart-contract-security-suite` | 智能合约安全工作台，整合审计准备、升级、测试、漏洞模式等分析 |
| Smart Contract Security | `web3-security-pm` | Web3 安全产品与交付规划类 workflow |
| Web and API Security | `apipost-api-security-testing` | 用 APIPost 做授权 API 安全测试和证据整理 |
| Web and API Security | `exploit-focused-code-audit` | 从低权限外部攻击者视角做高可利用性代码审计 |
| Web and API Security | `pentest-automation-safe` | 授权范围内的自动化渗透流程能力 |
| Web and API Security | `yakit-vuln-retest-screenshots` | 用 Yakit 复测漏洞并沉淀截图证据 |
| Privacy and Compliance | `android-privacy-compliance-audit` | Android 隐私合规与静态检测工作流 |
| Security Engineering and Governance | `security-best-practices` | 安全最佳实践评审与加固建议 |
| Security Engineering and Governance | `security-ownership-map` | 基于 Git 历史做安全归属和 bus-factor 分析 |

## 使用方式

每个 skill 目录都保留了 `SKILL.md` 和它自己的配套文件。你可以：

1. 直接浏览单个目录并维护内容。
2. 把某个 skill 目录复制到 Codex 的 `~/.codex/skills/`。
3. 从这个仓库中按路径挑选某个 skill 单独复用。

## 命名规范

- 仓库名使用小写加连字符：`shayshen-security-skills`
- 一级目录按领域分组，并使用数字前缀保持顺序稳定
- skill 目录保留原始 skill 名，避免后续触发词和引用关系失效

## 公开上传前建议

- 先看 [PUBLISH_CHECKLIST.md](PUBLISH_CHECKLIST.md)
- 再看 [NOTICE.md](NOTICE.md)
- 最后确认每个 skill 目录里是否还包含你不想公开的组织内信息、私有路径或内部流程

## 来源说明

本仓库同时包含：

- 你的自定义 security skills
- 基于 Trail of Bits `building-secure-contracts` 与 `entry-point-analyzer` 改编后的 Codex 适配 skills

涉及第三方改编来源的目录请保留其 attribution，并在公开发布前再次确认许可证和分发边界。
