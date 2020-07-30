$ErrorActionPreference = 'Stop'

# Package Parameters, fail on required items.
$pp = Get-PackageParameters
if (!$pp['IKEY']) { throw "The integration key (IKEY) parameter has not been set, exiting installer." }
if (!$pp['SKEY']) { throw "The secret key (SKEY) parameter has not been set, exiting installer." }
if (!$pp['HOST']) { throw "The API hostname (APIHOST) parameter has not been set, exiting installer." }
if (!$pp['FAILOPEN']) { $pp['FAILOPEN'] = '#1' }
if (!$pp['AUTOPUSH']) { $pp['AUTOPUSH'] = '#1' }
if (!$pp['RDPONLY']) { $pp['RDPONLY'] = '#0' }

if (!$pp['SMARTCARD']) { $pp['SMARTCARD'] = '#0' }
if (!$pp['WRAPSMARTCARD']) { $pp['WRAPSMARTCARD'] = '#1' }

if (!$pp['UAC_PROTECTMODE']) { $pp['UAC_PROTECTMODE'] = '#0' }
if (!$pp['UAC_OFFLINE']) { $pp['UAC_OFFLINE'] = '#1' }
if (!$pp['UAC_OFFLINE_ENROLL']) { $pp['UAC_OFFLINE_ENROLL'] = '#1' }

# Open silentArgs and set required items.
$silentArgs = "/S /V`" /qn IKEY=`"$($pp['IKEY'])`" SKEY=`"$($pp['SKEY'])`" HOST=`"$($pp['HOST'])`" FAILOPEN=`"$($pp['FAILOPEN'])`" AUTOPUSH=`"$($pp['AUTOPUSH'])`" RDPONLY=`"$($pp['RDPONLY'])`" SMARTCARD=`"$($pp['SMARTCARD'])`" UAC_PROTECTMODE=`"$($pp['UAC_PROTECTMODE'])`""

# Add optional parameters if set.
if ($pp['SMARTCARD'] -eq '#1') { $silentArgs += " WRAPSMARTCARD=`"$($pp['WRAPSMARTCARD'])`"" }
if ($pp['UAC_PROTECTMODE'] -eq '#1' -Or $pp['UAC_PROTECTMODE'] -eq '#2') { $silentArgs += " UAC_OFFLINE=`"$($pp['UAC_OFFLINE'])`" UAC_OFFLINE_ENROLL=`"$($pp['UAC_OFFLINE_ENROLL'])`"" }

# Set parameters if not null.
if ($null -ne $pp['PROXYHOST'] -And $null -ne $pp['PROXYPORT']) { $silentArgs += " PROXYHOST=`"$($pp['PROXYHOST'])`" PROXYPORT=`"$($pp['PROXYPORT'])`"" }
if ($null -ne $pp['ENABLEOFFLINE']) { $silentArgs += " ENABLEOFFLINE=`"$($pp['ENABLEOFFLINE'])`"" }
if ($null -ne $pp['USERNAMEFORMAT']) { $silentArgs += " USERNAMEFORMAT=`"$($pp['USERNAMEFORMAT'])`"" }
if ($null -ne $pp['LOGFILE_MAXCOUNT']) { $silentArgs += " LOGFILE_MAXCOUNT=`"$($pp['LOGFILE_MAXCOUNT'])`"" }
if ($null -ne $pp['LOGFILE_MAXSIZEMB']) { $silentArgs += " LOGFILE_MAXSIZEMB=`"$($pp['LOGFILE_MAXSIZEMB'])`"" }

# Close silent Args
$silentArgs += '"'

$packageArgs = @{
  packageName    = 'duo-win-login'
  fileType       = 'exe'
  softwareName   = 'Duo'

  checksum       = '5f5549d93893625c7935c6307793a8d183bb71dff68886f6634160f047e0217d'
  checksumType   = 'sha256'
  url            = 'https://dl.duosecurity.com/duo-win-login-4.1.1.exe'

  silentArgs     = $silentArgs
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
