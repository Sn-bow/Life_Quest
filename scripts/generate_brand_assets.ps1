using namespace System.Drawing
using namespace System.Drawing.Drawing2D
using namespace System.Drawing.Imaging
using namespace System.Drawing.Text

Add-Type -AssemblyName System.Drawing

function Get-Color([string]$hex, [int]$alpha = 255) {
    $hex = $hex.TrimStart('#')
    return [Color]::FromArgb($alpha, [Convert]::ToInt32($hex.Substring(0, 2), 16), [Convert]::ToInt32($hex.Substring(2, 2), 16), [Convert]::ToInt32($hex.Substring(4, 2), 16))
}

function New-Bitmap([int]$w, [int]$h) {
    $bmp = [Bitmap]::new($w, $h)
    $bmp.SetResolution(144, 144)
    return $bmp
}

function New-Graphics([Bitmap]$bmp) {
    $g = [Graphics]::FromImage($bmp)
    $g.SmoothingMode = [SmoothingMode]::AntiAlias
    $g.InterpolationMode = [InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [PixelOffsetMode]::HighQuality
    $g.CompositingQuality = [CompositingQuality]::HighQuality
    $g.TextRenderingHint = [TextRenderingHint]::AntiAliasGridFit
    return $g
}

function New-RoundedRectPath([RectangleF]$rect, [float]$radius) {
    $path = [GraphicsPath]::new()
    $diam = $radius * 2
    $path.AddArc($rect.X, $rect.Y, $diam, $diam, 180, 90)
    $path.AddArc($rect.Right - $diam, $rect.Y, $diam, $diam, 270, 90)
    $path.AddArc($rect.Right - $diam, $rect.Bottom - $diam, $diam, $diam, 0, 90)
    $path.AddArc($rect.X, $rect.Bottom - $diam, $diam, $diam, 90, 90)
    $path.CloseFigure()
    return $path
}

function Draw-GlowCircle($g, [float]$cx, [float]$cy, [float]$radius, [Color]$color, [int]$steps = 12) {
    for ($i = $steps; $i -ge 1; $i--) {
        $scale = $i / $steps
        $r = $radius * $scale
        $alpha = [Math]::Max(4, [Math]::Min(90, [int]($color.A * ($scale * $scale))))
        $brush = [SolidBrush]::new([Color]::FromArgb($alpha, $color.R, $color.G, $color.B))
        $g.FillEllipse($brush, $cx - $r, $cy - $r, $r * 2, $r * 2)
        $brush.Dispose()
    }
}

function Draw-Spark($g, [float]$cx, [float]$cy, [float]$size, [Color]$color) {
    $pen = [Pen]::new($color, [Math]::Max(2, $size * 0.11))
    $pen.StartCap = [LineCap]::Round
    $pen.EndCap = [LineCap]::Round
    $g.DrawLine($pen, $cx, $cy - $size, $cx, $cy + $size)
    $g.DrawLine($pen, $cx - $size, $cy, $cx + $size, $cy)
    $g.DrawLine($pen, $cx - ($size * 0.68), $cy - ($size * 0.68), $cx + ($size * 0.68), $cy + ($size * 0.68))
    $g.DrawLine($pen, $cx - ($size * 0.68), $cy + ($size * 0.68), $cx + ($size * 0.68), $cy - ($size * 0.68))
    $pen.Dispose()
}

function Draw-Emblem($g, [float]$cx, [float]$cy, [float]$size) {
    Draw-GlowCircle $g $cx $cy ($size * 0.56) (Get-Color '#FFE08D' 120) 16
    Draw-GlowCircle $g ($cx - ($size * 0.18)) ($cy - ($size * 0.20)) ($size * 0.42) (Get-Color '#51E5C5' 60) 12
    Draw-GlowCircle $g ($cx + ($size * 0.22)) ($cy + ($size * 0.18)) ($size * 0.34) (Get-Color '#7E66FF' 50) 10

    $ringPen = [Pen]::new((Get-Color '#FFF6D8' 180), $size * 0.03)
    $g.DrawEllipse($ringPen, $cx - ($size * 0.44), $cy - ($size * 0.44), $size * 0.88, $size * 0.88)
    $ringPen.Dispose()

    $shadowPath = [GraphicsPath]::new()
    $shieldPts = @(
        [PointF]::new($cx, $cy - ($size * 0.34)),
        [PointF]::new($cx + ($size * 0.28), $cy - ($size * 0.14)),
        [PointF]::new($cx + ($size * 0.22), $cy + ($size * 0.22)),
        [PointF]::new($cx, $cy + ($size * 0.38)),
        [PointF]::new($cx - ($size * 0.22), $cy + ($size * 0.22)),
        [PointF]::new($cx - ($size * 0.28), $cy - ($size * 0.14))
    )
    $shadowPts = $shieldPts | ForEach-Object { [PointF]::new($_.X + ($size * 0.02), $_.Y + ($size * 0.035)) }
    $shadowPath.AddPolygon($shadowPts)
    $shadowBrush = [SolidBrush]::new((Get-Color '#091327' 70))
    $g.FillPath($shadowBrush, $shadowPath)
    $shadowBrush.Dispose()
    $shadowPath.Dispose()

    $shieldPath = [GraphicsPath]::new()
    $shieldPath.AddPolygon($shieldPts)
    $shieldBrush = [LinearGradientBrush]::new(
        [PointF]::new($cx - ($size * 0.22), $cy - ($size * 0.30)),
        [PointF]::new($cx + ($size * 0.18), $cy + ($size * 0.32)),
        (Get-Color '#FFE9A0'),
        (Get-Color '#E5A539')
    )
    $g.FillPath($shieldBrush, $shieldPath)
    $shieldBrush.Dispose()
    $shieldPen = [Pen]::new((Get-Color '#FFF9E7'), $size * 0.022)
    $g.DrawPath($shieldPen, $shieldPath)
    $shieldPen.Dispose()

    $innerPath = [GraphicsPath]::new()
    $innerPts = @(
        [PointF]::new($cx, $cy - ($size * 0.24)),
        [PointF]::new($cx + ($size * 0.18), $cy - ($size * 0.10)),
        [PointF]::new($cx + ($size * 0.14), $cy + ($size * 0.14)),
        [PointF]::new($cx, $cy + ($size * 0.26)),
        [PointF]::new($cx - ($size * 0.14), $cy + ($size * 0.14)),
        [PointF]::new($cx - ($size * 0.18), $cy - ($size * 0.10))
    )
    $innerPath.AddPolygon($innerPts)
    $innerBrush = [SolidBrush]::new((Get-Color '#FFF9EC' 70))
    $g.FillPath($innerBrush, $innerPath)
    $innerBrush.Dispose()
    $innerPath.Dispose()

    $glowPen = [Pen]::new((Get-Color '#47E6C4' 120), $size * 0.08)
    $glowPen.StartCap = [LineCap]::Round
    $glowPen.EndCap = [LineCap]::Round
    $glowPen.LineJoin = [LineJoin]::Round
    $checkPts = @(
        [PointF]::new($cx - ($size * 0.16), $cy + ($size * 0.02)),
        [PointF]::new($cx - ($size * 0.03), $cy + ($size * 0.16)),
        [PointF]::new($cx + ($size * 0.19), $cy - ($size * 0.11))
    )
    $g.DrawLines($glowPen, $checkPts)
    $glowPen.Dispose()

    $checkPen = [Pen]::new((Get-Color '#FFFFFF'), $size * 0.05)
    $checkPen.StartCap = [LineCap]::Round
    $checkPen.EndCap = [LineCap]::Round
    $checkPen.LineJoin = [LineJoin]::Round
    $g.DrawLines($checkPen, $checkPts)
    $checkPen.Dispose()

    Draw-Spark $g ($cx + ($size * 0.30)) ($cy - ($size * 0.30)) ($size * 0.07) (Get-Color '#5BE8C4')
    Draw-Spark $g ($cx - ($size * 0.29)) ($cy + ($size * 0.28)) ($size * 0.05) (Get-Color '#FFE08D' 200)
    $shieldPath.Dispose()
}

function Draw-BackgroundPattern($g, [int]$w, [int]$h, [bool]$dark) {
    if ($dark) {
        $bgBrush = [LinearGradientBrush]::new([PointF]::new(0,0), [PointF]::new($w, $h), (Get-Color '#091327'), (Get-Color '#142A52'))
    } else {
        $bgBrush = [LinearGradientBrush]::new([PointF]::new(0,0), [PointF]::new($w, $h), (Get-Color '#FFF5D9'), (Get-Color '#F6E0B0'))
    }
    $g.FillRectangle($bgBrush, 0, 0, $w, $h)
    $bgBrush.Dispose()

    if ($dark) {
        Draw-GlowCircle $g ($w * 0.18) ($h * 0.16) ($w * 0.26) (Get-Color '#4BE3C2' 24) 12
        Draw-GlowCircle $g ($w * 0.84) ($h * 0.22) ($w * 0.22) (Get-Color '#7A69FF' 28) 12
        Draw-GlowCircle $g ($w * 0.78) ($h * 0.84) ($w * 0.28) (Get-Color '#FFD87B' 22) 12
    } else {
        Draw-GlowCircle $g ($w * 0.14) ($h * 0.14) ($w * 0.26) (Get-Color '#FFFFFF' 60) 12
        Draw-GlowCircle $g ($w * 0.86) ($h * 0.18) ($w * 0.20) (Get-Color '#A9F2E3' 38) 10
        Draw-GlowCircle $g ($w * 0.82) ($h * 0.82) ($w * 0.24) (Get-Color '#FFE8AE' 52) 12
    }

    $penColor = if ($dark) { Get-Color '#FFFFFF' 20 } else { Get-Color '#1F2D5A' 16 }
    $patternPen = [Pen]::new($penColor, 3)
    for ($i = -2; $i -le 8; $i++) {
        $x = $i * ($w / 5)
        $g.DrawBezier($patternPen, $x, 0, $x + ($w * 0.12), ($h * 0.22), $x - ($w * 0.08), ($h * 0.72), $x + ($w * 0.05), $h)
    }
    $patternPen.Dispose()
}

function Save-Png($bmp, [string]$path) {
    $dir = Split-Path $path -Parent
    if ($dir) { New-Item -ItemType Directory -Force $dir | Out-Null }
    $bmp.Save((Resolve-Path -LiteralPath $dir).Path + '\\' + (Split-Path $path -Leaf), [ImageFormat]::Png)
}

function Write-Png([Bitmap]$bmp, [string]$path) {
    $dir = Split-Path $path -Parent
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }
    $bmp.Save($path, [ImageFormat]::Png)
}

