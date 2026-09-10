import Cocoa

enum ClockRenderer {
    static func render(hour: String, minute: String, side: CGFloat = 512) -> NSImage {
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
        let k: CGFloat = side / 512
        let fontSize: CGFloat = 230 * k
        let font = NSFont(name: "SF Pro Display", size: fontSize)
            ?? NSFont.systemFont(ofSize: fontSize, weight: .heavy)

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
        let gap: CGFloat = -35 * k
        let totalH = hourSize.height + gap + minSize.height
        let startY = (side - totalH) / 2 + 20 * k

        hourStr.draw(in: NSRect(x: 0, y: startY + minSize.height + gap,
                                width: side, height: hourSize.height))
        minStr.draw(in: NSRect(x: 0, y: startY,
                               width: side, height: minSize.height))

        image.unlockFocus()
        return image
    }
}