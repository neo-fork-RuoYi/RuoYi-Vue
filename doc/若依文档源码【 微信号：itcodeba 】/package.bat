@echo off
echo.
echo [��Ϣ] ��װDoc���̣�����node_modules�ļ���
echo.

%~d0
cd %~dp0

npm install --registry=https://registry.npm.taobao.org

pause