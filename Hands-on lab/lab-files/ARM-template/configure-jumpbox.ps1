function Disable-InternetExplorerESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force
    Stop-Process -Name Explorer -Force
    Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
}

# Disable IE ESC
Disable-InternetExplorerESC

# Force TLS 1.2 use instead of TLS 1.0
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Download and extract the starter solution files
Invoke-WebRequest 'https://github.com/microsoft/MCW-Migrating-SQL-databases-to-Azure/archive/master.zip' -OutFile 'C:\MCW.zip'
Expand-Archive -LiteralPath 'C:\MCW.zip' -DestinationPath 'C:\hands-on-lab' -Force

# Download and install SQL Server Management Studio
# Invoke-WebRequest 'https://go.microsoft.com/fwlink/?linkid=2105412' -OutFile 'C:\SSMS-Setup.exe'
# $pathArgs = {C:\SSMS-Setup.exe /Install /Quiet /Norestart /Logs log.txt}
# Invoke-Command -ScriptBlock $pathArgs