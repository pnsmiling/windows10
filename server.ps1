
#Set UAC to 0
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0

### DisableFirstRunCustomize for IE
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "DisableFirstRunCustomize" -Value 2

### Rename PC-Name
$PCName = Read-Host -MaskInput "Enter a PC Name" 
Rename-Computer -NewName $PCName -Verbose

#create User
function Create-NewLocalAdmin {
    [CmdletBinding()]
    param (
        [string] $NewLocalAdmin,
        [securestring] $Password
    )    
    begin {
    }    
    process {
        New-LocalUser "$NewLocalAdmin" -Password $Password -FullName "$NewLocalAdmin" -Description "Temporary local admin"
        Write-Verbose "$NewLocalAdmin local user crated"
        Add-LocalGroupMember -Group "Administrators" -Member "$NewLocalAdmin"
        Write-Verbose "$NewLocalAdmin added to the local administrator group"
    }    
    end {
    }
}
$NewLocalAdmin = Read-Host "New local admin username:"
$Password = Read-Host -AsSecureString "Enter a password for $NewLocalAdmin"
Create-NewLocalAdmin -NewLocalAdmin $NewLocalAdmin -Password $Password -Verbose




#Install Choco
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

### Choco Apps
### Credits to Olli
Write-Host "What department do you belong? "
Write-Host "Press 1 for Dev"
Write-Host "Press 2 for Net"

while($inputValid -ne 1 -and $inputValid -ne 2){
    $inputValid =  read-host -Prompt "Enter number"
    if ($inputValid -eq 1) {
            Write-Host "This PC will be customized for Dev"
            choco install -y 7zip notepadplusplus vscode putty winscp telegram microsoft-teams firefox foxitreader bitrix24 googlechrome git --ignore-checksum
			Add-Type -AssemblyName System.Windows.Forms
			[System.Windows.Forms.SendKeys]::SendWait('~');
    }

    if ($inputValid -eq 2) {
            Write-Host "This PC will be customized for Net"
            choco install -y  winscp putty 7zip telegram notepadplusplus foxitreader firefox captura ffmpeg microsoft-teams googlechrome bitrix24 git --ignore-checksum
			Add-Type -AssemblyName System.Windows.Forms
			[System.Windows.Forms.SendKeys]::SendWait('~');
    }
  
    if($inputValid -ne 1 -and $inputValid -ne 2){
        Write-Host "Please enter 1 or 2"
    }
}


#### Update Choco Apps
#$Trigger=New-ScheduledTaskTrigger -AtLogOn
#$User= “NT AUTHORITY\SYSTEM”
#$Settings=New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries
#$Action= New-ScheduledTaskAction -Execute “PowerShell.exe” -Argument “-ExecutionPolicy ByPass choco upgrade -y all”
#Register-ScheduledTask -TaskName “Choco Upgrade” -Trigger $Trigger -User $User -Action $Action -Settings $Settings –Force

#Visio 2016
#echo "Installing Visio 2016, please wait..."
#cd C:\Users\$env:UserName\Downloads
#Invoke-WebRequest -URI http://46.38.251.87:9192/visio.7z -OutFile visio.7z
#7z x visio.7z
#./setup.exe /download configuration.xml
#echo "Downloading Visio 2016..."
#
#./setup.exe /configure configuration.xml
#echo "done!"

##Office 365 proplus
choco install -y office2019proplus --ignore-checksum


cd C:\Users\$env:UserName\Downloads
Invoke-WebRequest -URI http://46.38.251.87:9192/kerio-connect-koff-9.4.0-6153-win.exe -OutFile kerio-connect-koff-9.4.0-6153-win.exe
./kerio-connect-koff-9.4.0-6153-win.exe /qn


#active office
cd C:\Users\$env:UserName\Downloads
Invoke-WebRequest -URI http://46.38.251.87:9192/active.7z -OutFile active.7z
7z x active.7z
Start-Process cmd.exe -Verb RunAs -Args '/c', "C:\Users\$env:UserName\Downloads\active.cmd"

##install nitro12
cd C:\Users\$env:UserName\Downloads
Invoke-WebRequest -URI http://46.38.251.87:9192/nitro_pro12_ba_x64.7z -OutFile nitro_pro12_ba_x64.7z
7z x nitro_pro12_ba_x64.7z
Start-Process cmd.exe -Verb RunAs -Args '/c', "msiexec /i C:\Users\$env:UserName\Downloads\nitro_pro12_ba_x64.msi"
./"Nitro Pro 12.x - keygen.exe"

#Update Windows
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-PackageProvider -Force -Name NuGet
Install-Module -Force  PSWindowsUpdate
Get-WindowsUpdate -AcceptAll -Install -AutoReboot
