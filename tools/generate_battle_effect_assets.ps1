Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = "Stop"

$outDir = Join-Path (Get-Location) "assets/images/game/effects"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

function New-TransparentBitmap($width, $height) {
    $bitmap = New-Object System.Drawing.Bitmap $width, $height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.Clear([System.Drawing.Color]::Transparent)
    return @{ Bitmap = $bitmap; Graphics = $graphics }
}

function Save-Png($canvas, $path) {
    $canvas.Graphics.Flush()
    $canvas.Bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $canvas.Graphics.Dispose()
    $canvas.Bitmap.Dispose()
}

function New-Color($alpha, $red, $green, $blue) {
    return [System.Drawing.Color]::FromArgb($alpha, $red, $green, $blue)
}

function Draw-GlowLine($graphics, $x1, $y1, $x2, $y2, $baseColor) {
    foreach ($step in @(30, 22, 15, 9)) {
        $alpha = [Math]::Max(18, [int](190 / ($step / 5)))
        $pen = [System.Drawing.Pen]::new((New-Color $alpha $baseColor.R $baseColor.G $baseColor.B), [float]$step)
        $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
        $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
        $graphics.DrawLine($pen, $x1, $y1, $x2, $y2)
        $pen.Dispose()
    }
    $core = [System.Drawing.Pen]::new((New-Color 245 255 255 238), 5)
    $core.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $core.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $graphics.DrawLine($core, $x1, $y1, $x2, $y2)
    $core.Dispose()
}

function Draw-StarBurst($graphics, $cx, $cy, $radius, $color) {
    for ($i = 0; $i -lt 18; $i++) {
        $angle = ($i / 18.0) * [Math]::PI * 2
        $inner = $radius * 0.18
        $outer = $radius * (0.58 + (($i % 3) * 0.12))
        $x1 = $cx + [Math]::Cos($angle) * $inner
        $y1 = $cy + [Math]::Sin($angle) * $inner
        $x2 = $cx + [Math]::Cos($angle) * $outer
        $y2 = $cy + [Math]::Sin($angle) * $outer
        $pen = [System.Drawing.Pen]::new((New-Color 125 $color.R $color.G $color.B), [float](2 + ($i % 4)))
        $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
        $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
        $graphics.DrawLine($pen, [float]$x1, [float]$y1, [float]$x2, [float]$y2)
        $pen.Dispose()
    }
}

# Attack slash: broad painterly blade streak with warm sparks.
$canvas = New-TransparentBitmap 512 192
$g = $canvas.Graphics
Draw-GlowLine $g 52 144 454 42 ([System.Drawing.Color]::FromArgb(255, 255, 184, 48))
Draw-GlowLine $g 92 168 478 72 ([System.Drawing.Color]::FromArgb(255, 255, 116, 48))
Draw-GlowLine $g 34 104 410 18 ([System.Drawing.Color]::FromArgb(255, 255, 228, 126))
for ($i = 0; $i -lt 28; $i++) {
    $x = 60 + ($i * 15) % 390
    $y = 34 + (($i * 37) % 128)
    $size = 2 + ($i % 5)
    $brush = New-Object System.Drawing.SolidBrush (New-Color (120 + (($i % 4) * 22)) 255 218 108)
    $g.FillEllipse($brush, $x, $y, $size, $size)
    $brush.Dispose()
}
Save-Png $canvas (Join-Path $outDir "effect_attack_slash.png")

