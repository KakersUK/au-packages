import-module au

$releases = "https://duo.com/docs/checksums"

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
      "(?i)(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
      "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
    ".\duo-win-login.nuspec" = @{
      "\<version\>.+" = "<version>$($Latest.Version)</version>"
      "\<copyright\>.+" = "<copyright>$($Latest.Copyright)</copyright>"
    }
  }
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -UseBasicParsing -Uri $releases

  $re = 'duo-win-login-'
  $url = $download_page.links | Where-Object href -match $re | Select-Object -expand href

  $version_re = [Regex]::Matches($url, '(\d+\.\d+.\d+)+')
  $version = $version_re[0].Value

  $date = get-date -Format yyyy
  $copyright = "$date Duo"

  @{
    URL32 = $url
    Version = $version
    Copyright = $copyright
  }
}

update -ChecksumFor 32
