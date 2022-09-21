### Connect to KMS
Write-Host "________________________________________________________"
Write-Host "Activating Windows..."
slmgr /dlv
slmgr /skms 192.168.1.222:1688
slmgr /ato
slmgr /dlv
Write-Host "Activating Windows Activated"
Start-Sleep -Seconds 3
Read-Host -Prompt "Press ENTER to continue..."


### Reset Current Admin password
Write-Host "________________________________________________________"
Write-Host "Reset Admin password"
Start-Sleep -Seconds 1
$pwd1 = Read-Host "Enter the new password:" -AsSecureString
$pwd2 = Read-Host "Re-enter Passowrd" -AsSecureString
$pwd1_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwd1))
$pwd2_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwd2))
if ($pwd1_text -ceq $pwd2_text) {
Write-Host "Passwords matched"
} else {
Write-Host "Passwords differ"
}
Get-LocalUser -Name "sysadmin" | Set-LocalUser -Password $pwd1
Start-Sleep -Seconds 3
Write-Host "Windows Password reseted"
Read-Host -Prompt "Press ENTER to continue..."

### Create Admin account
Write-Host "________________________________________________________"
Write-Host "Creating a new account"
function Create-NewLocalAdmin {
    [CmdletBinding()]
    param (
        [string] $NewLocalAdmin,
        [securestring] $Password
    )
    begin {
    }
    process {
        New-LocalUser "$NewLocalAdmin" -Password $Password -FullName "$NewLocalAdmin" -Description "Local account"
        Write-Verbose "$NewLocalAdmin local user created"
        Add-LocalGroupMember -Group "Administrators" -Member "$NewLocalAdmin"
	    Add-LocalGroupMember -Group "Users" -Member "$NewLocalAdmin"
        Write-Verbose "$NewLocalAdmin added to the local administrator group"
    }
    end {
    }
}
$NewLocalAdmin = Read-Host "New local admin username:"
$Password = Read-Host -AsSecureString "Create a password for $NewLocalAdmin"
$pwd2 = Read-Host "Re-enter Passowrd" -AsSecureString
$pwd1_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
$pwd2_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwd2))
if ($pwd1_text -ceq $pwd2_text) {
Write-Host "Passwords matched"
Create-NewLocalAdmin -NewLocalAdmin $NewLocalAdmin -Password $Password -Verbose
} else {
Write-Host "Passwords differ"
}
Write-Host "New Account created"
Start-Sleep -Seconds 3
Read-Host -Prompt "Press ENTER to continue..."

### Rename PC-Name
Write-Host "________________________________________________________"
Write-Host "Define a new PC Name for this machine"
$PCName = Read-Host -MaskInput "Enter a PC Name" 
Rename-Computer -NewName $PCName -Verbose
Write-Host "PC Name set"
Start-Sleep -Seconds 3
Read-Host -Prompt "Press ENTER to continue..."


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

### Install Choco
Write-Host "________________________________________________________"
Write-Host "Installing Choco"
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
Write-Host "Choco is installed"
Start-Sleep -Seconds 5
Read-Host -Prompt "Press ENTER to continue..."


