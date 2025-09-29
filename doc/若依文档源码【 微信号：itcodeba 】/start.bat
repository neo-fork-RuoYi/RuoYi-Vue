@echo off
echo.
echo [信息] 使用 Doc 运行 Web 工程。
echo.

%~d0
cd %~dp0

npm run dev

pause