# Local web server for this folder, so the page runs over http:// instead of file://
# (some browsers refuse to play audio/media from file://).
# Run:  powershell -ExecutionPolicy Bypass -File serve.ps1
# Stop: Ctrl+C in the window.

$port = 8080
$root = $PSScriptRoot

$mime = @{
  '.html' = 'text/html; charset=utf-8'
  '.css'  = 'text/css; charset=utf-8'
  '.js'   = 'application/javascript; charset=utf-8'
  '.json' = 'application/json'
  '.svg'  = 'image/svg+xml'
  '.png'  = 'image/png'
  '.jpg'  = 'image/jpeg'
  '.jpeg' = 'image/jpeg'
  '.gif'  = 'image/gif'
  '.webp' = 'image/webp'
  '.mp4'  = 'video/mp4'
  '.webm' = 'video/webm'
  '.mov'  = 'video/quicktime'
  '.m4a'  = 'audio/mp4'
  '.mp3'  = 'audio/mpeg'
  '.wav'  = 'audio/wav'
  '.ogg'  = 'audio/ogg'
  '.woff2'= 'font/woff2'
  '.woff' = 'font/woff'
  '.md'   = 'text/plain; charset=utf-8'
}

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host ("Server running:  http://localhost:{0}/index.html   (folder: {1})" -f $port, $root)
Write-Host "Opening browser... Ctrl+C to stop."
Start-Process ("http://localhost:{0}/index.html" -f $port)

try {
  while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    try {
      $isHead = $ctx.Request.HttpMethod -eq 'HEAD'
      $ctx.Response.Headers.Add('Cache-Control', 'no-store, must-revalidate')  # всегда свежий файл, без кэша браузера
      $rel = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath).TrimStart('/')
      if ($rel -eq '') { $rel = 'index.html' }
      $full = [IO.Path]::GetFullPath((Join-Path $root $rel))
      if ((Test-Path $full -PathType Leaf) -and $full.StartsWith([IO.Path]::GetFullPath($root))) {
        $ext = [IO.Path]::GetExtension($full).ToLower()
        if ($mime.ContainsKey($ext)) { $ctx.Response.ContentType = $mime[$ext] } else { $ctx.Response.ContentType = 'application/octet-stream' }
        $bytes = [IO.File]::ReadAllBytes($full)
        $ctx.Response.ContentLength64 = $bytes.Length
        if (-not $isHead) { $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length) }
      }
      else {
        $ctx.Response.StatusCode = 404
        $body = [Text.Encoding]::UTF8.GetBytes('404 Not Found: ' + $rel)
        $ctx.Response.ContentLength64 = $body.Length
        if (-not $isHead) { $ctx.Response.OutputStream.Write($body, 0, $body.Length) }
      }
    }
    catch {
      Write-Host ("  ! " + $_.Exception.Message)
      try { $ctx.Response.StatusCode = 500 } catch {}
    }
    finally {
      try { $ctx.Response.Close() } catch {}
    }
  }
}
finally {
  $listener.Stop()
}
