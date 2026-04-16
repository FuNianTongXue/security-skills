# APIPost Official Capability Notes

This file records only APIPost capabilities that were explicitly confirmed from official APIPost documentation while creating this skill. Use it to avoid overstating what APIPost can do.

## Source Set

- APIPost start docs: [https://wiki.apipost.cn/docs/start/](https://wiki.apipost.cn/docs/start/)
- 利用预执行脚本发送一个请求: [https://wiki.apipost.cn/docs/sendrequest/](https://wiki.apipost.cn/docs/sendrequest/)
- 利用预执行脚本动态添加一个请求参数: [https://wiki.apipost.cn/docs/addarequestparam/](https://wiki.apipost.cn/docs/addarequestparam/)
- 如何使用断言: [https://wiki.apipost.cn/docs/usescript/assertion/](https://wiki.apipost.cn/docs/usescript/assertion/)
- 提取变量: [https://wiki.apipost.cn/docs/http_debug/set-valuable/](https://wiki.apipost.cn/docs/http_debug/set-valuable/)
- 云端值和本地值: [https://wiki.apipost.cn/docs/value/cloudandlocal/](https://wiki.apipost.cn/docs/value/cloudandlocal/)
- 性能测试: [https://wiki.apipost.cn/docs/test/load-testing/](https://wiki.apipost.cn/docs/test/load-testing/)

## Confirmed Capabilities

### 1. Pre-execution and post-execution operations exist

Confirmed from APIPost docs:

- Pre-execution operations run before the request is sent.
- Post-execution operations run after the request is sent.
- Post-execution operations are used for variable setting and assertions.

Security-testing value:

- Pre-execution is suitable for request mutation, signatures, nonce generation, and prerequisite requests.
- Post-execution is suitable for response validation and evidence capture.

### 2. Script-based assertions are supported

Confirmed from official docs:

- Assertions are generally used in post-execution scripts.
- Example syntax shown in official docs includes:

```javascript
apt.assert('response.raw.status==200');
apt.assert('response.raw.type=="json"');
apt.assert('response.json.errcode==0');
apt.assert('response.raw.responseTime<100');
```

The docs also state that each test case is one line.

Security-testing value:

- Validate auth failures, status codes, timing limits, leakage, and response structure.

### 3. Variable extraction is supported

Confirmed from official docs:

- APIPost supports extracting variables from `Response JSON`, `Response XML`, `Response Text`, `Response Header`, `Response Cookie`, and response time.
- Extracted values can be saved as temporary, environment, or global variables.

Security-testing value:

- Capture tokens, IDs, nonces, cookies, and workflow state between chained requests.

### 4. Environment and global variables are supported

Confirmed from official docs:

- Environment variables apply to a selected environment.
- Global variables apply to the whole project.
- Variable reference syntax is `{{变量名}}`.
- In version `8.1.5` and later, variable values are described as cloud values and local values.

Security-testing value:

- Keep separate auth contexts for admin, regular user, service account, and negative-test tokens.
- Avoid leaking secrets into team-shared values when only local testing is intended.

### 5. Pre-execution scripts can modify requests

Confirmed from official docs:

- APIPost docs show use of the `request` object to read request parameters.
- APIPost docs show dynamic request mutation in pre-execution scripts, including:
  - adding headers
  - adding query params
  - adding body params
- Official example includes:

```javascript
let raw_token = $.md5(request.request_bodys.user_id.toString() + request.request_bodys.nick_name.toString());
apt.setRequestHeader("token", raw_token);
```

Security-testing value:

- Build signed requests, tamper headers, adjust content, and generate negative cases without manually duplicating many requests.

### 6. Pre-execution scripts can send requests

Confirmed from official docs:

- APIPost documents sending HTTP requests inside pre-execution scripts via `$.ajax`.
- Docs note `$.ajax` is asynchronous.
- Docs further state that in `Apipost 7.0.4` and later, `await` can be used so the request completes before the current interface request is sent.

Security-testing value:

- Obtain prerequisite tokens or dynamic state before a test request.
- Chain multi-step workflows inside APIPost when appropriate.

### 7. Automated tests exist

Confirmed from official docs navigation and load-testing docs:

- APIPost has an `自动化测试` section.
- Performance testing is documented as being available inside automated testing.

Security-testing value:

- Save repeatable negative tests and regression cases instead of running them manually every time.

### 8. Optional performance testing exists, with version note

Confirmed from official docs:

- Starting from version `8.1.4`, APIPost supports performance testing inside automated testing.
- The docs say performance testing supports two modes:
  - fixed mode
  - ramp mode
- Docs note this feature is client-experience only.

Security-testing value:

- Use only for bounded, authorized rate-limit or resilience observation.
- Do not describe it as a DoS platform or distributed attack tooling.

## Things Not Confirmed Here

Do not claim any of the following unless the user provides current evidence or you find official docs for them:

- built-in vulnerability scanner
- crawler or asset discovery
- automatic auth bypass detection
- automatic business logic flaw detection
- passive traffic scanner
- browser automation
- token theft detection
- built-in exploit generation

## Safe Wording Patterns

Prefer wording like:

- "Use APIPost to send crafted requests and validate responses."
- "Use APIPost assertions to confirm whether the observed behavior matches the expected secure behavior."
- "Use APIPost variables and scripts to reproduce the workflow."

Avoid wording like:

- "APIPost will automatically find this vulnerability."
- "APIPost has a built-in security scanner for this class of issue."
- "APIPost natively fuzzes the API for all vulnerability categories."
