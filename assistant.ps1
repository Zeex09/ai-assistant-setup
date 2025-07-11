Write-Host "`n🧠 AI Assistant Ready. Type your command..." -ForegroundColor Cyan

while ($true) {
    $command = Read-Host ">>"

    switch -Wildcard ($command.ToLower()) {

        "*build trading bot*" {
            Write-Host "`n🚀 Launching trading bot..." -ForegroundColor Green
            if (Test-Path "./trading_bot.ps1") {
                powershell -ExecutionPolicy Bypass -File "./trading_bot.ps1"
            } else {
                Write-Host "❌ trading_bot.ps1 not found." -ForegroundColor Red
            }
        }

        "*exit*" {
            Write-Host "`n👋 Exiting assistant..." -ForegroundColor Magenta
            break
        }

        default {
            Write-Host "`n⚠️  Command not recognized. Try again." -ForegroundColor DarkGray
        }
    }
}
