import Foundation
import ApplicationServices

func postMouse(_ type: CGEventType, at point: CGPoint, button: CGMouseButton = .left) {
    guard let event = CGEvent(mouseEventSource: nil, mouseType: type, mouseCursorPosition: point, mouseButton: button) else {
        fputs("failed to create mouse event\n", stderr)
        exit(1)
    }
    event.post(tap: .cghidEventTap)
}

func move(to point: CGPoint) {
    postMouse(.mouseMoved, at: point)
}

func click(at point: CGPoint) {
    move(to: point)
    usleep(80_000)
    postMouse(.leftMouseDown, at: point)
    usleep(50_000)
    postMouse(.leftMouseUp, at: point)
}

func drag(from start: CGPoint, to end: CGPoint, steps: Int = 24) {
    move(to: start)
    usleep(80_000)
    postMouse(.leftMouseDown, at: start)
    usleep(80_000)
    for idx in 1...max(steps, 1) {
        let t = CGFloat(idx) / CGFloat(max(steps, 1))
        let x = start.x + (end.x - start.x) * t
        let y = start.y + (end.y - start.y) * t
        postMouse(.leftMouseDragged, at: CGPoint(x: x, y: y))
        usleep(12_000)
    }
    usleep(60_000)
    postMouse(.leftMouseUp, at: end)
}

func keyCombo(keyCode: CGKeyCode, flags: CGEventFlags = []) {
    guard let down = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: true),
          let up = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: false) else {
        fputs("failed to create keyboard event\n", stderr)
        exit(1)
    }
    down.flags = flags
    up.flags = flags
    down.post(tap: .cghidEventTap)
    usleep(40_000)
    up.post(tap: .cghidEventTap)
}

func typeText(_ text: String) {
    let utf16 = Array(text.utf16)
    guard let down = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: true),
          let up = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: false) else {
        fputs("failed to create unicode keyboard event\n", stderr)
        exit(1)
    }
    down.keyboardSetUnicodeString(stringLength: utf16.count, unicodeString: utf16)
    up.keyboardSetUnicodeString(stringLength: utf16.count, unicodeString: utf16)
    down.post(tap: .cghidEventTap)
    usleep(60_000)
    up.post(tap: .cghidEventTap)
}

func usage() -> Never {
    fputs("usage: swift macclick.swift click <x> <y> | drag <x1> <y1> <x2> <y2> | key <keycode> [cmd|shift|opt|ctrl ...] | text <string> | stdin\n", stderr)
    exit(2)
}

let args = CommandLine.arguments
guard args.count >= 2 else { usage() }

switch args[1] {
case "click":
    guard args.count == 4, let x = Double(args[2]), let y = Double(args[3]) else { usage() }
    click(at: CGPoint(x: x, y: y))
case "drag":
    guard args.count == 6,
          let x1 = Double(args[2]),
          let y1 = Double(args[3]),
          let x2 = Double(args[4]),
          let y2 = Double(args[5]) else { usage() }
    drag(from: CGPoint(x: x1, y: y1), to: CGPoint(x: x2, y: y2))
case "key":
    guard args.count >= 3, let keyCode = UInt16(args[2]) else { usage() }
    var flags: CGEventFlags = []
    for flag in args.dropFirst(3) {
        switch flag {
        case "cmd":
            flags.insert(.maskCommand)
        case "shift":
            flags.insert(.maskShift)
        case "opt":
            flags.insert(.maskAlternate)
        case "ctrl":
            flags.insert(.maskControl)
        default:
            break
        }
    }
    keyCombo(keyCode: CGKeyCode(keyCode), flags: flags)
case "text":
    guard args.count >= 3 else { usage() }
    typeText(args.dropFirst(2).joined(separator: " "))
case "stdin":
    let data = FileHandle.standardInput.readDataToEndOfFile()
    guard let text = String(data: data, encoding: .utf8) else {
        fputs("failed to decode stdin as utf-8\n", stderr)
        exit(1)
    }
    typeText(text)
default:
    usage()
}
