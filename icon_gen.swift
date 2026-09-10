import Cocoa

@main
struct IconGen {
    static func main() throws {
        let tmp = "/tmp/clock2dock.iconset"
        try? FileManager.default.removeItem(atPath: tmp)
        try! FileManager.default.createDirectory(atPath: tmp, withIntermediateDirectories: true)

        let specs: [(name: String, size: CGFloat)] = [
            ("icon_16x16.png",       16),
            ("icon_16x16@2x.png",    32),
            ("icon_32x32.png",       32),
            ("icon_32x32@2x.png",    64),
            ("icon_128x128.png",     128),
            ("icon_128x128@2x.png",  256),
            ("icon_256x256.png",     256),
            ("icon_256x256@2x.png",  512),
            ("icon_512x512.png",     512),
            ("icon_512x512@2x.png",  1024),
        ]

        for spec in specs {
            let img = ClockRenderer.render(hour: "12", minute: "34", side: spec.size)
            guard let tiff = img.tiffRepresentation,
                  let rep = NSBitmapImageRep(data: tiff),
                  let png = rep.representation(using: .png, properties: [:]) else {
                FileHandle.standardError.write("failed: \(spec.name)\n".data(using: .utf8)!)
                exit(1)
            }
            try png.write(to: URL(fileURLWithPath: "\(tmp)/\(spec.name)"))
        }

        let iconutil = Process()
        iconutil.launchPath = "/usr/bin/iconutil"
        iconutil.arguments = ["-c", "icns", "-o", "AppIcon.icns", tmp]
        try iconutil.run()
        iconutil.waitUntilExit()

        try? FileManager.default.removeItem(atPath: tmp)
        print("Generated AppIcon.icns")
    }
}