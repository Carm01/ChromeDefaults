#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=3.ico
#AutoIt3Wrapper_Outfile_x64=InstallChrome_without.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Fileversion=1.1.0.0
#AutoIt3Wrapper_Res_ProductVersion=1.1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Carm0
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

	https://dl.google.com/chrome/install/ChromeStandaloneSetup64.exe

	http://dl.google.com/chrome/install/375.126/chrome_installer.exe

	function lo(a){if(a.eh&&a.Cm)a=fo(a)?"/dl/chrome/install/googlechromestandaloneenterprise64.msi":"/dl/chrome/install/googlechromestandaloneenterprise.msi";else if(Nn(a))a=ao()&&!a.va?fo(a)?a.Ha?"/chrome/install/beta/ChromeBetaStandaloneSetup64.exe":a.la?"/chrome/install/dev/ChromeDevStandaloneSetup64.exe":"/chrome/install/ChromeStandaloneSetup64.exe":a.Ha?"/chrome/install/beta/ChromeBetaStandaloneSetup.exe":a.la?"/chrome/install/dev/ChromeDevStandaloneSetup.exe":"/chrome/install/ChromeStandaloneSetup.exe":
	--
	"C:\Program Files (x86)\Google\Chrome\Application\62.0.3202.62\Installer\setup.exe" --uninstall --system-level --force-uninstall

	ChromeSetup.exe /silent /install
#ce ----------------------------------------------------------------------------
; Script Start - Add your code below here
#include <Array.au3>
#include <File.au3>
#include <InetConstants.au3>
#include <EventLog.au3>

Local $ecode, $CVersion

If UBound(ProcessList(@ScriptName)) > 2 Then Exit

If FileExists('C:\Users\Public\DelChrome.bat') Then
	FileDelete('C:\Users\Public\DelChrome.bat')
EndIf

If FileExists('C:\Users\Public\DelChrome.bat - Shortcut.lnk') Then
	FileDelete('C:\Users\Public\DelChrome.bat - Shortcut.lnk')
EndIf

chk7z()
killapp()
getuninstall()
dlinstall()
applysetting()


Func killapp()
	$cmd = 'tasklist /FI "IMAGENAME eq chrome.exe" 2>NUL | find /I /N "chrome.exe">NUL && ' & _
			'if "%ERRORLEVEL%"=="0" taskkill.exe /im chrome.exe /t /f'

	RunWait('"' & @ComSpec & '" /c ' & $cmd, @SystemDir, @SW_HIDE)
	Sleep(300)
	$cmd = 'tasklist /FI "IMAGENAME eq google*" 2>NUL | find /I /N "google">NUL && ' & _
			'if "%ERRORLEVEL%"=="0" taskkill.exe /im google* /t /f'

	RunWait('"' & @ComSpec & '" /c ' & $cmd, @SystemDir, @SW_HIDE)
	Sleep(300)
EndFunc   ;==>killapp

Func getuninstall()
	If FileExists("C:\Program Files (x86)\Google\Chrome\Application") Then
		$SSlist = _FileListToArrayRec("C:\Program Files (x86)\Google\Chrome\Application", "setup.exe", $FLTAR_FILES, $FLTAR_RECUR, $FLTAR_NOSORT, $FLTAR_FULLPATH)
		$a = '"' & $SSlist[1] & '"'
	Else
		$a = ""
	EndIf

	If $a <> "" Then
		;MsgBox(0, "", $a)
		ShellExecuteWait($a, " --uninstall --system-level --force-uninstall", "")
		DirRemove("C:\Program Files (x86)\Google\", 1)
	EndIf
	If FileExists("C:\Program Files (x86)") Then
		;MsgBox(0, "", "dir exists")
		DirRemove("C:\Program Files (x86)\Google\", 1)
	EndIf

	If FileExists("C:\Users\Default\AppData\Local\Google") Then
		DirRemove("C:\Users\Default\AppData\Local\Google", 1)
	EndIf

	; remove any potential settings
	RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Google\Chrome", "DefaultBrowserSettingEnabled")
	RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Google\Chrome", "DefaultPluginsSetting")
	RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Google\Chrome", "DefaultPopupsSetting")

	DirRemove('c:\users\default\appdata\local\google')


EndFunc   ;==>getuninstall




Func dlinstall()
	;RegDelete('HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google')
	; download and install
	$Version = "Google Chrome"
	$dia = "https://dl.google.com/chrome/install/375.126/chrome_installer.exe"
	_webDownloader($dia, "ChromeSetup.exe", $Version)
	SplashTextOn("Progress", "", 210, 75, -1, -1, 16, "Tahoma", 10)
	ControlSetText("Progress", "", "Static1", "Installing Chrome", 2)
	ShellExecuteWait("ChromeSetup.exe", " /silent /install", "C:\Windows\Temp\")
	If FileExists(@ScriptDir & "\bookmarks.html") Then
		FileCopy(@ScriptDir & "\bookmarks.html", "C:\Program Files (x86)\Google\Chrome\Application\bookmarks.html", 1)
	Else
		FileInstall("bookmarks.html", "C:\Program Files (x86)\Google\Chrome\Application\bookmarks.html", 1)
	EndIf

	If FileExists(@ScriptDir & "\master_preferences") Then
		FileCopy(@ScriptDir & "\master_preferences", "C:\Program Files (x86)\Google\Chrome\Application\master_preferences", 1)
	Else
		FileInstall("master_preferences", "C:\Program Files (x86)\Google\Chrome\Application\master_preferences", 1)
	EndIf

	If Not FileExists("C:\Windows\System32\GroupPolicy\adm") Then
		;DirCreate("C:\Windows\System32\GroupPolicy\Adm")
		;FileInstall("chrome.adm", "C:\Windows\System32\GroupPolicy\Adm\chrome.adm", 1)
	Else
		;FileInstall("chrome.adm", "C:\Windows\System32\GroupPolicy\Adm\chrome.adm", 1)
	EndIf
	Sleep(300)
	;FileInstall('Google.7z', 'C:\users\default\appdata\local\Google.7z', 1)
	;ShellExecuteWait('C:\Program Files\7-Zip\7z.exe', ' x Google.7z', 'C:\Users\Default\AppData\Local\', "", @SW_HIDE)
	;RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Google\Chrome", "DefaultBrowserSettingEnabled")
	;RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Google\Chrome", "DefaultPluginsSetting")
	;RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Google\Chrome", "DefaultPopupsSetting")
	;FileDelete("C:\windows\temp\" & "\ChromeSetup.exe")
	;FileDelete('C:\Users\Default\AppData\Local\Google.7z')
	SplashOff()
	$ecode = '411'
	$CVersion = FileGetVersion("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe", $FV_FILEVERSION)
	EventLog()

EndFunc   ;==>dlinstall


Func _webDownloader($sSourceURL, $sTargetName, $sVisibleName, $sTargetDir = "C:\windows\temp", $bProgressOff = True, $iEndMsgTime = 2000, $sDownloaderTitle = "Google Chrome")
	; Declare some general vars
	Local $iMBbytes = 1048576

	; If the target directory doesn't exist -> create the dir
	If Not FileExists($sTargetDir) Then DirCreate($sTargetDir)

	; Get download and target info
	Local $sTargetPath = $sTargetDir & "\" & $sTargetName
	Local $iFileSize = InetGetSize($sSourceURL)
	Local $hFileDownload = InetGet($sSourceURL, $sTargetPath, $INET_LOCALCACHE, $INET_DOWNLOADBACKGROUND)

	; Show progress UI
	ProgressOn($sDownloaderTitle, "" & $sVisibleName)
	GUISetFont(8, 400)
	; Keep checking until download completed
	Do
		Sleep(250)

		; Set vars
		Local $iDLPercentage = Round(InetGetInfo($hFileDownload, $INET_DOWNLOADREAD) * 100 / $iFileSize, 0)
		Local $iDLBytes = Round(InetGetInfo($hFileDownload, $INET_DOWNLOADREAD) / $iMBbytes, 2)
		Local $iDLTotalBytes = Round($iFileSize / $iMBbytes, 2)

		; Update progress UI
		If IsNumber($iDLBytes) And $iDLBytes >= 0 Then
			ProgressSet($iDLPercentage, $iDLPercentage & "% - Downloaded " & $iDLBytes & " MB of " & $iDLTotalBytes & " MB")
		Else
			ProgressSet(0, "Downloading '" & $sVisibleName & "'")
		EndIf
	Until InetGetInfo($hFileDownload, $INET_DOWNLOADCOMPLETE)

	; If the download was successfull, return the target location
	If InetGetInfo($hFileDownload, $INET_DOWNLOADSUCCESS) Then
		ProgressSet(100, "Downloading '" & $sVisibleName & "' completed")
		If $bProgressOff Then
			Sleep($iEndMsgTime)
			ProgressOff()
		EndIf
		Return $sTargetPath
		; If the download failed, set @error and return False
	Else
		Local $errorCode = InetGetInfo($hFileDownload, $INET_DOWNLOADERROR)
		ProgressSet(0, "Downloading '" & $sVisibleName & "' failed." & @CRLF & "Error code: " & $errorCode)
		If $bProgressOff Then
			Sleep($iEndMsgTime)
			ProgressOff()
		EndIf
		SetError(1, $errorCode, False)
	EndIf
EndFunc   ;==>_webDownloader


Func chk7z()
	If Not FileExists('C:\Program Files\7-Zip\7z.exe') Then
		FileInstall('7z1805-x64.exe', 'C:\windows\temp\7z1805-x64.exe', 1)
		ShellExecuteWait('C:\windows\temp\7z1801-x64.exe', ' /S', "", "", @SW_HIDE)
	EndIf
EndFunc   ;==>chk7z



Func EventLog()

	If $ecode = '404' Then
		Local $hEventLog, $aData[4] = [0, 4, 0, 4]
		$hEventLog = _EventLog__Open("", "Application")
		_EventLog__Report($hEventLog, 1, 0, 404, @UserName, @UserName & ' No "exe" found for Google Chrome. The webpage and/or download link might have changed. ' & @CRLF, $aData)
		_EventLog__Close($hEventLog)
	EndIf

	If $ecode = '411' Then
		Local $hEventLog, $aData[4] = [0, 4, 1, 1]
		$hEventLog = _EventLog__Open("", "Application")
		_EventLog__Report($hEventLog, 0, 0, 411, @UserName, @UserName & " Google Chrome " & "version " & $CVersion & " successfully installed." & @CRLF, $aData)
		_EventLog__Close($hEventLog)
	EndIf
EndFunc   ;==>EventLog


Func applysetting()
	; creates defaults without the use of a Chrome Profile in default/appdata
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Google\Chrome", "DefaultBrowserSettingEnabled", "REG_DWORD", "00000000") ; removes annoying nag for any user to set chrome as default
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Google\Chrome", "DefaultPopupsSetting", "REG_DWORD", "00000001") ; turns off pop up for all users
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Google\Chrome", 'DefaultCookiesSetting', 'REG_DWORD', '4') ; keeps local data until you quit the browser i.e cookies and the what not

EndFunc   ;==>applysetting

