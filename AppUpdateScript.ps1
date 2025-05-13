# AppUpdateScript.ps1

function Ensure-Winget {
    if (Get-Command winget.exe -ErrorAction SilentlyContinue) {
        return $true
    }

    try {
        Invoke-WebRequest -Uri "https://aka.ms/getwinget" -OutFile "$env:TEMP\AppInstaller.msixbundle" -UseBasicParsing
        Add-AppxPackage -Path "$env:TEMP\AppInstaller.msixbundle"
        Start-Sleep -Seconds 10
        return (Get-Command winget.exe -ErrorAction SilentlyContinue) -ne $null
    } catch {
        return $false
    }
}

function Update-Apps {
    $apps = @(
        "Mozilla.Firefox",
        "Google.Chrome",
        "Example.App"
    )

    foreach ($app in $apps) {
        try {
            winget upgrade --id $app --silent --accept-package-agreements --accept-source-agreements | Out-Null
        } catch {
            # Continue on error silently
        }
    }
}

if (Ensure-Winget) {
    Update-Apps
}
