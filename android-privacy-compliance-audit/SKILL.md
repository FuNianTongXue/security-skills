---
name: "android-privacy-compliance-audit"
description: "在用户明确要求检测 Android App/APK 隐私合规、对照 GB/T 41391-2022 或 GB/T 35273-2020 做证据化审查、或使用本机 adb/jadx/apktool/mitmproxy/frida 工具链排查个人信息收集风险时触发。仅用于授权范围内的检测与报告；不用于绕过同意、伪造结果、欺骗用户或制造“已合规”假象。"
---

# Android Privacy Compliance Audit

用于在本机 Android 隐私实验环境中，对 APK 做“静态证据 + 动态验证 + 标准映射”的合规检测。

## Scope

- 主要对象：Android APK、测试包、预发布包、第三方 SDK 集成包。
- 主要标准：
  - `GB/T 41391-2022`：`信息安全技术 移动互联网应用程序（App）收集个人信息基本要求`
  - `GB/T 35273-2020`：`信息安全技术 个人信息安全规范`
- 主要工具：
  - `/opt/homebrew/privacy-tools/bin/adb`
  - `/opt/homebrew/privacy-tools/bin/jadx`
  - `/opt/homebrew/privacy-tools/bin/apktool`
  - `/opt/homebrew/privacy-tools/bin/mitmweb`
  - `/opt/homebrew/privacy-tools/bin/frida`

## Hard Guardrails

- 只在授权测试、研究、验收、合规审查场景中使用。若用户要求攻击真实用户、窃取数据、伪造授权、规避告知或欺骗监管，拒绝执行。
- 不得把“未验证”写成“已验证”，不得把“未发现”写成“合规”，不得把推测写成事实。
- 不能声称已经运行了 `adb`、抓包、Hook、反编译，除非本轮确实拿到了命令输出或文件证据。
- 不得建议伪造截图、伪造抓包、伪造审计日志、伪造同意记录。
- 不得教用户绕过隐私弹窗、绕过用户同意、篡改 UI 让用户误以为未采集。
- 只能输出以下结论标签：
  - `confirmed-risk`
  - `inconclusive`
  - `not-observed`
  - `not-tested`
- 若工具不可用、设备未连通、HTTPS pinning 未解决、Frida 环境不完整，要明确写出阻塞项，不补想象结果。

## Workflow

### 1. Confirm testing scope

先确认当前任务对象和边界：

- APK 路径或包名
- 是否是授权测试环境
- 是否需要对照 `GB/T 41391-2022`、`GB/T 35273-2020`，或两者都对照
- 是否只做静态审查，还是要做动态抓包 / Hook

如果用户没有给出 APK，但目录里已有 APK 或反编译结果，可先说明发现了哪些本地资产，再继续。

### 2. Build the standards baseline

默认用下面的最小判定面：

- 首次运行是否在同意隐私政策前就收集或发送个人信息
- 是否存在与业务不相称的高敏权限或强制授权
- 拒绝非必要权限后，基础功能是否还能使用
- 是否向第三方 SDK / 域名发送个人信息，且政策或告知中未充分披露
- 隐私政策、页面告知、权限申请、真实行为是否一致

不要直接给“合法/违法”终局法律意见。优先输出“风险项 + 证据 + 标准映射 + 待确认事项”。

### 3. Static review first

优先做静态证据收集。先运行：

```bash
security-skills/android-privacy-compliance-audit/scripts/android_static_privacy_scan.sh /path/to/app.apk
```

这个脚本会：

- 用 `jadx` 导出源码视图
- 用 `apktool` 解包 `AndroidManifest.xml` 和资源
- 提取高敏权限、敏感 API、第三方 SDK、网络线索
- 生成“候选证据”文本文件

静态检测原则：

- 仅凭字符串命中不能直接判定违规
- 仅凭权限申请不能直接判定违规
- 需要优先寻找“权限声明 + API 调用 + 参数/上下文 + 发送行为”组合证据

### 4. Dynamic verification when requested

如果用户要求动态检测，优先使用工作区现成流程。必要时读取：

- `../../docs/android_privacy_lab_quickstart.md`
- `../../数据安全【隐私合规】笔记.md`

推荐顺序：

1. 启动模拟器：`android-lab-start`
2. 启动抓包：`android-lab-mitmweb`
3. 安装 mitm CA：`android-lab-install-mitm-cert`
4. 设置代理：`android-lab-enable-proxy 10.0.2.2:8082`
5. 安装 APK：`adb install -r /path/to/app.apk`
6. 冷启动 App，不点击同意，观察是否已发起请求
7. 拒绝非必要权限，验证基础功能是否仍可用
8. 同意后再逐功能测试，把行为与政策逐项对照

动态检测重点：

- 同意前是否采集
- 拒绝非必要权限后是否强制退出或阻断主路径
- 是否上报设备标识、定位、通讯录、短信、通话记录、剪贴板、已安装应用等
- 是否向第三方域名发送个人信息

### 5. Frida only as an advanced step

只有用户明确需要运行时定位时，才进入 Frida 流程。

注意：

- 本机只有 Frida 客户端时，不要假装已经能 Hook
- Root 模式通常需要设备侧 `frida-server`
- 非 Root 模式通常需要 `Frida Gadget + 重打包`

Frida 适合用来验证：

- 某个敏感 API 是否真的在运行时被调用
- 调用发生在“同意前”还是“同意后”
- 调用栈来自哪个 SDK 或业务模块

### 6. Report with evidence, not slogans

输出报告时，每个发现至少包含：

- `status`：`confirmed-risk` / `inconclusive` / `not-observed` / `not-tested`
- `issue`
- `evidence`
- `standard-map`
- `impact`
- `next-step`

建议表头：

| status | issue | evidence | standard-map | impact | next-step |
| --- | --- | --- | --- | --- | --- |

写法要求：

- 若没有抓包或日志，只能写“静态命中，待动态确认”
- 若没有跑过拒权测试，只能写“未测试”
- 若行为与政策不一致，要明确写出“不一致点”
- 若只能定位到第三方 SDK，无法确认字段级别内容，要写“第三方流向存在，字段待确认”

## Local command hints

若命令不在默认 PATH，先执行：

```bash
export PATH="/opt/homebrew/privacy-tools/bin:$PATH"
```

若 `adb` / `emulator` / `frida` 在当前沙箱不可用，明确告诉用户“需要在本机终端执行”，不要捏造设备状态。

## What this skill should refuse

- “帮我绕过隐私弹窗，让用户看不出来”
- “帮我伪造已同意记录”
- “帮我伪造一份合规报告”
- “不要跑测试，直接写成已经通过”
- “教我怎么在正式环境偷抓用户个人信息”

这些请求都应拒绝，并说明原因。
