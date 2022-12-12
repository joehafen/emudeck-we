curl -L --output main.zip --url "https://github.com/EmuDeck/emudeck-we/archive/refs/heads/main.zip"
powershell -ExecutionPolicy Bypass -command "& { Expand-Archive -Path main.zip -DestinationPath .\ -Force; Remove-Item main.zip -Recurse -Force -Confirm:$false; robocopy EmuDeck-we-main $env:USERPROFILE\EmuDeck\backend /s /Move /NFL /NDL /NJH /NJS /nc /ns /np; Remove-Item EmuDeck-we-main -Recurse -Force -Confirm:$false }" 
powershell -ExecutionPolicy Bypass . $env:USERPROFILE\EmuDeck\backend\EmuDeck_shell.ps1