function Resize-Image([string]$sourcePath, [string]$targetPath, [int]$w, [int]$h) {
    $src = [Image]::FromFile((Resolve-Path $sourcePath))
    $bmp = New-Bitmap $w $h
    $g = New-Graphics $bmp
    $g.Clear([Color]::Transparent)
    $g.DrawImage($src, 0, 0, $w, $h)
    $g.Dispose()
    $src.Dispose()
    Write-Png $bmp $targetPath
    $bmp.Dispose()
}

function New-IconMaster([string]$path) {
    $size = 1024
    $bmp = New-Bitmap $size $size
    $g = New-Graphics $bmp
    $g.Clear((Get-Color '#13295A'))

    $bgBrush = [LinearGradientBrush]::new([PointF]::new(0,0), [PointF]::new($size, $size), (Get-Color '#0E1B3D'), (Get-Color '#2F3E86'))
    $g.FillRectangle($bgBrush, 0, 0, $size, $size)
    $bgBrush.Dispose()

    Draw-GlowCircle $g 250 200 280 (Get-Color '#45DFC2' 42) 12
    Draw-GlowCircle $g 760 240 220 (Get-Color '#7965FF' 40) 12
    Draw-GlowCircle $g 760 820 300 (Get-Color '#FFD56B' 36) 14

    $orbitPen = [Pen]::new((Get-Color '#FFFFFF' 26), 10)
    $g.DrawArc($orbitPen, 160, 160, 700, 700, 200, 160)
    $g.DrawArc($orbitPen, 180, 180, 660, 660, 15, 135)
    $orbitPen.Dispose()

    Draw-Emblem $g 512 515 520
    Draw-Spark $g 238 312 20 (Get-Color '#FFF0C8' 180)
    Draw-Spark $g 808 334 14 (Get-Color '#5AE7C4' 180)

    $framePath = New-RoundedRectPath ([RectangleF]::new(30, 30, 964, 964)) 190
    $framePen = [Pen]::new((Get-Color '#FFF7DE' 88), 6)
    $g.DrawPath($framePen, $framePath)
    $framePen.Dispose()
    $framePath.Dispose()

    $g.Dispose()
    Write-Png $bmp $path
    $bmp.Dispose()
}

