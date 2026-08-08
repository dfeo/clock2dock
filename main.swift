import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var timer: Timer?
    private var lastDrawn = ""

    func applicationDidFinishLaunching(_ note: Notification) {
        redraw()
        let t = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            self?.redraw()
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    private func redraw() {
        let now = Date()
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        let text = f.string(from: now)
        guard text != lastDrawn else { return }
        lastDrawn = text

        let parts = text.split(separator: ":")
        let hour = String(parts[0])
        let minute = String(parts[1])

        let side = 512.0
        let size = NSSize(width: side, height: side)
        let image = NSImage(size: size)
        image.lockFocus()

        let rect = NSRect(origin: .zero, size: size)
        let bg = NSBezierPath(roundedRect: rect.insetBy(dx: 8, dy: 8),
                              xRadius: 96, yRadius: 96)
        NSColor(calibratedRed: 0.10, green: 0.10, blue: 0.12, alpha: 1).setFill()
        bg.fill()

        let dotColor = NSColor(calibratedRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.06)
        dotColor.setFill()
        let dotSize: CGFloat = 4
        let step: CGFloat = 16
        var y: CGFloat = 16
        while y < side - 16 {
            var x: CGFloat = 16
            while x < side - 16 {
                NSBezierPath(ovalIn: NSRect(x: x, y: y, width: dotSize, height: dotSize)).fill()
                x += step
            }
            y += step
        }

        bg.addClip()

        let hourColor = NSColor(calibratedRed: 0.78, green: 0.78, blue: 0.82, alpha: 1)
        let minColor  = NSColor(calibratedRed: 0.96, green: 0.55, blue: 0.16, alpha: 1)
        let font = NSFont(name: "SF Pro Display", size: 230)
            ?? NSFont.systemFont(ofSize: 230, weight: .heavy)

        let para = NSMutableParagraphStyle()
        para.alignment = .center

        let hourStr = NSAttributedString(string: hour, attributes: [
            .font: font,
            .foregroundColor: hourColor,
            .paragraphStyle: para
        ])
        let minStr = NSAttributedString(string: minute, attributes: [
            .font: font,
            .foregroundColor: minColor,
            .paragraphStyle: para
        ])

        let hourSize = hourStr.size()
        let minSize = minStr.size()
        let gap: CGFloat = -35
        let totalH = hourSize.height + gap + minSize.height
        let startY = (side - totalH) / 2 + 20

        let hourRect = NSRect(x: 0, y: startY + minSize.height + gap,
                              width: side, height: hourSize.height)
        let minRect = NSRect(x: 0, y: startY,
                             width: side, height: minSize.height)

        hourStr.draw(in: hourRect)
        minStr.draw(in: minRect)

        image.unlockFocus()

        NSApp?.applicationIconImage = image
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.run()