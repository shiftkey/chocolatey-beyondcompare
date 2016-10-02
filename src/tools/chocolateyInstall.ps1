$ErrorActionPreference = 'Stop'

$LCID = (Get-Culture).LCID
$german = @(3079,1031,5127,4103,2055)
$french = @(2060,11276,3084,9228,12300,1036,5132,13324,6156,14348,10252,4108,7180)
$japanese = @(17, 1041)

$version = '4.1.9.21719'

$packageArgs = @{
  packageName   = 'beyondcompare'
  fileType      = 'exe'
  url           = $url
  silentArgs = '/SP- /VERYSILENT /NORESTART'

  checksum      = ''
  checksumType  = 'sha256'
}

$checksumde = '1AA3DA1BA3A0D8A17D0CD3194859B4B002304C9985F42A432D7C1DC9BCDD455A'
$checksumfr = '2DA2F3AF42C79431D565B2A461E8FE78B022388FBB248F1C84B49985C09DCD14'
$checksumjp = 'EACE6808F52B6E4EDD5A68F196B133AE61B4E278F6431AF312C2ED8199671F0B'
$checksum = '7396AAD00BE94625EF1CBC638D197DA066E95E80CEDBB5661454A4CFF3DCCE40'

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
