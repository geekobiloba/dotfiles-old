# Alias
# -----

New-Alias -Name "touch" -Value "New-Item"
New-Alias -Name "which" -Value "Get-Command"
New-Alias -Name "zip"   -Value "Compress-Archive"
New-Alias -Name "unzip" -Value "Expand-Archive"

# Better help pager
New-Alias -Name "more.com" -Value "less.exe"

# Safe rm, mv, cp
# ===============

Remove-Item alias:\rm
Remove-Item alias:\mv
Remove-Item alias:\cp

function rm { Remove-Item -Confirm @args }
function mv { Move-Item   -Confirm @args }
function cp { Copy-Item   -Confirm @args }

# UNIX-like cd
# ============

Remove-Item alias:\cd

# cd to $HOME when no argument is given,
# and cd - to go to previous directory.
function cd ($location = "~"){
  if ( $location -eq "-" ){
    $location = $Env:OLDPWD
  }

  $Env:OLDPWD = $( Get-Location )
  Set-Location $location
}

# exa -> eza
# ==========

Remove-Item alias:\ls

function l    { exa        @args }
function ls   { exa        @args }
function l1   { exa -1     @args }
function la   { exa -a     @args }
function lt   { exa -T     @args }
function lta  { exa -Ta    @args }
function lat  { exa -Ta    @args }
function ll   { exa -lgh   @args }
function lla  { exa -lgha  @args }
function llah { exa -lgha  @args }
function llat { exa -lghaT @args }

# Functions
# ---------

# Get info of an IP address.
# Default to the current public IP address
# if no argument is given.
function ipinfo($ipaddr = ""){
  Invoke-WebRequest https://ipinfo.io/$ipaddr |
  Select-Object -ExpandProperty Content |
  jq
}

# UNIX-like pgrep
function pgrep($regex){
  Get-Process |
  ? { $_.ProcessName -match $regex }
}

# UNIX-like pkill
function pkill($regex){
  pgrep $regex |
  Select-Object -Property Id |
  % { Stop-Process $_ }
}

# Hide item
function hide($item){
  (Get-Item $item).Attributes += "Hidden"
}

# Unhide item
function unhide($item){
  (Get-Item -Force $item).Attributes -= "Hidden"
}

# less
# ----

$env:LESS = "-i -R"

# scoop
# -----

Import-Module scoop-completion

# Faster scoop search
Invoke-Expression (&scoop-search --hook)

# Chocolatey
# ----------

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$Env:ChocolateyInstall = "C:\ProgramData\chocolatey"
$ChocolateyProfile     = "$Env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
$Env:Path             += ";$Env:ChocolateyInstall"
$Env:Path             += ";$Env:ChocolateyInstall\bin"

Import-Module $ChocolateyProfile

# oh-my-posh
# ----------

$Env:Path += ";C:\Users\Administrator\AppData\Local\Programs\oh-my-posh\bin"
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\mojada.omp.json" | Invoke-Expression

# Key bindings
# ------------

Set-PSReadLineKeyHandler -Chord 'Ctrl+w' -Function BackwardKillWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+u' -Function BackwardKillLine
#Set-PSReadLineKeyHandler -Chord 'Ctrl+k' -Function ForwardKillLine
Set-PSReadLineKeyHandler -Chord 'Ctrl+k' -Function ForwardDeleteLine
Set-PSReadLineKeyHandler -Chord 'Ctrl+a' -Function BeginningOfLine
Set-PSReadLineKeyHandler -Chord 'Ctrl+e' -Function EndOfLine
Set-PSReadLineKeyHandler -Chord 'Ctrl+y' -Function Yank