function New-SplashBackground([string]$path, [bool]$dark) {
    $bmp = New-Bitmap 1080 1920
    $g = New-Graphics $bmp
    Draw-BackgroundPattern $g 1080 1920 $dark

    $linePen = [Pen]::new($(if ($dark) { Get-Color '#FFFFFF' 12 } else { Get-Color '#1D2655' 12 }), 4)
    for ($i = 0; $i -lt 5; $i++) {
        $y = 300 + ($i * 70)
        $g.DrawArc($linePen, -120, $y, 420, 220, 310, 90)
        $g.DrawArc($linePen, 760, $y + 520, 420, 220, 130, 90)
    }
    $linePen.Dispose()

    $g.Dispose()
    Write-Png $bmp $path
    $bmp.Dispose()
}

function Get-Font([string[]]$names, [float]$size, [FontStyle]$style) {
    foreach ($name in $names) {
        try { return [Font]::new($name, $size, $style, [GraphicsUnit]::Pixel) } catch {}
    }
    return [Font]::new('Arial', $size, $style, [GraphicsUnit]::Pixel)
}

function Draw-CenteredText($g, [string]$text, [Font]$font, [Brush]$brush, [float]$y, [int]$width) {
    $fmt = [StringFormat]::new()
    $fmt.Alignment = [StringAlignment]::Center
    $fmt.LineAlignment = [StringAlignment]::Center
    $rect = [RectangleF]::new(0, $y, $width, $font.Height + 20)
    $g.DrawString($text, $font, $brush, $rect, $fmt)
    $fmt.Dispose()
}

