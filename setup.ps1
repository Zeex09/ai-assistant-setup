# ========== AI Assistant Setup Script ==========
Write-Host "Starting AI Assistant Setup..." -ForegroundColor Cyan

# Install Python if needed
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Python..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.11.4/python-3.11.4-amd64.exe -OutFile python-installer.exe
    Start-Process -FilePath .\python-installer.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait
    Remove-Item python-installer.exe
} else {
    Write-Host "Python already installed." -ForegroundColor Green
}

# Install VS Code if needed
if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Visual Studio Code..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri https://aka.ms/win32-x64-user-stable -OutFile vscode-installer.exe
    Start-Process -FilePath .\vscode-installer.exe -ArgumentList '/silent /mergetasks=!runcode' -Wait
    Remove-Item vscode-installer.exe
} else {
    Write-Host "VS Code already installed." -ForegroundColor Green
}

# Create project folder
$folder = "$env:USERPROFILE\AI_Assistant"
if (-not (Test-Path $folder)) {
    New-Item -ItemType Directory -Path $folder | Out-Null
}
Set-Location $folder

# Set up Python virtual environment
Write-Host "Setting up virtual environment..." -ForegroundColor Yellow
python -m venv venv
.\venv\Scripts\Activate.ps1

# Install required packages
Write-Host "Installing Python packages..." -ForegroundColor Yellow
pip install --upgrade pip
pip install openai pyautogui pillow selenium watchdog

# Prompt for API Key
$apiKey = Read-Host "Please enter your OpenAI API key"
Set-Content -Path ".\openai_api_key.txt" -Value $apiKey

# Create a dummy main.py file that reads commands
@"
print("AI Assistant Ready > Type your build request.")
while True:
    cmd = input(">> ")
    if "hacker lab" in cmd.lower():
        print("Opening VS Code and starting build...")
        import os
        os.system("code .")
        # Future: start real build steps
    else:
        print("Command not recognized yet. This is a placeholder.")
"@ | Set-Content -Path ".\main.py"

# Launch the assistant
Write-Host "Launching the AI Assistant..." -ForegroundColor Cyan
python main.py
