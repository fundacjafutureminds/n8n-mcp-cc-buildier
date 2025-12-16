# Script to create desktop shortcuts for profile switching

$WshShell = New-Object -ComObject WScript.Shell
$Desktop = [System.Environment]::GetFolderPath('Desktop')

# Shortcut 1: WOJAK
$Shortcut1 = $WshShell.CreateShortcut("$Desktop\🏢 Profil WOJAK.lnk")
$Shortcut1.TargetPath = "powershell.exe"
$Shortcut1.Arguments = "-ExecutionPolicy Bypass -File `"C:\Users\mstrz\wojak.ps1`""
$Shortcut1.WorkingDirectory = "C:\Users\mstrz"
$Shortcut1.Description = "Switch to WOJAK profile (wojakproperties)"
$Shortcut1.IconLocation = "C:\Windows\System32\imageres.dll,1"
$Shortcut1.Save()

# Shortcut 2: FUNDACJA
$Shortcut2 = $WshShell.CreateShortcut("$Desktop\🏛️ Profil FUNDACJA.lnk")
$Shortcut2.TargetPath = "powershell.exe"
$Shortcut2.Arguments = "-ExecutionPolicy Bypass -File `"C:\Users\mstrz\fundacja.ps1`""
$Shortcut2.WorkingDirectory = "C:\Users\mstrz"
$Shortcut2.Description = "Switch to FUNDACJA profile (aneta175 + futureminds)"
$Shortcut2.IconLocation = "C:\Windows\System32\imageres.dll,2"
$Shortcut2.Save()

# Shortcut 3: LOCALHOST
$Shortcut3 = $WshShell.CreateShortcut("$Desktop\🏠 Profil LOCALHOST.lnk")
$Shortcut3.TargetPath = "powershell.exe"
$Shortcut3.Arguments = "-ExecutionPolicy Bypass -File `"C:\Users\mstrz\localhost.ps1`""
$Shortcut3.WorkingDirectory = "C:\Users\mstrz"
$Shortcut3.Description = "Switch to LOCALHOST profile (local n8n)"
$Shortcut3.IconLocation = "C:\Windows\System32\imageres.dll,154"
$Shortcut3.Save()

Write-Host "✅ Created 3 desktop shortcuts:" -ForegroundColor Green
Write-Host "   🏢 Profil WOJAK" -ForegroundColor Cyan
Write-Host "   🏛️ Profil FUNDACJA" -ForegroundColor Cyan
Write-Host "   🏠 Profil LOCALHOST" -ForegroundColor Cyan
Write-Host ""
Write-Host "You can now double-click any shortcut to switch profiles!" -ForegroundColor Yellow
