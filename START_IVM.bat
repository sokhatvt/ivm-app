@echo off
:: 1. Run the Node.js backend application first
start "" node "%~dp0START_IVM.js"

:: Wait for 2 seconds to ensure the Node.js server has started successfully
timeout /t 2 /nobreak >nul

echo Checking and launching application...

:: 2. Check for Chrome by looking into common default installation paths
set "CHROME_PATH="

if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" (
    set "CHROME_PATH=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
) else if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" (
    set "CHROME_PATH=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
) else if exist "%LocalAppData%\Google\Chrome\Application\chrome.exe" (
    set "CHROME_PATH=%LocalAppData%\Google\Chrome\Application\chrome.exe"
)

:: 3. Browser launching logic
if defined CHROME_PATH (
    echo Opening with Google Chrome...
    
    :: Thêm 'start ""' vào trước để Chrome chạy độc lập, giải phóng cửa sổ DOS ngay lập tức
    start "" "%CHROME_PATH%" "http://localhost:3000/"
    
) else (
    :: If Chrome is not found, print a warning in the console and fallback to the default browser
    echo [WARNING] Google Chrome was not found on this system.
    echo Automatically opening with the Default Browser...
    start http://localhost:3000/
)

:: Thoát và đóng cửa sổ DOS
exit