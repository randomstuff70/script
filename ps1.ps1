Add-Type -AssemblyName Microsoft.VisualBasic

$host.UI.RawUI.BackgroundColor = "Black"
$host.UI.RawUI.ForegroundColor = "White"

# Fullscreen
$buf = $host.UI.RawUI.BufferSize
$win = $host.UI.RawUI.WindowSize
$win.Width  = [Math]::Min($win.Width,  $buf.Width)
$win.Height = [Math]::Min($win.Height, $buf.Height)
$host.UI.RawUI.WindowSize = $win

# Disable close button and maximize window via WinAPI
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinHelper {
    [DllImport("user32.dll")] public static extern IntPtr GetConsoleWindow();
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int n);
    [DllImport("user32.dll")] public static extern IntPtr GetSystemMenu(IntPtr h, bool r);
    [DllImport("user32.dll")] public static extern bool DeleteMenu(IntPtr h, int id, int f);
}
"@

$hwnd = [WinHelper]::GetConsoleWindow()
[WinHelper]::ShowWindow($hwnd, 3)
$menu = [WinHelper]::GetSystemMenu($hwnd, $false)
[WinHelper]::DeleteMenu($menu, 0xF060, 0x0)  # Remove close button

$msg = "im 12 ban me twitch"
Clear-Host

while ($true) {
    $w = $host.UI.RawUI.WindowSize.Width
    $h = $host.UI.RawUI.WindowSize.Height
    $lines = $msg -split "`n"
    $topPad = [Math]::Max(0, [Math]::Floor(($h - $lines.Count) / 2))
    $host.UI.RawUI.CursorPosition = @{X=0;Y=0}

    for ($r = 0; $r -lt $topPad; $r++) { Write-Host (" " * $w) }

    foreach ($line in $lines) {
        $pad = [Math]::Max(0, [Math]::Floor(($w - $line.Length) / 2))
        $out = (" " * $pad) + $line
        $out = $out.PadRight($w)
        Write-Host $out
    }

    Start-Sleep -Milliseconds 100

    if ($host.UI.RawUI.KeyAvailable) {
        $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
      if ($key.Key -eq 'Escape') { }
    }
}
