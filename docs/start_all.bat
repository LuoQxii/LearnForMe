@echo off
chcp 936 >nul
cd /d D:\LearnForMe

echo Set WshShell = CreateObject("WScript.Shell") > run_bg.vbs
:: 启动 docsify 3000
echo WshShell.Run "cmd /c ""cd /d D:\LearnForMe && docsify serve docs --port 3000""", 0 >> run_bg.vbs
:: 直接启动 node server.js 3001
echo WshShell.Run "cmd /c ""cd /d D:\LearnForMe\admin && node server.js""", 0 >> run_bg.vbs

cscript //nologo run_bg.vbs
del run_bg.vbs

timeout /t 3 /nobreak >nul
start http://localhost:3000
echo 两个服务后台静默启动完成
echo 关闭服务执行 stop_kill.bat
pause