# Defense shield: luminous gold-blue crest usable as a raised guard.
$canvas = New-TransparentBitmap 256 256
$g = $canvas.Graphics
$center = New-Object System.Drawing.PointF 128, 128
foreach ($diameter in @(210, 176, 140)) {
    $rect = New-Object System.Drawing.RectangleF ((256 - $diameter) / 2), ((256 - $diameter) / 2), $diameter, $diameter
    $pen = [System.Drawing.Pen]::new((New-Color 46 107 232 255), [float](((216 - $diameter) / 9) + 2))
    $g.DrawEllipse($pen, $rect)
    $pen.Dispose()
}
$shield = New-Object System.Drawing.Drawing2D.GraphicsPath
$shield.AddPolygon(@(
    (New-Object System.Drawing.PointF 128, 28),
    (New-Object System.Drawing.PointF 206, 64),
    (New-Object System.Drawing.PointF 188, 170),
    (New-Object System.Drawing.PointF 128, 226),
    (New-Object System.Drawing.PointF 68, 170),
    (New-Object System.Drawing.PointF 50, 64)
))
$fill = New-Object System.Drawing.Drawing2D.LinearGradientBrush (New-Object System.Drawing.Rectangle 48, 26, 160, 202), (New-Color 70 80 203 255), (New-Color 105 255 211 96), 90
$g.FillPath($fill, $shield)
$fill.Dispose()
$outline = [System.Drawing.Pen]::new((New-Color 225 238 255 228), 6)
$outline.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$g.DrawPath($outline, $shield)
$outline.Dispose()
$inner = [System.Drawing.Pen]::new((New-Color 125 89 225 255), 3)
$inner.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$g.DrawPath($inner, $shield)
$inner.Dispose()
$shield.Dispose()
Save-Png $canvas (Join-Path $outDir "effect_defense_shield.png")

# Magic projectile: violet orb with a comet tail.
$canvas = New-TransparentBitmap 256 256
$g = $canvas.Graphics
for ($i = 0; $i -lt 8; $i++) {
    $diameter = 172 - $i * 16
    $alpha = 24 + $i * 16
    $brush = New-Object System.Drawing.SolidBrush (New-Color $alpha 178 79 255)
    $g.FillEllipse($brush, (128 - $diameter / 2), (128 - $diameter / 2), $diameter, $diameter)
    $brush.Dispose()
}
for ($i = 0; $i -lt 5; $i++) {
    $pen = [System.Drawing.Pen]::new((New-Color (80 - $i * 10) 119 231 255), [float](18 - $i * 2))
    $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawBezier($pen, 122, 132, 70 - $i * 6, 138 + $i * 10, 44 - $i * 10, 170, 12, 214)
    $pen.Dispose()
}
$core1 = New-Object System.Drawing.SolidBrush (New-Color 245 235 172 255)
$core2 = New-Object System.Drawing.SolidBrush (New-Color 255 255 250 255)
$g.FillEllipse($core1, 86, 84, 84, 84)
$g.FillEllipse($core2, 110, 104, 34, 34)
$core1.Dispose()
$core2.Dispose()
Save-Png $canvas (Join-Path $outDir "effect_magic_projectile.png")

# Enemy death burst: violet-white shatter bloom.
$canvas = New-TransparentBitmap 256 256
$g = $canvas.Graphics
Draw-StarBurst $g 128 128 132 ([System.Drawing.Color]::FromArgb(255, 202, 132, 255))
for ($i = 0; $i -lt 20; $i++) {
    $angle = ($i / 20.0) * [Math]::PI * 2
    $dist = 36 + (($i * 29) % 86)
    $x = 128 + [Math]::Cos($angle) * $dist
    $y = 128 + [Math]::Sin($angle) * $dist
    $w = 7 + ($i % 5) * 3
    $h = 4 + ($i % 4) * 3
    $brush = New-Object System.Drawing.SolidBrush (New-Color 170 210 154 255)
    $g.TranslateTransform([float]$x, [float]$y)
    $g.RotateTransform([float](($angle * 180 / [Math]::PI) + 25))
    $g.FillRectangle($brush, -$w / 2, -$h / 2, $w, $h)
    $g.ResetTransform()
    $brush.Dispose()
}
$flash = New-Object System.Drawing.SolidBrush (New-Color 230 255 255 255)
$g.FillEllipse($flash, 92, 92, 72, 72)
$flash.Dispose()
Save-Png $canvas (Join-Path $outDir "effect_enemy_death_burst.png")