### Choco Apps
### Credits to Olli
Write-Host "________________________________________________________"
Write-Host "What department do you belong? "
Write-Host "Press 1 for Sales"
Write-Host "Press 2 for HR"
Write-Host "Press 3 for Operations"
Write-Host "Press 4 for System Engineer"
while($inputValid3 -ne 1 -and $inputValid3 -ne 2 -and $inputValid3 -ne 3 -and $inputValid3 -ne 4){
    $inputValid3 =  read-host -Prompt "Enter number"
    if ($inputValid3 -eq 1) {
            Write-Host "This PC will be customized for Sales"
            choco install -y winscp 7zip telegram hxd git notepadplusplus foxitreader office2019proplus firefox captura ffmpeg winscp microsoft-teams wsus-offline-update-community keepass googlechrome captura ffmpeg webex bitrix24 --ignore-checksum
    }

    if ($inputValid3 -eq 2) {
            Write-Host "This PC will be customized for HR"
            choco install -y  winscp 7zip telegram git hxd notepadplusplus foxitreader office2019proplus firefox captura ffmpeg winscp microsoft-teams wsus-offline-update-community keepass googlechrome captura ffmpeg webex bitrix24 --ignore-checksum
    }

    if ($inputValid3 -eq 3) {
            Write-Host "This PC will be customized for Operations"
            choco install -y kitty winscp 7zip git winsshterm telegram hxd notepadplusplus office2019proplus foxitreader firefox captura ffmpeg winscp microsoft-teams wsus-offline-update-community keepass googlechrome captura ffmpeg bitrix24 --ignore-checksum
    }

    if ($inputValid3 -eq 4) {
            Write-Host "This PC will be customized for System Engineer"
            choco install -y kitty winscp 7zip git winsshterm telegram hxd notepadplusplus office2019proplus  foxitreader firefox captura ffmpeg winscp microsoft-teams wsus-offline-update-community keepass googlechrome captura ffmpeg vmware-workstation-player bitrix24 --ignore-checksum
    }  
    if($inputValid3 -ne 1 -and $inputValid3 -ne 2 -and $inputValid3 -ne 3 -and $inputValid3 -ne 4){
        Write-Host "Please enter 1,2,3 or 4"
    }
}
Write-Host "Your applications are installed"
Start-Sleep -Seconds 3
Read-Host -Prompt "Press ENTER to continue..."

### Install kerio
Write-Host "________________________________________________________"
Write-Host "Installing Kerio"
$URL="https://cdn.kerio.com/dwn/kerio-connect-koff-win.exe"
$Path="C:\Users\$env:UserName\Downloads\"
Start-BitsTransfer -Source $URL -Destination $Path
cd "C:\Users\$env:UserName\Downloads\"
.\kerio-connect-koff-win.exe /qn
Start-Sleep -Seconds 3
Remove-Item 'C:\Users\$env:UserName\Downloads\kerio-connect-koff-win.exe'
Write-Host "Kerio installed"
Read-Host -Prompt "Press ENTER to continue..."

### Activate Office 2019
Write-Host "________________________________________________________"
Write-Host "Activating Office 2019"
cscript "C:\Program Files\Microsoft Office\Office16\OSPP.VBS" /inpkey:NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP
TIMEOUT /T 30
cscript "C:\Program Files\Microsoft Office\Office16\OSPP.VBS" /act
Start-Sleep -Seconds 3
Write-Host "Office is activated"
Read-Host -Prompt "Press ENTER to continue..."


### Install irunner & revdav
Write-Host "________________________________________________________"
Write-Host "Installing irunner"
New-Item -Path 'C:\Program Files\irunner_revdav' -ItemType Directory
$URL="https://wixcloud.de/packages/irunner/irunner_windows_amd64.exe.xz"
$Path="C:\Program Files\irunner_revdav"
Start-BitsTransfer -Source $URL -Destination $Path
cd "C:\Program Files\irunner_revdav\"
7z x irunner_windows_amd64.exe.xz
$URL="https://www.wixcloud.de/packages/revdav/revdav_windows_amd64.exe.xz"
$Path="C:\Program Files\irunner_revdav"
Start-BitsTransfer -Source $URL -Destination $Path
cd "C:\Program Files\irunner_revdav\"
7z x revdav_windows_amd64.exe.xz
Remove-Item 'C:\Program Files\irunner_revdav\irunner_windows_amd64.exe.xz'
Remove-Item 'C:\Program Files\irunner_revdav\revdav_windows_amd64.exe.xz'
Write-Host "irunner installed"
Start-Sleep -Seconds 3
Read-Host -Prompt "Press ENTER to continue..."

### Log off
Write-Host "________________________________________________________"
Write-Host "User will log off now! `nPlease login with your user account and run User-Autorun.ps1"
Read-Host -Prompt "Press ENTER to continue..."
logoff
