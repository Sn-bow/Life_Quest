using namespace System.Drawing
using namespace System.Drawing.Imaging
Add-Type -AssemblyName System.Drawing

function Compose($bgPath, $logoPath, $outPath) {
  $bg = [Image]::FromFile($bgPath)
  $logo = [Image]::FromFile($logoPath)
  $bmp = [Bitmap]::new($bg.Width, $bg.Height)
  $g = [Graphics]::FromImage($bmp)
  $g.DrawImage($bg, 0, 0, $bg.Width, $bg.Height)
  $x = [int](($bg.Width - $logo.Width) / 2)
  $y = [int](($bg.Height - $logo.Height) / 2)
  $g.DrawImage($logo, $x, $y, $logo.Width, $logo.Height)
  $g.Dispose()
  $bg.Dispose()
  $logo.Dispose()
  $bmp.Save($outPath, [ImageFormat]::Png)
  $bmp.Dispose()
}
Compose 'assets/images/splash_background_light.png' 'assets/images/splash_logo.png' 'assets/images/splash_preview_light.png'
Compose 'assets/images/splash_background_dark.png' 'assets/images/splash_logo_dark.png' 'assets/images/splash_preview_dark.png'
