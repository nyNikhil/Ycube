param(
    [int]$Port = 8080,
    [string]$Root = (Get-Location).Path
)

Add-Type -AssemblyName System.Net.HttpListener
$listener = New-Object System.Net.HttpListener
$prefix = "http://localhost:$Port/"
$listener.Prefixes.Add($prefix)
$listener.Start()
Write-Host "Serving $Root on $prefix"

$mime = @{ '.html'='text/html'; '.htm'='text/html'; '.css'='text/css'; '.js'='application/javascript'; '.json'='application/json'; '.png'='image/png'; '.jpg'='image/jpeg'; '.jpeg'='image/jpeg'; '.gif'='image/gif'; '.svg'='image/svg+xml'; '.ico'='image/x-icon' }

try {
  while ($listener.IsListening) {
    $context = $listener.GetContext()
    $req = $context.Request
    $res = $context.Response

    $path = [Uri]::UnescapeDataString($req.Url.AbsolutePath.TrimStart('/'))
    if ([string]::IsNullOrWhiteSpace($path)) { $path = 'index.html' }
    $full = Join-Path $Root $path

    if ((Test-Path $full) -and -not (Get-Item $full).PSIsContainer) {
      try {
        $ext = [IO.Path]::GetExtension($full).ToLower()
        $res.ContentType = $mime[$ext]
        if (-not $res.ContentType) { $res.ContentType = 'application/octet-stream' }
        $bytes = [IO.File]::ReadAllBytes($full)
        $res.ContentLength64 = $bytes.Length
        $res.OutputStream.Write($bytes, 0, $bytes.Length)
      } catch {
        $res.StatusCode = 500
      }
    } else {
      $res.StatusCode = 404
    }

    $res.OutputStream.Close()
  }
} finally {
  $listener.Stop()
  $listener.Close()
}


