import AppKit
import Foundation

enum BrandPalette {
    static let cream = NSColor(calibratedRed: 0.88, green: 0.93, blue: 0.98, alpha: 1.0)
    static let night = NSColor(calibratedRed: 0.02, green: 0.05, blue: 0.10, alpha: 1.0)
    static let gold = NSColor(calibratedRed: 0.55, green: 0.84, blue: 1.00, alpha: 1.0)
    static let ember = NSColor(calibratedRed: 0.15, green: 0.37, blue: 0.62, alpha: 1.0)
    static let teal = NSColor(calibratedRed: 0.06, green: 0.86, blue: 0.92, alpha: 1.0)
    static let ink = NSColor(calibratedRed: 0.07, green: 0.13, blue: 0.20, alpha: 1.0)
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

func drawSpark(in rect: CGRect, color: NSColor) {
    let star = NSBezierPath()
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let outerRadius = min(rect.width, rect.height) * 0.5
    let innerRadius = outerRadius * 0.42
    for i in 0..<8 {
        let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius
        let angle = CGFloat(Double(i) * .pi / 4.0 - .pi / 2.0)
        let point = CGPoint(
            x: center.x + cos(angle) * radius,
            y: center.y + sin(angle) * radius
        )
        if i == 0 {
            star.move(to: point)
        } else {
            star.line(to: point)
        }
    }
    star.close()
    color.setFill()
    star.fill()
}

func shieldPath(in rect: CGRect) -> NSBezierPath {
    let path = NSBezierPath()
    path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
    path.curve(
        to: CGPoint(x: rect.maxX, y: rect.maxY - rect.height * 0.20),
        controlPoint1: CGPoint(x: rect.midX + rect.width * 0.18, y: rect.maxY),
        controlPoint2: CGPoint(x: rect.maxX, y: rect.maxY - rect.height * 0.04)
    )
    path.line(to: CGPoint(x: rect.maxX - rect.width * 0.02, y: rect.minY + rect.height * 0.34))
    path.curve(
        to: CGPoint(x: rect.midX, y: rect.minY),
        controlPoint1: CGPoint(x: rect.maxX - rect.width * 0.02, y: rect.minY + rect.height * 0.18),
        controlPoint2: CGPoint(x: rect.midX + rect.width * 0.20, y: rect.minY + rect.height * 0.03)
    )
    path.curve(
        to: CGPoint(x: rect.minX + rect.width * 0.02, y: rect.minY + rect.height * 0.34),
        controlPoint1: CGPoint(x: rect.midX - rect.width * 0.20, y: rect.minY + rect.height * 0.03),
        controlPoint2: CGPoint(x: rect.minX + rect.width * 0.02, y: rect.minY + rect.height * 0.18)
    )
    path.line(to: CGPoint(x: rect.minX, y: rect.maxY - rect.height * 0.20))
    path.curve(
        to: CGPoint(x: rect.midX, y: rect.maxY),
        controlPoint1: CGPoint(x: rect.minX, y: rect.maxY - rect.height * 0.04),
        controlPoint2: CGPoint(x: rect.midX - rect.width * 0.18, y: rect.maxY)
    )
    path.close()
    return path
}

func scrollPath(in rect: CGRect) -> NSBezierPath {
    let curl = rect.width * 0.15
    let path = NSBezierPath()
    path.move(to: CGPoint(x: rect.minX + curl, y: rect.maxY))
    path.line(to: CGPoint(x: rect.maxX - curl, y: rect.maxY))
    path.curve(
        to: CGPoint(x: rect.maxX, y: rect.maxY - curl),
        controlPoint1: CGPoint(x: rect.maxX - curl * 0.25, y: rect.maxY),
        controlPoint2: CGPoint(x: rect.maxX, y: rect.maxY - curl * 0.25)
    )
    path.line(to: CGPoint(x: rect.maxX, y: rect.minY + curl))
    path.curve(
        to: CGPoint(x: rect.maxX - curl, y: rect.minY),
        controlPoint1: CGPoint(x: rect.maxX, y: rect.minY + curl * 0.25),
        controlPoint2: CGPoint(x: rect.maxX - curl * 0.25, y: rect.minY)
    )
    path.line(to: CGPoint(x: rect.minX + curl, y: rect.minY))
    path.curve(
        to: CGPoint(x: rect.minX, y: rect.minY + curl),
        controlPoint1: CGPoint(x: rect.minX + curl * 0.25, y: rect.minY),
        controlPoint2: CGPoint(x: rect.minX, y: rect.minY + curl * 0.25)
    )
    path.line(to: CGPoint(x: rect.minX, y: rect.maxY - curl))
    path.curve(
        to: CGPoint(x: rect.minX + curl, y: rect.maxY),
        controlPoint1: CGPoint(x: rect.minX, y: rect.maxY - curl * 0.25),
        controlPoint2: CGPoint(x: rect.minX + curl * 0.25, y: rect.maxY)
    )
    path.close()
    return path
}

func drawScrollBadgeEmblem(in rect: CGRect, strokeColor: NSColor, accentColor: NSColor, starColor: NSColor) {
    let auraRect = rect.insetBy(dx: rect.width * 0.05, dy: rect.height * 0.05)
    let aura = NSBezierPath(ovalIn: auraRect)
    BrandPalette.teal.withAlphaComponent(0.16).setStroke()
    aura.lineWidth = rect.width * 0.016
    aura.stroke()

    let outerRingRect = rect.insetBy(dx: rect.width * 0.14, dy: rect.height * 0.14)
    let outerRing = NSBezierPath(ovalIn: outerRingRect)
    outerRing.lineWidth = rect.width * 0.020
    BrandPalette.teal.withAlphaComponent(0.70).setStroke()
    outerRing.stroke()

    let innerRingRect = rect.insetBy(dx: rect.width * 0.23, dy: rect.height * 0.23)
    let innerRing = NSBezierPath(ovalIn: innerRingRect)
    innerRing.lineWidth = rect.width * 0.012
    BrandPalette.gold.withAlphaComponent(0.38).setStroke()
    innerRing.stroke()

    for angle in stride(from: 0.0, to: 360.0, by: 45.0) {
        let radians = CGFloat(angle * .pi / 180.0)
        let start = CGPoint(
            x: rect.midX + cos(radians) * rect.width * 0.19,
            y: rect.midY + sin(radians) * rect.height * 0.19
        )
        let end = CGPoint(
            x: rect.midX + cos(radians) * rect.width * 0.29,
            y: rect.midY + sin(radians) * rect.height * 0.29
        )
        let ray = NSBezierPath()
        ray.lineCapStyle = .round
        ray.lineWidth = rect.width * 0.014
        ray.move(to: start)
        ray.line(to: end)
        (angle.truncatingRemainder(dividingBy: 90) == 0 ? BrandPalette.gold : BrandPalette.teal.withAlphaComponent(0.65)).setStroke()
        ray.stroke()
    }

    let coreRect = CGRect(
        x: rect.midX - rect.width * 0.055,
        y: rect.midY - rect.height * 0.15,
        width: rect.width * 0.11,
        height: rect.height * 0.30
    )
    let core = roundedPath(in: coreRect, radius: rect.width * 0.05)
    BrandPalette.teal.withAlphaComponent(0.96).setFill()
    core.fill()

    let innerCore = roundedPath(
        in: coreRect.insetBy(dx: coreRect.width * 0.24, dy: coreRect.height * 0.18),
        radius: rect.width * 0.03
    )
    strokeColor.setFill()
    innerCore.fill()

    let upperOrb = NSBezierPath(ovalIn: CGRect(
        x: rect.midX - rect.width * 0.045,
        y: rect.midY + rect.height * 0.10,
        width: rect.width * 0.09,
        height: rect.width * 0.09
    ))
    BrandPalette.gold.withAlphaComponent(0.72).setFill()
    upperOrb.fill()

    let crescentOuter = NSBezierPath()
    crescentOuter.appendArc(withCenter: CGPoint(x: rect.midX - rect.width * 0.02, y: rect.midY), radius: rect.width * 0.16, startAngle: 128, endAngle: 232)
    let crescentInner = NSBezierPath()
    crescentInner.appendArc(withCenter: CGPoint(x: rect.midX + rect.width * 0.04, y: rect.midY), radius: rect.width * 0.11, startAngle: 120, endAngle: 240)
    crescentOuter.lineWidth = rect.width * 0.026
    BrandPalette.teal.withAlphaComponent(0.88).setStroke()
    crescentOuter.stroke()
    crescentInner.lineWidth = rect.width * 0.018
    BrandPalette.night.withAlphaComponent(0.95).setStroke()
    crescentInner.stroke()

    let runeRing = NSBezierPath(ovalIn: CGRect(
        x: rect.midX - rect.width * 0.17,
        y: rect.midY - rect.height * 0.17,
        width: rect.width * 0.34,
        height: rect.width * 0.34
    ))
    runeRing.lineWidth = rect.width * 0.012
    BrandPalette.gold.withAlphaComponent(0.32).setStroke()
    runeRing.stroke()

    let sigil = NSBezierPath()
    sigil.lineCapStyle = .round
    sigil.lineJoinStyle = .round
    sigil.lineWidth = rect.width * 0.020
    sigil.move(to: CGPoint(x: rect.midX, y: rect.midY + rect.height * 0.24))
    sigil.line(to: CGPoint(x: rect.midX, y: rect.midY + rect.height * 0.15))
    sigil.move(to: CGPoint(x: rect.midX, y: rect.midY - rect.height * 0.15))
    sigil.line(to: CGPoint(x: rect.midX, y: rect.midY - rect.height * 0.24))
    sigil.move(to: CGPoint(x: rect.midX - rect.width * 0.24, y: rect.midY))
    sigil.line(to: CGPoint(x: rect.midX - rect.width * 0.15, y: rect.midY))
    sigil.move(to: CGPoint(x: rect.midX + rect.width * 0.15, y: rect.midY))
    sigil.line(to: CGPoint(x: rect.midX + rect.width * 0.24, y: rect.midY))
    BrandPalette.gold.withAlphaComponent(0.72).setStroke()
    sigil.stroke()

    let lowerRune = NSBezierPath()
    lowerRune.lineCapStyle = .round
    lowerRune.lineJoinStyle = .round
    lowerRune.lineWidth = rect.width * 0.016
    lowerRune.move(to: CGPoint(x: rect.midX - rect.width * 0.11, y: rect.midY - rect.height * 0.20))
    lowerRune.line(to: CGPoint(x: rect.midX, y: rect.midY - rect.height * 0.11))
    lowerRune.line(to: CGPoint(x: rect.midX + rect.width * 0.11, y: rect.midY - rect.height * 0.20))
    BrandPalette.teal.withAlphaComponent(0.78).setStroke()
    lowerRune.stroke()
}

func drawAdaptiveBackground(size: CGFloat) -> NSImage {
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()

    let fullRect = CGRect(x: 0, y: 0, width: size, height: size)
    drawGradient([BrandPalette.night, BrandPalette.ink, BrandPalette.ember], in: fullRect, angle: 315)

    let glowRect = CGRect(
        x: size * 0.08,
        y: size * 0.30,
        width: size * 0.84,
        height: size * 0.62
    )
    let glow = NSBezierPath(ovalIn: glowRect)
    BrandPalette.teal.withAlphaComponent(0.16).setFill()
    glow.fill()

    let verticalAura = NSBezierPath(ovalIn: CGRect(
        x: size * 0.26,
        y: size * 0.06,
        width: size * 0.48,
        height: size * 0.88
    ))
    BrandPalette.teal.withAlphaComponent(0.12).setFill()
    verticalAura.fill()

    let ringRect = fullRect.insetBy(dx: size * 0.14, dy: size * 0.14)
    let ring = NSBezierPath(ovalIn: ringRect)
    ring.lineWidth = size * 0.025
    BrandPalette.teal.withAlphaComponent(0.10).setStroke()
    ring.stroke()

    let innerRingRect = fullRect.insetBy(dx: size * 0.24, dy: size * 0.24)
    let innerRing = NSBezierPath(ovalIn: innerRingRect)
    innerRing.lineWidth = size * 0.018
    BrandPalette.gold.withAlphaComponent(0.14).setStroke()
    innerRing.stroke()

    image.unlockFocus()
    return image
}

func drawAdaptiveForeground(size: CGFloat) -> NSImage {
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()

    let fullRect = CGRect(x: 0, y: 0, width: size, height: size)
    NSColor.clear.setFill()
    fullRect.fill()

    let crestSize = size * 0.68
    let crestRect = CGRect(
        x: (size - crestSize) * 0.5,
        y: (size - crestSize) * 0.5,
        width: crestSize,
        height: crestSize
    )

    drawScrollBadgeEmblem(
        in: crestRect,
        strokeColor: BrandPalette.cream,
        accentColor: BrandPalette.teal,
        starColor: BrandPalette.gold
    )

    image.unlockFocus()
    return image
}

func drawMonochromeForeground(size: CGFloat) -> NSImage {
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()

    let fullRect = CGRect(x: 0, y: 0, width: size, height: size)
    NSColor.clear.setFill()
    fullRect.fill()

    let crestSize = size * 0.68
    let crestRect = CGRect(
        x: (size - crestSize) * 0.5,
        y: (size - crestSize) * 0.5,
        width: crestSize,
        height: crestSize
    )

    let badgeRect = crestRect.insetBy(dx: crestSize * 0.05, dy: crestSize * 0.04)
    let badge = NSBezierPath(ovalIn: badgeRect)
    NSColor.black.setFill()
    badge.fill()

    let scrollRect = CGRect(
        x: crestRect.minX + crestSize * 0.20,
        y: crestRect.minY + crestSize * 0.18,
        width: crestSize * 0.60,
        height: crestSize * 0.56
    )
    let scroll = scrollPath(in: scrollRect)
    scroll.fill()

    let ribbon = NSBezierPath()
    ribbon.move(to: CGPoint(x: crestRect.minX + crestSize * 0.26, y: crestRect.minY + crestSize * 0.20))
    ribbon.line(to: CGPoint(x: crestRect.minX + crestSize * 0.44, y: crestRect.minY))
    ribbon.line(to: CGPoint(x: crestRect.midX, y: crestRect.minY + crestSize * 0.12))
    ribbon.line(to: CGPoint(x: crestRect.minX + crestSize * 0.56, y: crestRect.minY))
    ribbon.line(to: CGPoint(x: crestRect.minX + crestSize * 0.74, y: crestRect.minY + crestSize * 0.20))
    ribbon.close()
    ribbon.fill()

    let titleLine = NSBezierPath()
    titleLine.lineCapStyle = .round
    titleLine.lineWidth = crestSize * 0.032
    titleLine.move(to: CGPoint(x: scrollRect.minX + scrollRect.width * 0.18, y: scrollRect.minY + scrollRect.height * 0.66))
    titleLine.line(to: CGPoint(x: scrollRect.maxX - scrollRect.width * 0.28, y: scrollRect.minY + scrollRect.height * 0.66))
    NSColor.black.setStroke()
    titleLine.stroke()

    let foldedCorner = NSBezierPath()
    foldedCorner.move(to: CGPoint(x: scrollRect.maxX - scrollRect.width * 0.20, y: scrollRect.minY + scrollRect.height * 0.22))
    foldedCorner.line(to: CGPoint(x: scrollRect.maxX - scrollRect.width * 0.03, y: scrollRect.minY + scrollRect.height * 0.22))
    foldedCorner.line(to: CGPoint(x: scrollRect.maxX - scrollRect.width * 0.03, y: scrollRect.minY + scrollRect.height * 0.39))
    foldedCorner.close()
    foldedCorner.fill()

    image.unlockFocus()
    return image
}

func drawIOSIcon(size: CGFloat) -> NSImage {
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()

    let fullRect = CGRect(x: 0, y: 0, width: size, height: size)
    let shape = roundedPath(in: fullRect, radius: size * 0.225)
    NSGraphicsContext.saveGraphicsState()
    shape.addClip()
    drawGradient([BrandPalette.night, BrandPalette.ink, BrandPalette.ember], in: fullRect, angle: 315)

    let glow = NSBezierPath(ovalIn: CGRect(x: size * 0.12, y: size * 0.32, width: size * 0.76, height: size * 0.56))
    BrandPalette.teal.withAlphaComponent(0.16).setFill()
    glow.fill()

    let crestSize = size * 0.62
    let crestRect = CGRect(
        x: (size - crestSize) * 0.5,
        y: size * 0.21,
        width: crestSize,
        height: crestSize
    )
    drawScrollBadgeEmblem(
        in: crestRect,
        strokeColor: BrandPalette.cream,
        accentColor: BrandPalette.teal,
        starColor: BrandPalette.gold
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

    let emblemSize = min(size.width, size.height) * 0.34
    let emblemRect = CGRect(
        x: (size.width - emblemSize) * 0.5,
        y: size.height * 0.43,
        width: emblemSize,
        height: emblemSize
    )

    let auraRect = emblemRect.insetBy(dx: -emblemSize * 0.18, dy: -emblemSize * 0.18)
    let aura = NSBezierPath(ovalIn: auraRect)
    BrandPalette.teal.withAlphaComponent(darkMode ? 0.16 : 0.10).setFill()
    aura.fill()

    drawScrollBadgeEmblem(
        in: emblemRect,
        strokeColor: BrandPalette.cream,
        accentColor: BrandPalette.teal,
        starColor: BrandPalette.gold
    )

    let title = "LIFE QUEST"
    let subtitle = "ARISE YOUR QUEST"
    let titleAttrs: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: min(size.width, size.height) * 0.075, weight: .black),
        .foregroundColor: BrandPalette.cream,
        .kern: min(size.width, size.height) * 0.012
    ]
    let subtitleAttrs: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: min(size.width, size.height) * 0.028, weight: .semibold),
        .foregroundColor: BrandPalette.teal.withAlphaComponent(0.82),
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
    BrandPalette.teal.withAlphaComponent(darkMode ? 0.18 : 0.14).setFill()
    aura.fill()

    drawScrollBadgeEmblem(
        in: emblemRect,
        strokeColor: BrandPalette.cream,
        accentColor: BrandPalette.teal,
        starColor: BrandPalette.gold
    )

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

