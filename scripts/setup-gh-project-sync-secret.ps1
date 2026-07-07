# Create/replace GH_PROJECT_SYNC with a classic PAT (required for user-owned project boards).
param(
    [string]$Repo = "<owner>/<repo>"
)

$patUrl = "https://github.com/settings/tokens/new?scopes=project,repo&description=<repo>-GH_PROJECT_SYNC"

Write-Host "GitHub fine-grained PATs cannot access user-owned Projects."
Write-Host "Use a classic PAT (ghp_...) with scopes: project, repo"
Write-Host ""
Write-Host "Token page: $patUrl"
Write-Host ""

$pat = Read-Host "Paste classic PAT (ghp_...)" -AsSecureString
$plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($pat))

if ([string]::IsNullOrWhiteSpace($plain)) {
    Write-Error "No token provided."
    exit 1
}
if (-not $plain.StartsWith("ghp_")) {
    Write-Error "Expected a classic PAT starting with ghp_."
    exit 1
}

Write-Host "Setting GH_PROJECT_SYNC on $Repo..."
$plain | gh secret set GH_PROJECT_SYNC --repo $Repo
Write-Host "Secret updated."
Write-Host "Done. Configure scripts/project-board.env and test with scripts/sync-project-board.ps1"
