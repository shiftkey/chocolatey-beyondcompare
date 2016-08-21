$ErrorActionPreference = 'Stop'

$LCID = (Get-Culture).LCID
$german = @(3079,1031,5127,4103,2055)
$french = @(2060,11276,3084,9228,12300,1036,5132,13324,6156,14348,10252,4108,7180)
$japanese = @(17, 1041)

$version = '4.1.7.21529'

$packageArgs = @{
  packageName   = 'beyondcompare'
  fileType      = 'exe'
  url           = $url
  silentArgs = '/SP- /VERYSILENT /NORESTART'

  checksum      = ''
  checksumType  = 'md5'
}

$checksumde = '9A379F00070DC8672AC30D1A3272E534'
$checksumfr = '8150F649A909C1E40B6B940D8B70A070'
$checksumjp = '1D503709FE2F0A6111FE56E6271F977E'
$checksum = '4899D66C1C328239C9561C375E66A461'

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
