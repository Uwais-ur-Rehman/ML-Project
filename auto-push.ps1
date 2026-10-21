
Set-Location -LiteralPath "C:\Users\Uwais ur Rehman\OneDrive\Documents\GitHub\ML-Project"

$branch = (git branch --show-current).Trim()
if (-not $branch) { throw "No Git branch found." }

Write-Host "Auto-upload active on branch: $branch"
Write-Host "Checking every 15 seconds. Press Ctrl+C to stop."

while ($true) {
    Start-Sleep -Seconds 15

    $changes = git status --porcelain
    if ($LASTEXITCODE -ne 0) { continue }
    if (-not $changes) { continue }

    git add -A
    if ($LASTEXITCODE -ne 0) { continue }

    git diff --cached --quiet
    if ($LASTEXITCODE -eq 0) { continue }

    git commit -m "Auto-sync: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    if ($LASTEXITCODE -ne 0) { continue }

    git pull --rebase origin $branch
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Pull failed. Resolve the issue before continuing."
        break
    }

    git push origin $branch
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Upload successful."
    } else {
        Write-Host "Push failed. Check GitHub authentication."
    }
}
