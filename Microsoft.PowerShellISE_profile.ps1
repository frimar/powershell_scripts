function BinIchAdmin() {
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $princ = New-Object System.Security.Principal.WindowsPrincipal($identity)
    return ($princ.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))
  }
  
  & {
    $ui = (Get-Host).UI.RawUI
    if(BinIchAdmin) {
      $ui.BackgroundColor = "DarkRed"
      Clear-Host
    }
  }