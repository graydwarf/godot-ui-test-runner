# Sync GDScript Linter plugin from source project
# Usage: .\sync-linter-plugin.ps1

$linterSource = "C:\dad\projects\godot\godot-4\plugins\godot-gdscript-linter\addons\gdscript-linter"
$linterDest = "C:\dad\projects\godot\godot-4\plugins\godot-ui-automation\addons\gdscript-linter"

Write-Host "Syncing GDScript Linter plugin..." -ForegroundColor Cyan

if (Test-Path $linterDest) {
    Remove-Item -Path "$linterDest\*" -Recurse -Force
}
Copy-Item -Path "$linterSource\*" -Destination $linterDest -Recurse -Force

Write-Host "Done!" -ForegroundColor Green
