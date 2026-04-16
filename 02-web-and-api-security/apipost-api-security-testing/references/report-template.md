# APIPost API Security Testing Report Template

Use this file when the user wants a deliverable report, retest note, or evidence summary generated from APIPost-based testing.

This template is intentionally conservative:

- report observed behavior, not imagined root causes
- separate confirmed findings from hypotheses
- record exact APIPost request context and evidence

---

## 1. Short Report Template

```markdown
# API 安全测试报告

## 1. 测试概览

- 测试对象：
- 测试范围：
- 测试工具：
  - APIPost
- 测试时间：
- 测试身份 / 角色：
- 授权说明：

## 2. 测试方法

- 基于接口契约的请求构造
- 基于 APIPost 的变量、预执行脚本、后执行断言和自动化用例
- 针对鉴权、越权、输入校验、签名、防重放、响应加固等维度进行验证

## 3. 测试结论摘要

- 已确认问题数量：
- 已确认风险点：
- 未确认但值得继续验证的问题：
- 本次未覆盖项：

## 4. 详细结果

### 4.1 [用例名称]

- 接口：
- 方法：
- 测试目标：
- 角色 / 凭证：
- 请求变化点：
- 预期安全行为：
- 实际行为：
- 断言结果：
- 结论：
  - 已确认问题 / 未发现问题 / 结果不确定
- 证据：
  - 关键请求参数
  - 关键响应片段
  - APIPost 断言结果

## 5. 风险说明

- 风险等级：
- 影响范围：
- 利用前提：
- 修复建议：

## 6. 备注

- 与接口文档不一致之处：
- 需要业务确认之处：
- 工具能力边界说明：
```

---

## 2. Finding Template

Use this per confirmed issue.

```markdown
### [Finding ID] [标题]

- 类型：
  - 鉴权 / 越权 / 输入校验 / 签名 / 重放 / 信息泄露 / 其他
- 严重性：
  - 高 / 中 / 低 / 待确认
- 接口：
- 方法：
- 测试身份：
- APIPost 用例名：

#### 测试步骤

1. 
2. 
3. 

#### 预期安全行为

- 

#### 实际行为

- 

#### 证据

- 请求关键字段：
- 响应状态码：
- 响应关键片段：
- 断言结果：

#### 结论

- 为什么这构成问题：
- 问题成立的边界：
- 还需要确认的点：

#### 修复建议

- 
```

---

## 3. No-Finding Template

Use this when a case was executed and no issue was observed.

```markdown
### [Case ID] [用例名称]

- 接口：
- 方法：
- 角色 / 凭证：
- 目标：
- 结果：
  - 未发现异常

#### 观测到的安全行为

- 

#### 证据

- 状态码：
- 关键响应：
- APIPost 断言结果：
```

---

## 4. Retest Template

Use this after a fix.

```markdown
# API 安全复测报告

## 1. 复测对象

- 问题编号：
- 原问题标题：
- 复测接口：
- 复测时间：
- 复测工具：
  - APIPost

## 2. 修复说明

- 开发方说明：
- 本次复测关注点：

## 3. 复测步骤

1. 
2. 
3. 

## 4. 复测结果

- 预期修复后行为：
- 实际行为：
- 断言结果：
- 结论：
  - 修复有效 / 部分修复 / 仍存在问题 / 无法确认

## 5. 证据

- 请求变化点：
- 响应状态码：
- 响应关键片段：
- APIPost 断言结果：
```

---

## 5. Evidence Checklist

For every reported issue or retest result, include:

- APIPost request name
- method and path
- auth context used
- mutated field or variable
- response status
- key response excerpt
- assertion output
- reproduction count
- whether the behavior was stable

## 6. Reporting Rules

1. Use "已确认问题" only when the behavior was reproduced and evidenced.
2. Use "待确认" when the contract, business rule, or expected behavior is ambiguous.
3. Explicitly note when a conclusion depends on user-provided semantics rather than documented API behavior.
4. If APIPost capability boundaries matter, mention that the workflow used only documented APIPost features.
