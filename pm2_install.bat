@echo off
:: Ensure the script is running with Administrative privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Please right-click this file and select "Run as administrator".
    pause
    exit /b
)

echo ====================================================
echo  STARTING PM2 INSTALLATION AND CONFIGURATION
echo ====================================================

:: 1. Check if Node.js/NPM is installed
call npm -v >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Node.js/NPM is not installed on this system.
    echo Please install Node.js first, then run this script again.
    pause
    exit /b
)
echo [OK] Node.js/NPM detected.

:: 2. Setup PM2_HOME Environment Variable (Fixed for System-wide stability)
if "%PM2_HOME%"=="" (
    echo [INFO] Setting up PM2_HOME environment variable to C:\pm2_home...
    if not exist "C:\pm2_home" mkdir "C:\pm2_home"
    setx PM2_HOME "C:\pm2_home" /M
    set "PM2_HOME=C:\pm2_home"
)

:: 3. Install PM2 globally if not already installed
call pm2 -v >nul 2>&1
if %errorLevel% neq 0 (
    echo [INFO] PM2 is not installed. Installing PM2 globally...
    call npm install pm2 -g
) else (
    echo [OK] PM2 is already installed.
)

:: 4. Install PM2 Windows Startup (More stable than pm2-windows-service)
call pm2-startup -v >nul 2>&1
if %errorLevel% neq 0 (
    echo [INFO] Installing pm2-windows-startup tool...
    call npm install pm2-windows-startup -g
    
    echo [INFO] Registering PM2 as a Windows startup service...
    :: Dung call npx de tranh loi khong nhan lenh PATH moi
    call npx pm2-startup install
) else (
    echo [OK] PM2 Startup tool is already installed.
)

:: 5. Start your index.js using PM2
echo [INFO] Launching index.js with PM2...
cd /d "%~dp0"

if not exist "index.js" (
    echo [ERROR] Cannot find index.js in this directory: %~dp0
    pause
    exit /b
)

:: Delete old instance if exists to avoid duplication
call pm2 delete "ivm-app" >nul 2>&1
call pm2 start index.js --name "ivm-app"

:: 6. Save the PM2 process list so it restores on Windows reboot
echo [INFO] Saving PM2 process list...
call pm2 save

echo ====================================================
echo  SUCCESS! Your index.js is now running via PM2.
echo  It will automatically start when Windows boots up.
echo ====================================================
pause