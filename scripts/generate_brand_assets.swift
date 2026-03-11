import AppKit
import Foundation

enum BrandPalette {
    static let cream = NSColor(calibratedRed: 0.99, green: 0.96, blue: 0.87, alpha: 1.0)
    static let night = NSColor(calibratedRed: 0.04, green: 0.09, blue: 0.15, alpha: 1.0)
    static let gold = NSColor(calibratedRed: 0.96, green: 0.72, blue: 0.24, alpha: 1.0)
    static let ember = NSColor(calibratedRed: 0.93, green: 0.43, blue: 0.19, alpha: 1.0)
    static let teal = NSColor(calibratedRed: 0.10, green: 0.66, blue: 0.67, alpha: 1.0)
    static let ink = NSColor(calibratedRed: 0.12, green: 0.18, blue: 0.24, alpha: 1.0)
}

func pngData(from image: NSImage) -> Data? {
    guard let tiff = image.tiffRepresentation,
          let rep = NSBitmapImageRep(data: tiff) else {
        return nil
    }
    return rep.representation(using: .png, properties: [:])
}

func hexagonPath(in rect: CGRect) -> NSBezierPath {
    let path = NSBezierPath()
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let radius = min(rect.width, rect.height) * 0.5
    for i in 0..<6 {
        let angle = CGFloat(Double(i) * .pi / 3.0 - .pi / 2.0)
        let point = CGPoint(
            x: center.x + cos(angle) * radius,
            y: center.y + sin(angle) * radius
        )
        if i == 0 {
            path.move(to: point)
        } else {
            path.line(to: point)
        }
    }
    path.close()
    return path
}

func roundedPath(in rect: CGRect, radius: CGFloat) -> NSBezierPath {
    NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
}

func drawGradient(_ colors: [NSColor], in rect: CGRect, angle: CGFloat) {
    let gradient = NSGradient(colors: colors) ?? NSGradient(starting: colors[0], ending: colors[1])!
    gradient.draw(in: NSBezierPath(rect: rect), angle: angle)
}

func drawQuestMark(in rect: CGRect, darkMode: Bool) {
    let ringRect = rect.insetBy(dx: rect.width * 0.16, dy: rect.height * 0.16)
    let ring = NSBezierPath(ovalIn: ringRect)
    ring.lineWidth = rect.width * 0.065
    (darkMode ? BrandPalette.gold : BrandPalette.ink).setStroke()
    ring.stroke()

    let starColor = darkMode ? BrandPalette.cream : BrandPalette.gold
    let starRadius = rect.width * 0.09
    let starCenter = CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.22)
    let star = NSBezierPath()
    for i in 0..<10 {
        let radius = i.isMultiple(of: 2) ? starRadius : starRadius * 0.42
        let angle = CGFloat(Double(i) * .pi / 5.0 - .pi / 2.0)
        let point = CGPoint(
            x: starCenter.x + cos(angle) * radius,
            y: starCenter.y + sin(angle) * radius
        )
        if i == 0 {
            star.move(to: point)
        } else {
            star.line(to: point)
        }
    }
    star.close()
    starColor.setFill()
    star.fill()

    let check = NSBezierPath()
    check.lineCapStyle = .round
    check.lineJoinStyle = .round
    check.lineWidth = rect.width * 0.075
    check.move(to: CGPoint(x: rect.minX + rect.width * 0.30, y: rect.midY - rect.height * 0.03))
    check.line(to: CGPoint(x: rect.minX + rect.width * 0.44, y: rect.midY - rect.height * 0.18))
    check.line(to: CGPoint(x: rect.maxX - rect.width * 0.24, y: rect.midY + rect.height * 0.14))
    (darkMode ? BrandPalette.teal : BrandPalette.ember).setStroke()
    check.stroke()
}

func drawIcon(size: CGFloat) -> NSImage {
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()

    let fullRect = CGRect(x: 0, y: 0, width: size, height: size)
    drawGradient([BrandPalette.night, BrandPalette.ink, BrandPalette.teal], in: fullRect, angle: 300)

    let outer = roundedPath(in: fullRect.insetBy(dx: size * 0.06, dy: size * 0.06), radius: size * 0.22)
    NSColor.white.withAlphaComponent(0.08).setFill()
    outer.fill()

    let badgeRect = fullRect.insetBy(dx: size * 0.18, dy: size * 0.18)
    let badge = hexagonPath(in: badgeRect)
    NSGraphicsContext.saveGraphicsState()
    drawGradient([BrandPalette.gold, BrandPalette.ember], in: badge.bounds, angle: 270)
    badge.addClip()
    drawGradient([BrandPalette.gold, BrandPalette.ember], in: badge.bounds, angle: 270)
    NSGraphicsContext.restoreGraphicsState()

    let badgeStroke = hexagonPath(in: badgeRect)
    badgeStroke.lineWidth = size * 0.02
    BrandPalette.cream.withAlphaComponent(0.55).setStroke()
    badgeStroke.stroke()

    drawQuestMark(in: badgeRect, darkMode: false)

    let title = "LQ"
    let attributes: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: size * 0.12, weight: .black),
        .foregroundColor: BrandPalette.cream.withAlphaComponent(0.88),
        .kern: size * 0.01
    ]
    let titleSize = title.size(withAttributes: attributes)
    title.draw(
        at: CGPoint(
            x: size * 0.5 - titleSize.width * 0.5,
            y: size * 0.10
        ),
        withAttributes: attributes
    )

    image.unlockFocus()
    return image
}

