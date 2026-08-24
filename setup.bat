@echo off
title AI App Setup for Windows
echo =================================================
echo  Starting Setup for AI Desktop App ^& Site (Windows)
echo =================================================

:: 1. Download and install Ollama if it is missing
where ollama >nul 2>nul
if %errorlevel% neq 0 (
    echo Ollama framework not detected. Installing...
    echo Downloading installer from official source...
    curl -L -o %TEMP%\OllamaSetup.exe https://ollama.com
    echo Launching installer window... Please follow the on-screen prompts.
    start /wait %TEMP%\OllamaSetup.exe
    echo Waiting for installation process to settle...
    timeout /t 5 >nul
) else (
    echo [✓] Ollama is already installed.
)

:: 2. Download the Llama 3 model weights
echo Fetching localized Llama3 model layers...
ollama pull llama3

:: 3. Check for Node.js engine
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [!] Node.js not detected. 
    echo Please install Node.js from https://nodejs.org to run the desktop wrapper.
    echo Press any key to open the Node.js website and close this script...
    pause >nul
    start "" "https://nodejs.org"
    exit /b
) else (
    echo [✓] Node.js is already installed.
)

:: 4. Build application metadata settings if missing
if not exist package.json (
    echo Creating project configuration files...
    (
    echo {
    echo   "name": "ai-desktop-app",
    echo   "version": "1.0.0",
    echo   "main": "main.js",
    echo   "scripts": {
    echo     "start": "electron .",
    echo     "serve": "npx http-server -p 8080"
    echo   }
    echo }
    ) > package.json
    echo Installing window wrapping engine (Electron)...
    call npm install electron --save-dev
)

:: 5. Create Desktop Window Launch Controller if missing
if not exist main.js (
    echo Assembling desktop app window controls...
    (
    echo const { app, BrowserWindow } = require^('electron'^);
    echo const path = require^('path'^);
    echo.
    echo function createWindow^(^) {
    echo     const win = new BrowserWindow^({
    echo         width: 1000,
    echo         height: 750,
    echo         title: "AI Desktop Assistant",
    echo         webPreferences: {
    echo             nodeIntegration: false,
    echo             contextIsolation: true
    echo         }
    echo     }^);
    echo     win.loadFile^('index.html'^);
    echo }
    echo.
    echo app.whenReady^(^).then^(^(^) =^> {
    echo     createWindow^(^);
    echo     app.on^('activate', ^(^) =^> {
    echo         if ^(BrowserWindow.getAllWindows^(^).length === 0^) createWindow^(^);
    echo     }^);
    echo }^);
    echo.
    echo app.on^('window-all-closed', ^(^) =^> {
    echo     if ^(process.platform !== 'darwin'^) app.quit^(^);
    echo }^);
    ) > main.js
)

echo =================================================
echo  Configuration Successful!
echo  --^> To run as a DESKTOP APP window: npm start
echo  --^> To run as a local WEBSITE url:  npm run serve
echo =================================================
pause
