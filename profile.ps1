### Aliase ###

# Ich kann mir Select-String nicht merken ...
Set-Alias grep Select-String

# Meinen Texteditor aufrufen
Set-Alias edit 'C:\Program Files (x86)\Notepad++\notepad++.exe'

# Weil where schon als Alias für Where-Object definiert ist
Set-Alias which C:\Windows\System32\where.exe

### Funktionen ###

# Ins Windows-Verzeichnis wechseln
function cdw
{
  Set-Location C:\Windows
}

# Einen neuen Ordner erzeugen und direkt hineinwechseln
function mcd($dir)
{
  $newDir = New-Item $dir -Type Directory
  Set-Location $newDir
}

# Die Version dieses Windows ermitteln
function ver
{
  [Environment]::OSVersion.VersionString
}

### Umgebungsvariablen ###

# Den Profil-Ordner in den PATH aufnehmen
& {
  $myDir = Split-Path $profile
  if($Env:Path -notlike "*$myDir*")
  {
    $Env:Path = "$myDir;$Env:Path"
  }
}

### Standard-Parameter ###

# dir soll immer auch versteckte und Systemdateien anzeigen
$PSDefaultParameterValues['Get-ChildItem:Force'] = $true

# Hilfe bitte immer detailliert
$PSDefaultParameterValues['Get-Help:Detailed'] = $true

### Virtuelle Laufwerke ###

# HKEY_CLASSES_ROOT
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT `
            -Description 'HKEY_CLASSES_ROOT' | Out-Null

# HKEY_USERS
New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS `
            -Description 'HKEY_USERS' | Out-Null

# HKEY_CURRENT_CONFIG
New-PSDrive -Name HKCC -PSProvider Registry `
            -Root 'HKLM:\SYSTEM\CurrentControlSet\Hardware Profiles\Current' `
            -Description 'HKEY_CURRENT_CONFIG' | Out-Null

# # "Laufwerk" W:
# New-PSDrive -Name W -PSProvider FileSystem -Root 'D:\Projekte\Weltherrschaft' `
#   | Out-Null

### Prompt ###

function prompt
{
  # Den aktuellen Pfad auf maximal 60 Zeichen kürzen
  function TrimPath
  {
    $max = 60
    $slash = [IO.Path]::DirectorySeparatorChar # Windows: \, *ix: /
    $path = (Get-Location).Path
    if($path.Length -gt $max) {
      $dirs = $path.Split($slash)
      if($dirs.Count -gt 3) {
        $head = $dirs[0] + $slash + $dirs[1] + $slash
        $tail = $dirs[-1]
        for($count = $dirs.Count - 2; $count -gt 1; $count -= 1) {
          if( ($head.Length + $tail.Length + $dirs[$count].Length + 4) -gt $max ) {
            break
          }
          $tail = $dirs[$count] + $slash + $tail
        }
        if($count -ge 2) {
            $tail = '...' + $slash + $tail
        }
        $path = $head + $tail
      }
    }
    return $path
  }

  $cr = if($psISE) { "" } else { "`n" }
  Write-Host "$($cr)PS " -NoNewline
  Write-Host (TrimPath) -NoNewline -ForegroundColor Yellow
  return "$('>' * ($nestedPromptLevel + 1)) "
}
