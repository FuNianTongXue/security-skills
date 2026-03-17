#!/bin/zsh
set -euo pipefail

TOOL_BIN="${TOOL_BIN:-/opt/homebrew/privacy-tools/bin}"
export PATH="${TOOL_BIN}:$PATH"

usage() {
  echo "usage: $0 /path/to/app.apk [output_dir]" >&2
  exit 1
}

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "missing required command: $1" >&2
    exit 1
  fi
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage
fi

APK_PATH="$1"
if [[ ! -f "${APK_PATH}" ]]; then
  echo "apk not found: ${APK_PATH}" >&2
  exit 1
fi

need_cmd jadx
need_cmd apktool
need_cmd rg

APP_BASENAME="${APK_PATH:t:r}"
OUT_DIR="${2:-/tmp/${APP_BASENAME}-privacy-scan}"
JADX_OUT="${OUT_DIR}/jadx"
APKTOOL_OUT="${OUT_DIR}/apktool"
REPORT_OUT="${OUT_DIR}/report"

mkdir -p "${OUT_DIR}" "${REPORT_OUT}"

echo "[1/5] decompile with jadx"
rm -rf "${JADX_OUT}"
jadx -d "${JADX_OUT}" "${APK_PATH}" >/dev/null

echo "[2/5] decode with apktool"
rm -rf "${APKTOOL_OUT}"
apktool d "${APK_PATH}" -o "${APKTOOL_OUT}" -f >/dev/null

PERMISSION_PATTERN='READ_PHONE_STATE|READ_PRIVILEGED_PHONE_STATE|ACCESS_FINE_LOCATION|ACCESS_COARSE_LOCATION|READ_CONTACTS|WRITE_CONTACTS|GET_ACCOUNTS|READ_SMS|SEND_SMS|READ_CALL_LOG|WRITE_CALL_LOG|READ_CALENDAR|RECORD_AUDIO|CAMERA|READ_EXTERNAL_STORAGE|READ_MEDIA_IMAGES|READ_MEDIA_VIDEO|QUERY_ALL_PACKAGES|BLUETOOTH_CONNECT|BODY_SENSORS'
SENSITIVE_API_PATTERN='getDeviceId|getImei|getMeid|getSubscriberId|getSimSerialNumber|getLastKnownLocation|requestLocationUpdates|ClipboardManager|getPrimaryClip|getInstalledPackages|getInstalledApplications|AdvertisingId|OAID|android_id|content://call_log|ContactsContract|CallLog|TelephonyManager|LocationManager'
SDK_PATTERN='com\\.umeng|com\\.tencent\\.bugly|com\\.google\\.firebase|com\\.appsflyer|com\\.adjust|com\\.sensorsdata|com\\.growingio|com\\.baidu|com\\.huawei|com\\.miui|com\\.alibaba|com\\.aliyun|com\\.facebook|com\\.bytedance|com\\.qq|com\\.weibo'
NETWORK_PATTERN='https?://|api\\.|collect|track|upload|analytics|device|oaid|imei|android_id|privacy|consent'

echo "[3/5] collect manifest permissions"
rg -n "${PERMISSION_PATTERN}" "${APKTOOL_OUT}" "${JADX_OUT}" \
  -g '!**/R.java' \
  -g '!**/BuildConfig.java' > "${REPORT_OUT}/permissions.txt" || true

echo "[4/5] collect code and sdk hints"
rg -n "${SENSITIVE_API_PATTERN}" "${JADX_OUT}" "${APKTOOL_OUT}" \
  -g '!**/R.java' \
  -g '!**/BuildConfig.java' > "${REPORT_OUT}/sensitive-api-hits.txt" || true

rg -n "${SDK_PATTERN}" "${JADX_OUT}" "${APKTOOL_OUT}" \
  -g '!**/R.java' \
  -g '!**/BuildConfig.java' > "${REPORT_OUT}/sdk-hits.txt" || true

echo "[5/5] collect network hints"
rg -n "${NETWORK_PATTERN}" "${JADX_OUT}" "${APKTOOL_OUT}" \
  -g '!**/R.java' \
  -g '!**/BuildConfig.java' > "${REPORT_OUT}/network-hints.txt" || true

cat > "${REPORT_OUT}/README.txt" <<EOF
This folder contains candidate evidence only.

Do not label the app compliant or non-compliant from these files alone.
Use them to support manual review and dynamic verification.

Files:
- permissions.txt
- sensitive-api-hits.txt
- sdk-hits.txt
- network-hints.txt
EOF

echo "output_dir=${OUT_DIR}"
echo "report_dir=${REPORT_OUT}"
