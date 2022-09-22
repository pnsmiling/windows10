#install irunner
New-Item -Path 'C:\Program Files\Irunner' -ItemType Directory
cd 'C:\Program Files\Irunner'
Invoke-WebRequest -URI https://wixcloud.de/packages/irunner/irunner_windows_amd64.exe.xz -OutFile irunner_windows_amd64.exe.xz
7z x irunner_windows_amd64.exe.xz
./irunner_windows_amd64.exe -force
#enter
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('~');

#install revdav
Invoke-WebRequest -URI https://www.wixcloud.de/packages/revdav/revdav_windows_amd64.exe.xz -OutFile revdav_windows_amd64.exe.xz
7z x revdav_windows_amd64.exe.xz
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('~');

#Create Shortcut
$SourceFilePath = "C:\Program Files\Irunner\irunner_windows_amd64.exe"
$ShortcutPath = "C:\Users\$env:UserName\Desktop\Irunner.lnk"
$WScriptObj = New-Object -ComObject ("WScript.Shell")
$shortcut = $WscriptObj.CreateShortcut($ShortcutPath)
$shortcut.TargetPath = $SourceFilePath
$shortcut.Save()
Copy-Item "C:\Users\sysadmin\Desktop\Irunner.lnk"  "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -Force
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('~');

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
$ident = ./revdav_windows_amd64.exe -ident
$user = $env:UserName
New-Item "C:\Program Files\Irunner\$user" -ItemType Directory
New-Item "C:\Program Files\Irunner\$user\ident.txt" -ItemType File -Value "$user $ident"
cmdkey /generic:git:https://git.wixcloud.de /user:dxu353 /pass:sBM9Dr2X7MVH9cg
git config --global push.autoSetupRemote true
git config --global user.email "phong.phu@dision.tech"
git config --global user.name "dxu383"
git init
git checkout -b $user
git add "C:\Program Files\Irunner\$user\ident.txt"
git commit -m "User $user identity"
git push -f https://git.wixcloud.de/dynexo/winstall10 $user

