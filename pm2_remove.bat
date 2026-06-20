@echo off
:: Ensure the script is running with Administrative privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Please right-click this file and select "Run as administrator".
    pause
    exit /b
)

echo ====================================================
echo  STARTING PM2 COMPLETE REMOVAL AND CLEANUP
echo ====================================================

:: 1. Stop and Delete PM2 processes
echo [INFO] Stopping all PM2 processes...
call pm2 kill >nul 2>&1

:: 2. Uninstall PM2 Windows Startup Service (if exists)
echo [INFO] Removing PM2 Windows Startup Service...
call pm2-startup uninstall >nul 2>&1
call pm2-service uninstall >nul 2>&1

:: 3. Uninstall NPM packages globally
echo [INFO] Uninstalling PM2 and related tools from NPM...
call npm uninstall pm2 -g
call npm uninstall pm2-windows-startup -g
call npm uninstall pm2-windows-service -g

:: 4. Clean up PM2 Directories (Tận gốc thư mục rác)
echo [INFO] Cleaning up PM2 directories and configuration files...

:: Xóa thư mục C:\pm2_home (Nếu cài bản tối ưu trước đó)
if exist "C:\pm2_home" (
    echo [INFO] Removing C:\pm2_home...
    rmdir /s /q "C:\pm2_home"
)

:: Xóa thư mục .pm2 trong User Profile mặc định
if exist "%USERPROFILE%\.pm2" (
    echo [INFO] Removing %USERPROFILE%\.pm2...
    rmdir /s /q "%USERPROFILE%\.pm2"
)

:: Xóa các file thừa trong AppData của NPM nếu còn sót
if exist "%APPDATA%\npm\pm2*" (
    echo [INFO] Cleaning NPM residual files...
    del /f /q "%APPDATA%\npm\pm2*" >nul 2>&1
)

:: 5. Remove PM2_HOME Environment Variable (Xóa biến môi trường)
echo [INFO] Removing PM2_HOME environment variable...
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PM2_HOME /f >nul 2>&1
reg delete "HKCU\Environment" /v PM2_HOME /f >nul 2>&1
set "PM2_HOME="

echo ====================================================
echo  SUCCESS! PM2 has been completely removed from this system.
echo  Please restart your computer to apply all changes.
echo ====================================================
pause