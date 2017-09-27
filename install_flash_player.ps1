Clear-host
    # Ïðèñâàèâàíèå ïåðåìåííûõ
    $Software = "Adobe Flash Player Firefox NPAPI"
    $DistribPath = '.\'
    $FileName = 'install_flash_player.exe'
    
	# Ïîëó÷àåì ññûëêó íà ñêà÷èâàíèå. Îíà âñåãäà îäèíàêîâà.
    $DownLoadURL = "https://fpdownload.macromedia.com/pub/flashplayer/latest/help/install_flash_player.exe"
    Write-Host "-===========-" -ForegroundColor Green
    Write-Host "Product: $Software"
	
    if (Test-Path "$DistribPath\$FileName")
    {
        $ver1 = ((dir $DistribPath -Filter $FileName -ErrorAction Silentlycontinue).versioninfo).fileversion
        write-host "Ñóùåñòâóþùàÿ âåðñèÿ ôàéëà - $ver1"
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
        $ver2 = ((dir $DistribPath\temp -Filter $FileName -ErrorAction Silentlycontinue).versioninfo).fileversion
		#ñðàâíèâàåì êîíòðîëüíûå ñóììû
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
            write-host "Íîâàÿ âåðñèÿ ôàéëà - $ver2"
            try
            {
                Move-Item $DistribPath\temp\$FileName -Destination $DistribPath -Force
				del $DistribPath\temp
				start $DistribPath\$FileName -argumentlist /install
            }
            catch
            {
                Write-Host "Óñòàíîâèòü íå ïîëó÷èëîñü."
            }
			pause
		}
    }
    
    Write-Host "-===========-" -ForegroundColor Green