func drawSplashLogo(size: CGSize, darkMode: Bool) -> NSImage {
    let image = NSImage(size: size)
    image.lockFocus()

    let fullRect = CGRect(origin: .zero, size: size)
    NSColor.clear.setFill()
    fullRect.fill()

    let emblemSize = min(size.width, size.height) * 0.38
    let emblemRect = CGRect(
        x: (size.width - emblemSize) * 0.5,
        y: size.height * 0.42,
        width: emblemSize,
        height: emblemSize
    )

    let auraRect = emblemRect.insetBy(dx: -emblemSize * 0.18, dy: -emblemSize * 0.18)
    let aura = NSBezierPath(ovalIn: auraRect)
    (darkMode ? BrandPalette.teal : BrandPalette.gold).withAlphaComponent(0.10).setFill()
    aura.fill()

    let badge = hexagonPath(in: emblemRect)
    NSGraphicsContext.saveGraphicsState()
    badge.addClip()
    drawGradient(
        darkMode ? [BrandPalette.teal, BrandPalette.ink] : [BrandPalette.gold, BrandPalette.ember],
        in: badge.bounds,
        angle: 270
    )
    NSGraphicsContext.restoreGraphicsState()

    badge.lineWidth = emblemSize * 0.03
    (darkMode ? BrandPalette.cream : BrandPalette.ink).withAlphaComponent(0.75).setStroke()
    badge.stroke()
    drawQuestMark(in: emblemRect, darkMode: darkMode)

    let title = "LIFE QUEST"
    let subtitle = "TURN DAILY ACTIONS INTO LEVEL UPS"
    let titleAttrs: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: min(size.width, size.height) * 0.075, weight: .black),
        .foregroundColor: darkMode ? BrandPalette.cream : BrandPalette.ink,
        .kern: min(size.width, size.height) * 0.012
    ]
    let subtitleAttrs: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: min(size.width, size.height) * 0.028, weight: .semibold),
        .foregroundColor: (darkMode ? BrandPalette.cream : BrandPalette.ink).withAlphaComponent(0.68),
        .kern: min(size.width, size.height) * 0.004
    ]

    let titleSize = title.size(withAttributes: titleAttrs)
    let subtitleSize = subtitle.size(withAttributes: subtitleAttrs)
    title.draw(
        at: CGPoint(x: (size.width - titleSize.width) * 0.5, y: size.height * 0.24),
        withAttributes: titleAttrs
    )
    subtitle.draw(
        at: CGPoint(x: (size.width - subtitleSize.width) * 0.5, y: size.height * 0.18),
        withAttributes: subtitleAttrs
    )

    image.unlockFocus()
    return image
}

func drawSplashMark(size: CGSize, darkMode: Bool) -> NSImage {
    let image = NSImage(size: size)
    image.lockFocus()

    let fullRect = CGRect(origin: .zero, size: size)
    NSColor.clear.setFill()
    fullRect.fill()

    let emblemSize = min(size.width, size.height) * 0.68
    let emblemRect = CGRect(
        x: (size.width - emblemSize) * 0.5,
        y: (size.height - emblemSize) * 0.5,
        width: emblemSize,
        height: emblemSize
    )

    let auraRect = emblemRect.insetBy(dx: -emblemSize * 0.12, dy: -emblemSize * 0.12)
    let aura = NSBezierPath(ovalIn: auraRect)
    (darkMode ? BrandPalette.teal : BrandPalette.gold).withAlphaComponent(0.14).setFill()
    aura.fill()

    let badge = hexagonPath(in: emblemRect)
    NSGraphicsContext.saveGraphicsState()
    badge.addClip()
    drawGradient(
        darkMode ? [BrandPalette.teal, BrandPalette.ink] : [BrandPalette.gold, BrandPalette.ember],
        in: badge.bounds,
        angle: 270
    )
    NSGraphicsContext.restoreGraphicsState()

    badge.lineWidth = emblemSize * 0.032
    (darkMode ? BrandPalette.cream : BrandPalette.ink).withAlphaComponent(0.78).setStroke()
    badge.stroke()
    drawQuestMark(in: emblemRect, darkMode: darkMode)

    image.unlockFocus()
    return image
}

func write(_ image: NSImage, to url: URL) throws {
    guard let data = pngData(from: image) else {
        throw NSError(domain: "brand", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode PNG"])
    }
    try data.write(to: url)
}

let fileManager = FileManager.default
let root = URL(fileURLWithPath: fileManager.currentDirectoryPath)
let imageDir = root.appendingPathComponent("assets/images", isDirectory: true)

try write(drawIcon(size: 1024), to: imageDir.appendingPathComponent("app_icon.png"))
try write(drawIcon(size: 1024), to: imageDir.appendingPathComponent("icon.png"))
try write(drawSplashLogo(size: CGSize(width: 960, height: 1088), darkMode: false), to: imageDir.appendingPathComponent("splash_logo.png"))
try write(drawSplashLogo(size: CGSize(width: 960, height: 1088), darkMode: true), to: imageDir.appendingPathComponent("splash_logo_dark.png"))
try write(drawSplashMark(size: CGSize(width: 960, height: 960), darkMode: false), to: imageDir.appendingPathComponent("splash_mark.png"))
try write(drawSplashMark(size: CGSize(width: 960, height: 960), darkMode: true), to: imageDir.appendingPathComponent("splash_mark_dark.png"))

print("Brand assets generated in \(imageDir.path)")
