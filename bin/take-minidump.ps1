# Take a full minidump of an idle Pharo VM, as bin/take-dump.sh takes a core on Linux, for the
# dump tests: MiniDumpWriteDump (dbghelp.dll), the same user, unelevated, nothing installed
# (docs/patch-notes.md, Windows: 177 MB of an idle Pharo 13 in 1.7 s on the laptop).
#
#   powershell -NoProfile -ExecutionPolicy Bypass -File bin\take-minidump.ps1 `
#       -Vm <PharoConsole.exe> -Image <dev.image> -Script <idle.st> -Out <pharo.dmp>
param(
    [Parameter(Mandatory)] [string] $Vm,
    [Parameter(Mandatory)] [string] $Image,
    [Parameter(Mandatory)] [string] $Script,
    [Parameter(Mandatory)] [string] $Out,
    [int] $SettleSeconds = 30
)
$ErrorActionPreference = 'Stop'

Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
using Microsoft.Win32.SafeHandles;
public static class PolyphemusMinidump {
    [DllImport("dbghelp.dll", SetLastError = true)]
    public static extern bool MiniDumpWriteDump(IntPtr process, uint processId, SafeFileHandle file,
        uint type, IntPtr exception, IntPtr user, IntPtr callback);
}
'@

# idle.st waits four minutes: long enough to load the image and settle into waiting for events.
$target = Start-Process -FilePath $Vm -PassThru -WindowStyle Hidden `
    -WorkingDirectory (Split-Path $Image) `
    -ArgumentList @('--headless', $Image, '--no-default-preferences', 'st', $Script)
Start-Sleep -Seconds $SettleSeconds
if ($target.HasExited) { throw "the VM ended before it could be dumped (exit $($target.ExitCode))" }

$file = [IO.File]::Create($Out)
try {
    # 2 = MiniDumpWithFullMemory: every committed page, as a core holds them.
    if (-not [PolyphemusMinidump]::MiniDumpWriteDump($target.Handle, [uint32] $target.Id, $file.SafeFileHandle,
            2, [IntPtr]::Zero, [IntPtr]::Zero, [IntPtr]::Zero)) {
        throw "MiniDumpWriteDump failed: error $([Runtime.InteropServices.Marshal]::GetLastWin32Error())"
    }
} finally {
    $file.Close()
    Stop-Process -Id $target.Id -Force -ErrorAction SilentlyContinue
}
"minidump of pid $($target.Id): $((Get-Item $Out).Length) bytes in $Out"
