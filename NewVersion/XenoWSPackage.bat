:: comment this if you want a better overview of the command executed (recommanded for debug)
@echo off

set publisherDisplayName="Ask Technologies, Inc."
set identityName="AskTechnologiesInc.289824193446D"
set appName=XenoApp
set publisher=CN=8D9F185A-3885-4A4D-82B6-4215CABDDBA7

:: comment this if you don't want the created installation files (output folder) to be removed
set postInstallClean=y

:: clean eventual remainning artefacts of previous installations
cmd /C if exist .\output\ rd /q /s .\output\ || goto :error 

:: main command -> packages the nativefier app for the windows store
cmd /C electron-windows-store --publisher-display-name=%publisherDisplayName% --identity-name %identityName% --assets XenoApp-win32-x64\assets --input-directory %appName%-win32-x64/ --output-directory %appName% --package-version 1.0.0.0 --package-name %appName% --package-display-name %appName% || goto :error 

:: because of some weird icon issues we need to unpack the app, create some
:: uwp configs for the assets (makepri commands), and then repack the app
cmd /C makeAppx.exe unpack /p .\%appName%\%appName%.appx /d ".\output" && cd .\output && makepri.exe createconfig /cf priconfig.xml /dq en-US /pv 10.0.0 && makepri new /pr . /cf priconfig.xml && makeappx.exe pack /d . /p ..\%appName%\%appName%.appx /l /o || goto :error

echo. && echo. && echo. && echo [96mYou will now have to select the generted PFX certficate for your app.[0m
echo [96mIt should be located around C:\Users\{user}}\AppData\Roaming\electron-windows-store\{certficate id}\{certficate id}.pfx[0m && echo.
pause

:: file selector
set dialog="about:<input type=file id=FILE><script>FILE.click();new ActiveXObject
set dialog=%dialog%('Scripting.FileSystemObject').GetStandardStream(1).WriteLine(FILE.value);
set dialog=%dialog%close();resizeTo(0,0);</script>"

for /f "tokens=* delims=" %%p in ('mshta.exe %dialog%') do set "file=%%p"
echo selected  file is : "%file%"

:: because the app was unpacked and repacked again, we need to sign it again using signtool and 
:: the certificate (.pfx) generated by the electron-windows-store command
cmd /C signtool.exe sign /fd SHA256 /a /f %file% ..\%appName%\%appName%.appx || goto :error

:: post install clean
setlocal
cd ..\
if exist .\output\ (
	if defined postInstallClean (
		rd /q /s .\output\)) || goto :error 
endlocal

echo %appName% successfully installed and packaged.

pause

:error
exit /b %errorlevel%
pause