$LCID = (Get-Culture).LCID
$german = @(3079,1031,5127,4103,2055)
$french = @(2060,11276,3084,9228,12300,1036,5132,13324,6156,14348,10252,4108,7180)
if ($LCID -in $german)
{
    $url = 'http://www.scootersoftware.com/BCompare-de-4.1.1.20615.exe'
}
elseif ($LCID -in $french)
{
    $url = 'http://www.scootersoftware.com/BCompare-fr-4.1.1.20615.exe'
}
else
{
    $url = 'http://www.scootersoftware.com/BCompare-4.1.1.20615.exe'
}
Install-ChocolateyPackage 'beyondcompare' 'exe' '/SP- /VERYSILENT /NORESTART' $url
