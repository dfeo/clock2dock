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

        let side = 512
        let size = NSSize(width: side, height: side)
        let image = NSImage(size: size)
        image.lockFocus()

        let rect = NSRect(origin: .zero, size: size)
        let bg = NSBezierPath(roundedRect: rect.insetBy(dx: 10, dy: 10),
                              xRadius: 96, yRadius: 96)
        NSColor(calibratedRed: 0.05, green: 0.07, blue: 0.10, alpha: 1).setFill()
        bg.fill()

        let font = NSFont(name: "Menlo-Bold", size: 175)
            ?? NSFont.systemFont(ofSize: 175, weight: .bold)
        let para = NSMutableParagraphStyle()
        para.alignment = .center
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: NSColor(calibratedRed: 0.2, green: 1.0, blue: 0.4, alpha: 1),
            .paragraphStyle: para
        ]
        let str = NSAttributedString(string: text, attributes: attrs)
        let textSize = str.size()
        str.draw(in: NSRect(x: 0, y: (CGFloat(side) - textSize.height) / 2,
                            width: CGFloat(side), height: textSize.height))
        image.unlockFocus()

        NSApp?.applicationIconImage = image
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.run()