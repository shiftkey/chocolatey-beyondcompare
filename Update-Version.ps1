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

       $nuspec = Join-Path $PSScriptRoot "beyondcompare.nuspec"
       $contents = Get-Content $nuspec -Encoding Utf8
       $newContents = $contents -replace "<version>\d{1,}\.\d{1,}\.\d{1,}\.\d{1,}</version>", "<version>$release.$build</version>"
       $newContents | Out-File $nuspec -Encoding Utf8

       # TODO: modify chocolatey script
   }
   else
   {
       Write-Host "Unable to find the release on the download page. Check the regex above"
   }
}

Update-Version