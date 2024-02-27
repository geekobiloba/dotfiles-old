#
# PowerShell profile for macOS
#

<# Oh My Posh #>

oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/velvet.omp.json'
| Invoke-Expression

<# Key bindings #>

Set-PSReadLineKeyHandler -Chord 'Ctrl+LeftArrow'  -Function BackwardWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+RightArrow' -Function ForwardWord

<# Aliases #>

New-Alias -Name "ls"    -Value "Get-ChildItem"
New-Alias -Name "cat"   -Value "Get-Content"
New-Alias -Name "sort"  -Value "Sort-Object"
New-Alias -Name "which" -Value "Get-Command"
New-Alias -Name "wc"    -Value "Measure-Command"

# NeoVim
New-Alias -Name "vi"  -Value "nvim"
New-Alias -Name "vim" -Value "nvim"

# Safe rm, mv, cp
function rm { Remove-Item -Confirm @args }
function mv { Move-Item   -Confirm @args }
function cp { Copy-Item   -Confirm @args }

<# Modules #>

Import-Module posh-git

