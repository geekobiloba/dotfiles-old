# Patch Neofetch bug with PowerShell in Windows
# ---------------------------------------------

$anchor   = @{}
$psinfo   = @{}
$neofetch = @{}

$neofetch["script"] = @{}
$neofetch["config"] = @{}

# Fix PowerShell version
# ======================

$neofetch["script"]["path"] =
  ((Get-Content (Get-Command neofetch).Definition)[0] -split " ")[1]

$anchor["pattern"] = ".*yash\).*\n(.+\n)+;;"

$psinfo["content"] = @'

        powershell.exe)
            shell+=$("$SHELL" -Command '$PSVersionTable.PSVersion.ToString()' 2>&1)
            shell=${shell/ $shell_name}
        ;;

'@

# Get neofetch full path
$neofetch["script"]["content"] =
  Get-Content -Raw $neofetch["script"]["path"]

# Get anchor content
$neofetch["script"]["content"] -match $anchor["pattern"] *>$null

$anchor["content"] = $matches[0]

# Append psinfo to anchor
$neofetch["script"]["fixed"] =
  $neofetch["script"]["content"] -replace `
    [Regex]::Escape($anchor["content"]),  `
    ($anchor["content"] + $psinfo["content"])

# Write neofetch without BOM
[System.IO.File]::WriteAllLines(
  $neofetch["script"]["path"],
  $neofetch["script"]["fixed"],
  (New-Object System.Text.UTF8Encoding $False)
)

# Remove GPU info
# ===============

$neofetch["config"]["path"   ] = $Env:Home + "\.config\neofetch\config.conf"
$neofetch["config"]["pattern"] = '.*info \"GPU\".*'

# Get config content
$neofetch["config"]["content"] = Get-Content $neofetch["config"]["path"]

# Fix config
$neofetch["config"]["fixed"] =
  $neofetch["config"]["content"] -replace `
    $neofetch["config"]["pattern"], ""
  
# Write config without BOM
[System.IO.File]::WriteAllLines(
  $neofetch["config"]["path"],
  $neofetch["config"]["fixed"],
  (New-Object System.Text.UTF8Encoding $False)
)

