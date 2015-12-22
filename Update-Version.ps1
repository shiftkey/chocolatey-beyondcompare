function Update-Version
{
   $response = Invoke-WebRequest -Uri "http://www.scootersoftware.com/download.php"
   $content = $response.Content

   # Current Version:&nbsp; 4.1.3, build 20814, released Dec. 17, 2015
   $isMatch = $content -match "Current Version:&nbsp; (?<release>\d{1,}\.\d{1,}\.\d{1,}), build (?<build>\d{1,}), released (?<month>[A-Za-z]{3})\. (?<day>[0-9]{1,2})\, (?<year>[0-9]{4})"

   if ($isMatch)
   {
       $release = $matches.release
       $build = $matches.build

       $day = $matches.day
       $month = $matches.month
       $year = $matches.year

       Write-Host "Found version $release.$build"
       Write-Host "Release date: $day/$month/$year"

       $nuspec = Join-Path $PSScriptRoot "src/beyondcompare.nuspec"
       $contents = Get-Content $nuspec -Encoding Utf8
       $newContents = $contents -replace "<version>\d{1,}\.\d{1,}\.\d{1,}\.\d{1,}</version>", "<version>$release.$build</version>"
       $newContents | Out-File $nuspec -Encoding Utf8

       $installScript = Join-Path $PSScriptRoot "src/tools/chocolateyInstall.ps1"
       $contents = Get-Content $installScript -Encoding Utf8
       $newContents = $contents -replace "'\d{1,}\.\d{1,}\.\d{1,}\.\d{1,}'", "'$release.$build'"
       $newContents | Out-File $installScript -Encoding Utf8

       Write-Host
       Write-Host "Updated nuspec and install script, commit this change and open a pull request to the upstream repository on GitHub!"

   }
   else
   {
       Write-Host "Unable to find the release on the download page. Check the regex above"
   }
}

Update-Version