function New-SplashLogo([string]$path, [bool]$dark) {
    $w = 960; $h = 1088
    $bmp = New-Bitmap $w $h
    $g = New-Graphics $bmp
    $g.Clear([Color]::Transparent)

    Draw-GlowCircle $g ($w * 0.5) 285 170 $(if ($dark) { Get-Color '#4BE3C2' 28 } else { Get-Color '#FFFFFF' 70 }) 10
    Draw-GlowCircle $g ($w * 0.62) 290 135 $(if ($dark) { Get-Color '#FFD87B' 22 } else { Get-Color '#FFE8A6' 56 }) 10
    Draw-Emblem $g ($w * 0.5) 308 285

    $titleMain = Get-Font @('Segoe UI Semibold', 'Arial') 86 ([FontStyle]::Bold)
    $titleAccent = Get-Font @('Segoe UI Semibold', 'Arial') 86 ([FontStyle]::Bold)
    $subtitleFont = Get-Font @('Malgun Gothic', 'Segoe UI', 'Arial') 30 ([FontStyle]::Regular)
    $captionFont = Get-Font @('Segoe UI', 'Arial') 20 ([FontStyle]::Regular)

    $mainBrush = [SolidBrush]::new($(if ($dark) { Get-Color '#F4F7FF' } else { Get-Color '#13224F' }))
    $accentBrush = [SolidBrush]::new($(if ($dark) { Get-Color '#FFD779' } else { Get-Color '#D28D27' }))
    $subBrush = [SolidBrush]::new($(if ($dark) { Get-Color '#79EAD0' } else { Get-Color '#355B8C' }))
    $captionBrush = [SolidBrush]::new($(if ($dark) { Get-Color '#C9D6EF' 220 } else { Get-Color '#5E6A85' 220 }))

    Draw-CenteredText $g 'LIFE' $titleMain $mainBrush 620 $w
    Draw-CenteredText $g 'QUEST' $titleAccent $accentBrush 706 $w
    Draw-CenteredText $g '습관을 경험치로' $subtitleFont $subBrush 810 $w
    Draw-CenteredText $g 'Daily habits become RPG progress' $captionFont $captionBrush 860 $w

    $dotBrush1 = [SolidBrush]::new($(if ($dark) { Get-Color '#79EAD0' } else { Get-Color '#335E8F' }))
    $dotBrush2 = [SolidBrush]::new($(if ($dark) { Get-Color '#FFD779' } else { Get-Color '#D49A31' }))
    $dotBrush3 = [SolidBrush]::new($(if ($dark) { Get-Color '#F4F7FF' } else { Get-Color '#13224F' }))
    $g.FillEllipse($dotBrush1, 418, 930, 18, 18)
    $g.FillEllipse($dotBrush2, 471, 930, 18, 18)
    $g.FillEllipse($dotBrush3, 524, 930, 18, 18)
    $g.FillEllipse($dotBrush2, 577, 930, 18, 18)

    foreach ($obj in @($titleMain,$titleAccent,$subtitleFont,$captionFont,$mainBrush,$accentBrush,$subBrush,$captionBrush,$dotBrush1,$dotBrush2,$dotBrush3)) { $obj.Dispose() }
    $g.Dispose()
    Write-Png $bmp $path
    $bmp.Dispose()
}

