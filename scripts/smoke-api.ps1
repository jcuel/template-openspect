# API smoke test stub — customize for your application.
# Reference: https://github.com/jcuel/disk-tool/blob/dev/scripts/smoke-api.ps1
param(
    [string]$Bin = ".\bin\<your-project>.exe"
)

if (-not (Test-Path $Bin)) {
    Write-Error "smoke-api.ps1: binary not found at $Bin. Implement before enabling full CI."
    exit 1
}

Write-Host "smoke-api.ps1: stub — replace with your API health checks"
exit 0
