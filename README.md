# XenoAppWindows

**Those are the old installation instructions, to follow the new ones, go on the [New Version](https://github.com/rdlh/XenoAppWindows/wiki/New-Version) wiki page.**

Node modules used :
- pubnub
- node-notifier to display toast notifications on Windows 10
- electron-packager to package the app
- electron-winstaller to create an installer for Windows
- electron-windows-store to create a package for the Windows Store


## Usage :

### To package the app :
```
npm run package-win
```
in "default" or "unpacked" folder -> generates the packaged app in release-builds/XenoApp-win32-ia32 folder



### To create an installer for Windows :
```
npm run create-installer-win
```
in "default" folder -> generates a .exe (installer) in release-builds/windows-installer



### To package the app for Windows Store :
Copy all files generated when packaging the app (files in unpacked/release-builds/XenoApp-win32-ia32) into "unpacked" folder, then delete "release-builds" folder from "unpacked"<br/>
Then run the following command from an elevated PowerShell (run as Administrator) in root folder :
```
electron-windows-store `
            --input-directory unpacked `
            --output-directory store `
            --package-version {version e.g. 1.0.0.0} `
            --package-name XenoApp `
            --package-display-name XenoApp `
            --package-description {description} `
            --assets assets `
            --publisher CN=8D9F185A-3885-4A4D-82B6-4215CABDDBA7 `
            --publisher-display-name "Ask Technologies, Inc." `
            --identity-name AskTechnologiesInc.1809610ACFD3C
```

This will create an .appx file in store folder that can be submitted to the Microsoft store
