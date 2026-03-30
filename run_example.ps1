$ErrorActionPreference = "Stop"

# GStreamer bin 경로 설정
$gstreamerBinPath = "C:\Program Files\gstreamer\1.0\msvc_x86_64\bin"

# 1. 현재 PowerShell 세션의 PATH에 GStreamer 경로가 없다면 임시로 추가합니다.
# (이 방법은 시스템 환경 변수를 영구적으로 변경하지 않으므로 프로젝트를 실행할 때마다 이 스크립트를 사용해야 합니다.)
if ($env:PATH -notmatch [regex]::Escape($gstreamerBinPath)) {
    $env:PATH = "$gstreamerBinPath;$env:PATH"
    Write-Host "✅ [Success] 현재 세션의 PATH에 GStreamer 경로를 추가했습니다." -ForegroundColor Green
    Write-Host "   추가된 경로: $gstreamerBinPath" -ForegroundColor DarkGray
} else {
    Write-Host "ℹ️ [Info] PATH에 이미 GStreamer 경로가 포함되어 있습니다." -ForegroundColor Cyan
}

# 2. 스크립트가 위치한 곳(루트)에서 example 폴더로 이동
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location -Path "$scriptPath\example"

# 3. Flutter 앱 실행
Write-Host "🚀 [Run] Flutter Windows 예제 앱을 실행합니다..." -ForegroundColor Yellow
flutter run -d windows

cd ..