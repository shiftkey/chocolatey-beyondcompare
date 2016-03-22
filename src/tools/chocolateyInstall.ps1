$LCID = (Get-Culture).LCID
$german = @(3079,1031,5127,4103,2055)
$french = @(2060,11276,3084,9228,12300,1036,5132,13324,6156,14348,10252,4108,7180)
$version = '4.1.5.21031'
if ($german -contains $LCID)
{
    $url = 'http://www.scootersoftware.com/BCompare-de-'+$version+'.exe'
}
elseif ($french -contains $LCID)
{
    $url = 'http://www.scootersoftware.com/BCompare-fr-'+$version+'.exe'
}
else
{
    $url = 'http://www.scootersoftware.com/BCompare-'+$version+'.exe'
}
Install-ChocolateyPackage 'beyondcompare' 'exe' '/SP- /VERYSILENT /NORESTART' $url