try write(drawIOSIcon(size: 1024), to: imageDir.appendingPathComponent("app_icon.png"))
try write(drawAdaptiveForeground(size: 1024), to: imageDir.appendingPathComponent("icon.png"))
try write(drawAdaptiveBackground(size: 1024), to: imageDir.appendingPathComponent("app_icon_android_background.png"))
try write(drawAdaptiveForeground(size: 1024), to: imageDir.appendingPathComponent("app_icon_android_foreground.png"))
try write(drawMonochromeForeground(size: 1024), to: imageDir.appendingPathComponent("app_icon_android_monochrome.png"))
try write(drawSplashLogo(size: CGSize(width: 960, height: 1088), darkMode: false), to: imageDir.appendingPathComponent("splash_logo.png"))
try write(drawSplashLogo(size: CGSize(width: 960, height: 1088), darkMode: true), to: imageDir.appendingPathComponent("splash_logo_dark.png"))
try write(drawSplashMark(size: CGSize(width: 960, height: 960), darkMode: false), to: imageDir.appendingPathComponent("splash_mark.png"))
try write(drawSplashMark(size: CGSize(width: 960, height: 960), darkMode: true), to: imageDir.appendingPathComponent("splash_mark_dark.png"))

print("Brand assets generated in \(imageDir.path)")
