# Sync GitHub Project board Status with issue state (Windows).
$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$bash = Get-Command bash -ErrorAction SilentlyContinue
if (-not $bash) {
    Write-Error "bash is required (Git for Windows or WSL)."
}
& bash "$scriptDir/sync-project-board.sh" @args
