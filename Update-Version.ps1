function Parse-ReleaseNotes()
{
    $response = Invoke-WebRequest -Uri https://secure.scootersoftware.com/download.php?zz=v4changelog

    $html = $response.ParsedHtml

    $heading2 = $html.getElementsByTagName("h2");
    $h2 = $heading2[0]

    $secondH2 = $heading2[1]

    "#### " + $h2.innerText

    foreach ($child in $h2.parentElement.children)
    {
        if ($child -eq $h2) {
            continue;
        }

        if ($child -eq $secondH2) {
            break;
        }
    
        $prefix = ""
        $suffix = ""

        if ($child.nodeName -eq "h2")
        {
            $prefix = "`n`r#### "
            $suffix = "`n`r"
        }

        if ($child.nodeName -eq "h4")
        {
            $prefix = "`n`r##### "
            $suffix = "`n`r"
        }

        if ($child.nodeName -eq "ul")
        {
            foreach ($li in $child.children)
            {
                $s = $li.innerHTML -replace "<strong>", "**" -replace "</strong>", "**" -replace "</?code>", "``"
                "* " + $s
            }

        } else {

            $prefix + $child.innerText + $suffix
        }
    }
}

function Calculate-Hash($url)
{
    $tempFile = New-TemporaryFile

    Invoke-WebRequest -Uri $url -OutFile $tempFile

    $hash = Get-FileHash $tempFile -Algorithm SHA256

    Remove-Item $tempFile

    $hash
}

function Update-Version
{

   $response = Invoke-WebRequest -Uri "https://secure.scootersoftware.com/download.php"
   $content = $response.Content

   # Current Version:&nbsp; 4.1.3, build 20814, released Dec. 17, 2015
   $isMatch = $content -match "Current Version:(&nbsp;|\s)*(?<release>\d{1,}\.\d{1,}\.\d{1,}), build (?<build>\d{1,}), released (?<month>[A-Za-z]{3,4})\.? (?<day>[0-9]{1,2})\, (?<year>[0-9]{4})"

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

       $version = "$release.$build"
       $contents.package.metadata.version = $version
       $contents.package.metadata.releaseNotes = $releaseNotes

       $contents.Save($nuspec)

       $installScript = Join-Path $PSScriptRoot "src/tools/chocolateyInstall.ps1"
       $contents = Get-Content $installScript -Encoding Utf8
       $newContents = $contents -replace "'\d{1,}\.\d{1,}\.\d{1,}\.\d{1,}'", "'$version'"

       "de", "fr", "jp", "" | ForEach-Object {
           if ($_ -ne "") {
                $dash = "-" 
           } else {
                $dash = ""
           }

           $hash = Calculate-Hash "https://secure.scootersoftware.com/BCompare-$_$dash$version.exe"
           $newContents = $newContents -replace "checksum$_\s*=\s*'[a-fA-F0-9]+'", "checksum$_ = '$($hash.Hash)'"
       }

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