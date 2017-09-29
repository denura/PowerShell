Clear-host
# Ïðèñâàèâàíèå ïåðåìåííûõ
$Software = "Firefox ESR"
$DistribPath = '.\'
$FileName = 'Firefox Setup esr.exe'
#$URLPage = 'https://www.mozilla.org/ru/firefox/organizations/all/#ru'

# Ïîëó÷àåì ññûëêó íà ñêà÷èâàíèå. Îíà âñåãäà îäèíàêîâà.
$DownLoadURL = "https://download.mozilla.org/?product=firefox-esr-latest&os=win64&lang=ru"
Write-Host "-===========-" -ForegroundColor Green
Write-Host "Product:  $Software"
	
# Ñîçäà¸ì ïàïêó êóäà áóäåì ñêà÷èâàòü äèñòèáóòèâ
if (Test-Path "$DistribPath\$FileName")
{
    $ver1 = ((dir $DistribPath -Filter $FileName -ErrorAction Silentlycontinue).versioninfo).fileversion
    if (!(Test-Path "$DistribPath\temp\$FileName"))
    {
        New-Item -Path $DistribPath\temp -ItemType "directory" -ErrorAction Silentlycontinue |out-null
        write-host
    }
	# Óêàçûâàåì êóäà áóäåì ñîõðàíÿòü ñêà÷èâàåìûé ôàéë
	$destination = "$DistribPath\temp\$FileName"
    # Ñêà÷èâàíèå ôàéëà
    write-host "Ñêà÷èâàåì ôàéë ñ ñåðâåðà"
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($DownLoadURL, $destination)
	$hash1 = Get-FileHash $DistribPath\$FileName -Algorithm MD5 |select -exp hash
	$hash2 = Get-FileHash $DistribPath\temp\$FileName -Algorithm MD5 |select -exp hash
	if ($hash1 -eq $hash2)
	{
		write-host "Ïîäòâåðæäàþ, ÷òî ôàéë íà ñåðâåðå íå îáíîâèëñÿ"
		del $DistribPath\temp -Recurse
	}
	else
	{
		Write-warning "Ôàéë íà ñåðâåðå îáíîâèëñÿ"
        try
        {
            Move-Item $DistribPath\temp\$FileName -Destination $DistribPath -Force
			del $DistribPath\temp
			start $DistribPath\$FileName -ArgumentList /S
        }
        catch
        {
            Write-Host "Install failed"
        }
		pause
	}
}
    
Write-Host "-===========-" -ForegroundColor Green