$root = Resolve-Path (Join-Path $PSScriptRoot '..')
Set-Location $root

$iconMaster = Join-Path $root 'assets\images\app_icon.png'
$legacyIcon = Join-Path $root 'assets\images\icon.png'
$lightSplash = Join-Path $root 'assets\images\splash_logo.png'
$darkSplash = Join-Path $root 'assets\images\splash_logo_dark.png'
$lightBg = Join-Path $root 'assets\images\splash_background_light.png'
$darkBg = Join-Path $root 'assets\images\splash_background_dark.png'

New-IconMaster $iconMaster
Copy-Item $iconMaster $legacyIcon -Force
New-SplashLogo $lightSplash $false
New-SplashLogo $darkSplash $true
New-SplashBackground $lightBg $false
New-SplashBackground $darkBg $true

# Android icons
foreach ($density in @{
    'mdpi' = 48; 'hdpi' = 72; 'xhdpi' = 96; 'xxhdpi' = 144; 'xxxhdpi' = 192
}.GetEnumerator()) {
    foreach ($name in @('ic_launcher.png', 'launcher_icon.png')) {
        $target = Join-Path $root "android\app\src\main\res\mipmap-$($density.Key)\$name"
        Resize-Image $iconMaster $target $density.Value $density.Value
    }
}

# iOS app icons based on existing slot sizes
Get-ChildItem (Join-Path $root 'ios\Runner\Assets.xcassets\AppIcon.appiconset') -Filter '*.png' | ForEach-Object {
    $img = [Image]::FromFile($_.FullName)
    $w = $img.Width; $h = $img.Height; $img.Dispose()
    Resize-Image $iconMaster $_.FullName $w $h
}

# Android splash foregrounds based on existing sizes
Get-ChildItem (Join-Path $root 'android\app\src\main\res') -Recurse -Filter 'splash.png' | ForEach-Object {
    $img = [Image]::FromFile($_.FullName)
    $w = $img.Width; $h = $img.Height; $img.Dispose()
    $source = if ($_.FullName -match 'drawable-night') { $darkSplash } else { $lightSplash }
    Resize-Image $source $_.FullName $w $h
}

# Android splash backgrounds
foreach ($bgPath in @(
    'android\app\src\main\res\drawable\background.png',
    'android\app\src\main\res\drawable-v21\background.png',
    'android\app\src\main\res\drawable-night\background.png',
    'android\app\src\main\res\drawable-night-v21\background.png'
)) {
    $source = if ($bgPath -match 'night') { $darkBg } else { $lightBg }
    Copy-Item $source (Join-Path $root $bgPath) -Force
}

# iOS splash images based on existing slot sizes
Get-ChildItem (Join-Path $root 'ios\Runner\Assets.xcassets\LaunchImage.imageset') -Filter '*.png' | ForEach-Object {
    $img = [Image]::FromFile($_.FullName)
    $w = $img.Width; $h = $img.Height; $img.Dispose()
    $source = if ($_.Name -match 'Dark') { $darkSplash } else { $lightSplash }
    Resize-Image $source $_.FullName $w $h
}

# iOS splash backgrounds
Copy-Item $lightBg (Join-Path $root 'ios\Runner\Assets.xcassets\LaunchBackground.imageset\background.png') -Force
Copy-Item $darkBg (Join-Path $root 'ios\Runner\Assets.xcassets\LaunchBackground.imageset\darkbackground.png') -Force

Write-Output 'brand-assets-generated'



