@echo off
echo.
echo [��Ϣ] ���Doc���̣�����dist�ļ���
echo.

%~d0
cd %~dp0

npm run build

pause