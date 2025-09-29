@echo off
echo.
echo [信息] 打包Doc工程，生成dist文件。
echo.

%~d0
cd %~dp0

npm run build

pause