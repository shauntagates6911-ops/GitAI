#!/bin/bash
set -e

echo "================================================="
echo " Starting Setup for AI Desktop App & Site..."
echo "================================================="

# 1. Update package managers
echo "Syncing system repositories..."
sudo apt-get update -y || echo "Package sync skipped (Non-Debian platform)"

# 2. Download and activate local AI engine background process
echo "Installing Ollama service framework..."
curl -fsSL https://ollama.com | sh
sleep 3

echo "Fetching localized Llama3 model layers..."
ollama pull llama3

# 3. Deploy Node.js runtime environments for desktop scaffolding
if ! command -v node &> /dev/null; then
    echo "Node.js not detected. Deploying package dependencies..."
    sudo apt-get install -y nodejs npm
fi

# 4. Generate package configurations for desktop app window wrapping
if [ ! -f package.json ]; then
    echo "Creating clean app package metadata structure..."
    cat << 'EOF' > package.json
{
  "name": "ai-desktop-app",
  "version": "1.0.0",
  "main": "main.js",
  "scripts": {
    "start": "electron .",
    "serve": "npx http-server -p 8080"
  }
}
EOF
    # Inject light production desktop frame layers
    npm install electron --save-dev
fi

# 5. Build Desktop Window Launch Controller script
if [ ! -f main.js ]; then
    echo "Assembling native desktop app window controls..."
    cat << 'EOF' > main.js
const { app, BrowserWindow } = require('electron');
const path = require('path');

function createWindow() {
    const win = new BrowserWindow({
        width: 1000,
        height: 750,
        title: "AI Desktop Assistant",
        webPreferences: {
            nodeIntegration: false,
            contextIsolation: true
        }
    });

    // Directly renders your existing layout inside the desktop frame
    win.loadFile('index.html');
}

app.whenReady().then(() => {
    createWindow();

    app.on('activate', () => {
        if (BrowserWindow.getAllWindows().length === 0) createWindow();
    });
});

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') app.quit();
});
EOF
fi

echo "================================================="
echo " Configuration Successful!"
echo " --> To run as a DESKTOP APP window: npm start"
echo " --> To run as a local WEBSITE url:  npm run serve"
echo "================================================="
