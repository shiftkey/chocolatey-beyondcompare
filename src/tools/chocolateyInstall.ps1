$ErrorActionPreference = 'Stop'

$LCID = (Get-Culture).LCID
$german = @(3079,1031,5127,4103,2055)
$french = @(2060,11276,3084,9228,12300,1036,5132,13324,6156,14348,10252,4108,7180)
$japanese = @(17, 1041)

$version = '4.1.8.21575'

$packageArgs = @{
  packageName   = 'beyondcompare'
  fileType      = 'exe'
  url           = $url
  silentArgs = '/SP- /VERYSILENT /NORESTART'

  checksum      = ''
  checksumType  = 'md5'
}

$checksumde = '7E2F60B1225AA20C20F5241608B3B919'
$checksumfr = 'F56DECFB8F7A5E516316C4D14596CA02'
$checksumjp = '31D7DFF43B584AAA7A61BCD14C051AAB'
$checksum = '79F7F43630E1677D22A637E1BDED5B69'

if ($german -contains $LCID)
{
    $packageArgs.url = 'https://secure.scootersoftware.com/BCompare-de-'+$version+'.exe'
    $packageArgs.checksum = $checksumde
}
elseif ($french -contains $LCID)
{
    $packageArgs.url = 'https://secure.scootersoftware.com/BCompare-fr-'+$version+'.exe'
    $packageArgs.checksum = $checksumfr
}
elseif ($japanese -contains $LCID)
{
    $packageArgs.url = 'https://secure.scootersoftware.com/BCompare-jp-'+$version+'.exe'
    $packageArgs.checksum = $checksumjp
}
else
{
    $packageArgs.url = 'https://secure.scootersoftware.com/BCompare-'+$version+'.exe'
    $packageArgs.checksum = $checksum
}

# This is necessary to avoid Invoke-WebRequest failing with "The request was aborted: Could not create SSL/TLS secure channel."
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Install-ChocolateyPackage @packageArgs
