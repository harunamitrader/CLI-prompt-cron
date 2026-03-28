@echo off
chcp 65001 >nul

:: Create desktop shortcut for cli-prompt-cron
set SCRIPT_DIR=%~dp0
set SHORTCUT_NAME=cli-prompt-cron.lnk
set DESKTOP=%USERPROFILE%\Desktop
set ICON_JPG=%SCRIPT_DIR%assets\icon.jpg
set ICON_ICO=%SCRIPT_DIR%assets\icon.ico

:: Convert jpg to ico via PowerShell (if ico doesn't exist yet)
if not exist "%ICON_ICO%" (
    powershell -NoProfile -Command ^
      "Add-Type -AssemblyName System.Drawing;" ^
      "$img = [System.Drawing.Image]::FromFile('%ICON_JPG%');" ^
      "$bmp = New-Object System.Drawing.Bitmap($img, 256, 256);" ^
      "$stream = [System.IO.File]::Create('%ICON_ICO%');" ^
      "$bmp.Save($stream, [System.Drawing.Imaging.ImageFormat]::Icon);" ^
      "$stream.Close(); $bmp.Dispose(); $img.Dispose();" ^
      "Write-Host '[cli-prompt-cron] Icon converted.'"
)

:: Create .lnk shortcut
powershell -NoProfile -Command ^
  "$ws = New-Object -ComObject WScript.Shell;" ^
  "$sc = $ws.CreateShortcut('%DESKTOP%\%SHORTCUT_NAME%');" ^
  "$sc.TargetPath = '%SCRIPT_DIR%launch.bat';" ^
  "$sc.WorkingDirectory = '%SCRIPT_DIR%';" ^
  "$sc.Description = 'cli-prompt-cron - AI Scheduler';" ^
  "if (Test-Path '%ICON_ICO%') { $sc.IconLocation = '%ICON_ICO%,0' };" ^
  "$sc.Save();" ^
  "Write-Host '[cli-prompt-cron] Shortcut created on Desktop.'"

pause
