Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = 'Stop'
$dir = 'C:\Users\ambat\OneDrive\Documents\code\bb website\assets\photos'
$enc = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }

$files = Get-ChildItem $dir -File | Where-Object { ($_.Extension -match '^\.(jpg|jpeg)$') -and ($_.Length -gt 1MB) }
Write-Output ("Files over 1MB: " + $files.Count)

foreach ($f in $files) {
  try {
    $img = [System.Drawing.Image]::FromFile($f.FullName)

    # apply EXIF orientation so the re-encode doesn't rotate the photo
    $src = New-Object System.Drawing.Bitmap($img)
    foreach ($prop in $img.PropertyItems) {
      if ($prop.Id -eq 0x0112) {
        $o = $prop.Value[0]
        switch ($o) {
          3 { $src.RotateFlip([System.Drawing.RotateFlipType]::Rotate180FlipNone) }
          6 { $src.RotateFlip([System.Drawing.RotateFlipType]::Rotate90FlipNone) }
          8 { $src.RotateFlip([System.Drawing.RotateFlipType]::Rotate270FlipNone) }
        }
      }
    }

    $w = $src.Width; $h = $src.Height
    $maxDim = 1600
    $scale = [Math]::Min(1.0, $maxDim / [Math]::Max($w, $h))
    $nw = [Math]::Max(1, [int]($w * $scale))
    $nh = [Math]::Max(1, [int]($h * $scale))

    $done = $false
    foreach ($q in 80, 65) {
      if ($done) { break }
      $bmp = New-Object System.Drawing.Bitmap($nw, $nh)
      $g = [System.Drawing.Graphics]::FromImage($bmp)
      $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
      $g.DrawImage($src, 0, 0, $nw, $nh)
      $g.Dispose()

      $ep = New-Object System.Drawing.Imaging.EncoderParameters(1)
      $ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]$q)
      $tmp = $f.FullName + '.tmp.jpg'
      $bmp.Save($tmp, $enc, $ep)
      $bmp.Dispose()
      $ep.Dispose()

      $len = (Get-Item $tmp).Length
      if ($len -lt 1MB) { $done = $true }
      else { Remove-Item $tmp -Force }
    }

    $src.Dispose()
    $img.Dispose()

    if ($done) {
      Move-Item -LiteralPath $tmp -Destination $f.FullName -Force
      $newKB = [math]::Round((Get-Item $f.FullName).Length / 1KB)
      Write-Output ("OK     " + $f.Name + " -> " + $newKB + " KB")
    } else {
      Write-Output ("SKIP   " + $f.Name + " (stayed over 1MB, keeping original)")
    }
  } catch {
    Write-Output ("FAIL   " + $f.Name + " : " + $_.Exception.Message)
  }
}
Write-Output "DONE"
