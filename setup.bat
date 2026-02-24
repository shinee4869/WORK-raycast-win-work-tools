@echo off
powershell -ExecutionPolicy Bypass -File "%~dp0setup.ps1" > "%~dp0setup_log.txt" 2>&1
pause
