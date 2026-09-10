import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var timer: Timer?
    private var lastDrawn = ""
    private let use12hKey = "use12h"
    private var use12h: Bool {
        get { UserDefaults.standard.bool(forKey: use12hKey) }
        set { UserDefaults.standard.set(newValue, forKey: use12hKey) }
    }

    func applicationDidFinishLaunching(_ note: Notification) {
        redraw()
        let t = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            self?.redraw()
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        let menu = NSMenu()

        let item24 = NSMenuItem(title: "24 horas",
                                action: #selector(set24h),
                                keyEquivalent: "")
        item24.target = self
        item24.state = use12h ? .off : .on
        menu.addItem(item24)

        let item12 = NSMenuItem(title: "12 horas (AM/PM)",
                                action: #selector(set12h),
                                keyEquivalent: "")
        item12.target = self
        item12.state = use12h ? .on : .off
        menu.addItem(item12)

        menu.addItem(NSMenuItem.separator())

        let quit = NSMenuItem(title: "Salir",
                              action: #selector(NSApplication.terminate(_:)),
                              keyEquivalent: "q")
        menu.addItem(quit)

        return menu
    }

    @objc private func set24h() {
        use12h = false
        lastDrawn = ""
        redraw()
    }

    @objc private func set12h() {
        use12h = true
        lastDrawn = ""
        redraw()
    }

    private func redraw() {
        let now = Date()
        let f = DateFormatter()
        f.dateFormat = use12h ? "hh:mm" : "HH:mm"
        let text = f.string(from: now)
        guard text != lastDrawn else { return }
        lastDrawn = text

        let parts = text.split(separator: ":")
        let hour = String(parts[0])
        let minute = String(parts[1])

        NSApp?.applicationIconImage = ClockRenderer.render(hour: hour, minute: minute)
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.run()