function DuckStation_install(){
	setMSG "Downloading DuckStation"
	$url_duck = getLatestReleaseURLGH "stenzek/duckstation" "zip" "windows-x64" "symbols"	
	download $url_duck "duckstation.zip"
	moveFromTo "$temp/duckstation" "$emusPath\duckstation"
	createLauncher "duckstation"
}
function DuckStation_init(){	
	setMSG "DuckStation - Configuration"
	New-Item -Path "$emusPath\duckstation\portable.txt" -ErrorAction SilentlyContinue
	$destination="$emusPath\duckstation\"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\DuckStation" $destination
	
	#Paths
	sedFile $destination\settings.ini "C:\Emulation" "$emulationPath"
	
	DuckStation_setupSaves
	DuckStation_setResolution $duckstationResolution
}
function DuckStation_update(){
	echo "NYI"
}
function DuckStation_setEmulationFolder(){
	echo "NYI"
}
function DuckStation_setupSaves(){
	setMSG "DuckStation - Creating Saves Links"
	#Saves	
	$SourceFilePath = "$emusPath\duckstation\memcards"
	mkdir "saves\duckstation" -ErrorAction SilentlyContinue
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	$ShortcutPath = -join($emulationPath,"\saves\duckstation\saves.lnk")
	createLink $SourceFilePath $ShortcutPath	
	
	#States
	$SourceFilePath = "$emusPath\duckstation\savestates"
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	$ShortcutPath = -join($emulationPath,"\saves\duckstation\states.lnk")	
	createLink $SourceFilePath $ShortcutPath
}

function DuckStation_setResolution($resolution){
	switch ( $resolution )
	{
		"720P" { $multiplier = 3 }
		"1080P" { $multiplier = 5 }
		"1440P" { $multiplier = 6 }
		"4K" { $multiplier = 9 }
	}	
	
	setConfig "ResolutionScale" $multiplier "$emusPath\duckstation\settings.ini"
}

function DuckStation_setupStorage(){
	echo "NYI"
}
function DuckStation_wipe(){
	echo "NYI"
}
function DuckStation_uninstall(){
	echo "NYI"
}
function DuckStation_migrate(){
	echo "NYI"
}
function DuckStation_setABXYstyle(){
	echo "NYI"
}
function DuckStation_wideScreenOn(){
	echo "NYI"
}
function DuckStation_wideScreenOff(){
	echo "NYI"
}
function DuckStation_bezelOn(){
	echo "NYI"
}
function DuckStation_bezelOff(){
	echo "NYI"
}
function DuckStation_finalize(){
	echo "NYI"
}
function DuckStation_IsInstalled(){
	$test=Test-Path -Path "$emusPath\duckstation"
	if($test){
		echo "true"
	}
}
function DuckStation_resetConfig(){
	DuckStation_init
	if($?){
		echo "true"
	}
}

function DuckStation_wideScreenOn(){
	setConfig "WidescreenHack" "true" "$emusPath\duckstation\settings.ini"
	setConfig "AspectRatio" "16:9" "$emusPath\duckstation\settings.ini"	
}
function DuckStation_wideScreenOff(){
	setConfig "WidescreenHack" "false" "$emusPath\duckstation\settings.ini"
	setConfig "AspectRatio" "4:3" "$emusPath\duckstation\settings.ini"	
}
function DuckStation_retroAchievementsSetLogin(){
	$rat=Get-Content $env:USERPROFILE/AppData/Roaming/EmuDeck/.rat -Raw
	setConfig "Token" $rat "$emusPath\duckstation\settings.ini"
}