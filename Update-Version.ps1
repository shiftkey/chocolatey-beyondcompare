function Parse-ReleaseNotes()
{
    $response = Invoke-WebRequest -Uri http://www.scootersoftware.com/download.php?zz=v4changelog

    $html = $response.ParsedHtml

    $heading2 = $html.getElementsByTagName("h2");
    $h2 = $heading2[0]

    $secondH2 = $heading2[1]

    "## " + $h2.innerText

    foreach ($child in $h2.parentElement.children)
    {
        if ($child -eq $h2) {
            continue;
        }

        if ($child -eq $secondH2) {
            break;
        }
    
        $prefix = ""
        if ($child.nodeName -eq "h2")
        {
        $prefix = "## "
        }

        if ($child.nodeName -eq "h4")
        {
            $prefix = "#### "
        }

        if ($child.nodeName -eq "ul")
        {
            foreach ($li in $child.children)
            {
                $s = $li.innerHTML -replace "<strong>", "**" -replace "</strong>", "**" -replace "</?code>", "``"
                "* " + $s
            }

        } else {

            $prefix + $child.innerText
        }
    }
}

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

       $releaseNotes = (Parse-ReleaseNotes) -join "`n"

       $nuspec = Join-Path $PSScriptRoot "src/beyondcompare.nuspec"
       $contents = [xml] (Get-Content $nuspec -Encoding Utf8)

       $contents.package.metadata.version = "$release.$build"
       $contents.package.metadata.releaseNotes = $releaseNotes

       $contents.Save($nuspec)

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