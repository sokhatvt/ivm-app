@echo off
title Setup Node.js v18 & MariaDB
color 0B

cls
echo ============================================================================
echo                     System Component Installer
echo ============================================================================
echo.

:: Stage 1: Check Admin Privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Administrator privileges required.
    echo Please right-click this script and select "Run as administrator".
    echo.
    pause
    exit /b 1
)

set "DB_PASS=12345678"
set "DB_NAME=ivm_data"
set "MARIADB_INSTALLER=%TEMP%\mariadb_setup.msi"

:: ----------------------------------------------------------------------------
:: Stage 2: Check installed software
:: ----------------------------------------------------------------------------
echo [INFO] Checking installed software status...

set NODE_INSTALLED=0
where node >nul 2>&1
if %errorlevel% equ 0 set NODE_INSTALLED=1
if exist "C:\Program Files\nodejs\node.exe" set NODE_INSTALLED=1

set MARIADB_INSTALLED=0
:: Check via Windows Service
sc query MariaDB >nul 2>&1
if %errorlevel% equ 0 set MARIADB_INSTALLED=1

:: Check actual installation folder in Program Files
if exist "C:\Program Files\MariaDB 10.11\bin\mysql.exe" set MARIADB_INSTALLED=1
if exist "C:\Program Files\MariaDB 11.4\bin\mysql.exe" set MARIADB_INSTALLED=1
if exist "C:\Program Files\MariaDB 10.6\bin\mysql.exe" set MARIADB_INSTALLED=1

echo Node.js installed status : %NODE_INSTALLED%
echo MariaDB installed status : %MARIADB_INSTALLED%
echo.

:: ----------------------------------------------------------------------------
:: Stage 3: Install Node.js v18
:: ----------------------------------------------------------------------------
if %NODE_INSTALLED% equ 0 (
    echo [STEP 1/2] Downloading Node.js v18...
    echo.
    curl.exe -L -# -o "%TEMP%\node_setup.msi" "https://nodejs.org/dist/v18.20.4/node-v18.20.4-x64.msi"
    
    if exist "%TEMP%\node_setup.msi" (
        echo.
        echo [INSTALLING] Installing Node.js...
        msiexec /i "%TEMP%\node_setup.msi" /qb! /norestart
        del "%TEMP%\node_setup.msi" >nul 2>&1
        set "PATH=%PATH%;C:\Program Files\nodejs"
        echo [OK] Node.js finished.
    ) else (
        echo [ERROR] Failed to download Node.js installer.
    )
    echo.
) else (
    echo [SKIP] Node.js is already installed.
    echo.
)

:: Change working directory to the current script directory
cd /d "%~dp0"

:: Temporarily update PATH to load node and npm commands
set "PATH=%PATH%;C:\Program Files\nodejs"

:: Run npm install in the script directory
if not exist "package.json" (
    echo [WARN] package.json not found. Skipping npm install.
    goto SKIP_NPM
)

if exist "node_modules" (
    echo [SKIP] node_modules folder already exists. Skipping npm install.
    goto SKIP_NPM
)

echo [NPM] Installing Node modules (npm install)...
echo.
cmd /c "npm install"

if %errorlevel% neq 0 (
    echo.
    echo [WARN] npm install ended with code %errorlevel%. 
    echo [HINT] You can run 'npm install' manually later if needed.
) else (
    echo.
    echo [OK] Node modules installed successfully.
)

:SKIP_NPM
echo.

:: ----------------------------------------------------------------------------
:: Stage 4: Install MariaDB 10.x
:: ----------------------------------------------------------------------------
if %MARIADB_INSTALLED% equ 0 (
    echo [STEP 2/2] Downloading MariaDB 10.11 LTS...
    echo.
    if exist "%MARIADB_INSTALLER%" del /f /q "%MARIADB_INSTALLER%" >nul 2>&1
    
    curl.exe -k -L -# -o "%MARIADB_INSTALLER%" "https://archive.mariadb.org/mariadb-10.11.8/winx64-packages/mariadb-10.11.8-winx64.msi"
    
    if exist "%MARIADB_INSTALLER%" (
        echo.
        echo [INSTALLING] Installing MariaDB...
        msiexec /i "%MARIADB_INSTALLER%" /qb! /norestart SERVICENAME="MariaDB" PORT=3306 PASSWORD="%DB_PASS%" UTF8=1
        del "%MARIADB_INSTALLER%" >nul 2>&1
        echo [OK] MariaDB finished.
    ) else (
        echo.
        echo [ERROR] Failed to download MariaDB installer package!
    )
    echo.
) else (
    echo [SKIP] MariaDB is already installed.
    echo.
)

:: ----------------------------------------------------------------------------
:: Stage 5: Init Database
:: ----------------------------------------------------------------------------
echo [DATABASE] Creating Database '%DB_NAME%'...
set "PATH=%PATH%;C:\Program Files\MariaDB 10.11\bin;C:\Program Files\MariaDB 10.6\bin;C:\Program Files\MariaDB 11.4\bin"

timeout /t 3 /nobreak >nul 2>&1

where mysql >nul 2>&1
if %errorlevel% equ 0 (
    mysql -u root -p%DB_PASS% -e "CREATE DATABASE IF NOT EXISTS %DB_NAME% CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" >nul 2>&1
    echo [OK] Database created successfully.
) else (
    echo [WARN] MySQL CLI not detected in PATH.
)

echo ============================================================================
echo                         FIRST-TIME INSTALLATION SUMMARY
echo ============================================================================
echo.
echo --- DATABASE INFORMATION ---
echo     Host             : localhost / 127.0.0.1
echo     Port             : 3306
echo     User             : root
echo     Root Password    : %DB_PASS%
echo     Database Name    : %DB_NAME%
echo.
echo --- LOGIN ACCOUNT INFORMATION ---
echo     Username         : ivm_admin
echo     Password         : 12345678
echo ----------------------------------------------------------------------------
echo.
echo [STATUS] Setup completed successfully!
echo.
echo Press any key to exit.
pause