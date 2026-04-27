#!/usr/bin/env python3
import sys

CAPS = [
    "CAP_CHOWN",
    "CAP_DAC_OVERRIDE",
    "CAP_DAC_READ_SEARCH",
    "CAP_FOWNER",
    "CAP_FSETID",
    "CAP_KILL",
    "CAP_SETGID",
    "CAP_SETUID",
    "CAP_SETPCAP",
    "CAP_LINUX_IMMUTABLE",
    "CAP_NET_BIND_SERVICE",
    "CAP_NET_BROADCAST",
    "CAP_NET_ADMIN",
    "CAP_NET_RAW",
    "CAP_IPC_LOCK",
    "CAP_IPC_OWNER",
    "CAP_SYS_MODULE",
    "CAP_SYS_RAWIO",
    "CAP_SYS_CHROOT",
    "CAP_SYS_PTRACE",
    "CAP_SYS_PACCT",
    "CAP_SYS_ADMIN",
    "CAP_SYS_BOOT",
    "CAP_SYS_NICE",
    "CAP_SYS_RESOURCE",
    "CAP_SYS_TIME",
    "CAP_SYS_TTY_CONFIG",
    "CAP_MKNOD",
    "CAP_LEASE",
    "CAP_AUDIT_WRITE",
    "CAP_AUDIT_CONTROL",
    "CAP_SETFCAP",
    "CAP_MAC_OVERRIDE",
    "CAP_MAC_ADMIN",
    "CAP_SYSLOG",
    "CAP_WAKE_ALARM",
    "CAP_BLOCK_SUSPEND",
    "CAP_AUDIT_READ",
    "CAP_PERFMON",
    "CAP_BPF",
    "CAP_CHECKPOINT_RESTORE",
]


def main() -> int:
    if len(sys.argv) > 1:
        raw = sys.argv[1].strip()
    else:
        raw = sys.stdin.read().strip()

    if not raw:
        print("usage: decode_caps.py <hex-capability-mask>", file=sys.stderr)
        return 1

    raw = raw.lower().replace("0x", "")
    try:
        value = int(raw, 16)
    except ValueError:
        print(f"invalid hex value: {raw}", file=sys.stderr)
        return 1

    enabled = [name for bit, name in enumerate(CAPS) if value & (1 << bit)]
    print(f"0x{value:016x}")
    if enabled:
        for name in enabled:
            print(name)
    else:
        print("no capabilities enabled")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
