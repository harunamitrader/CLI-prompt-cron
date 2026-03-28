@echo off
chcp 65001 >nul
title AI Cron ダッシュボード

:: ポート3300を使用中のプロセスを終了
for /f "tokens=5" %%a in ('netstat -aon 2^>nul ^| findstr ":3300 " ^| findstr LISTEN') do (
    powershell -Command "Stop-Process -Id %%a -Force -ErrorAction SilentlyContinue" >nul 2>&1
)

:: このバッチファイルと同じフォルダに移動して起動
cd /d "%~dp0"
echo [AI Cron] 起動中...
node start.js
