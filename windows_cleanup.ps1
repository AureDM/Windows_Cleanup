# Check Network Connection
try {
    Write-Host "Checking the network connection ..."
    $connectionTest = Test-Connection -ComputerName "www.google.com" -Count 3 -Quiet

    if ($connectionTest) {
        Write-Host "Network Connection success ! The cleaning of Windows is starting :"

        # List of packages to uninstall
        $packagesToRemove = @(
            "*Microsoft.GetHelp*",             # Obtenir de l'aide
            "*Microsoft.PowerAutomateDesktop*",# Power automate
            "*DevHome*",                       # DevHome
            "*Microsoft.WindowsFeedbackHub*",  # Feedback Hub
            "*bingnews*",                      # News
            "*bingweather*",                   # Météo
            "*officehub*",                     # Office Hub
            "*solitairecollection*",           # Jeu solitaire
            "*soundrecorder*",                 # Enregistreur vocale
            "*Microsoft.YourPhone*",           # Phone Link
            "*QuickAssist*",                   # Assistance rapide
            "*Microsoft.Copilot*",             # Copilot
            "*Microsoft.Paint*",               # Paint
            "*MicrosoftFamily*",               # Microsoft Family     
            "*Clipchamp*",                     # Microsoft Clipchamp
            "*Microsoft.Bing*",                # Microsoft Recherche Bing
            "*MSTeams*",                       # Microsoft Teams
            "*Microsoft.Todos*",               # Microsoft To Do
            "*Microsoft.Outlook*",             # Microsoft Outlook
            "*CrossDevice*",                   # Appareils mobiles - Phone integration within File Explorer, Camera and more
            "*Microsoft.GamingApp*",           # Xbox Gaming Application, required for installing some PC games
            "*XboxSpeechToTextOverlay*",       # Allows speech recognition and text-to-speech transcription
            "*XboxIdentityProvider*",          # Xbox Identity Provider (Xbox sign-in framework, required for some games)
            "*Xbox.TCUI*"                      # Xbox Live Application
            "*XboxGamingOverlay*"              # Game Bar - Game overlay, required/useful for some games
        )

        # Uninstalling packages
        foreach ($package in $packagesToRemove) {
            try {
                $app = Get-AppxPackage -AllUsers $package -ErrorAction Stop
                if ($app) {
                    Remove-AppxPackage -Package $app.PackageFullName -AllUsers
                    Write-Host "Successful uninstall : $package"
                } else {
                    Write-Host "Already uninstalled or no applications found for : $package"
                }
            } catch {
                Write-Host "Uninstall failed or application not found : $package"
            }
        }

        # Uninstall Windows Media Player Legacy (Old Multimedia Player)
        try {
            Write-Host "Uninstalling Windows Media Player Legacy ..."
            Disable-WindowsOptionalFeature -Online -FeatureName "WindowsMediaPlayer" -Remove -ErrorAction SilentlyContinue | Out-Null
            Write-Host "Successful uninstall : Windows Media Player Legacy"
        } catch {
            Write-Host "Uninstall failed : Windows Media Player Legacy"
        }

        # Uninstall OneDrive with winget tool
        ## Stop OneDrive process
        try {
            Write-Host "OneDrive is stopping ..."
            Stop-Process -Name OneDrive -Force -ErrorAction SilentlyContinue
            Write-Host "OneDrive process stopped"
        } catch {
            Write-Host "OneDrive process stop failed : $_"
        }

        ## Uninstall OneDrive with winget tool
        try {
            winget uninstall Microsoft.OneDrive --accept-source-agreements --silent *>&1 | Out-Null
            Write-Host "Successful uninstall : OneDrive"

            # Deleting the OneDrive folder in the user directory
            $oneDrivePath = "$HOME\OneDrive"
            if (Test-Path $oneDrivePath) {
                Remove-Item $oneDrivePath -Recurse -Force
                Write-Host "Successful folder deletion : $oneDrivePath"
            } else {
                Write-Host "OneDrive folder not find : $oneDrivePath"
            }

        } catch {
            Write-Host "Uninstall failed : Microsoft.OneDrive"
        }

    } else {
        Write-Host "You have no network connection. You need to connect to the network. The cleaning don't run."
    }

} catch {
    Write-Host "Check network connection failed : $_"
}
