Clear-host
    # Присваивание переменных
    $Software = "Adobe Flash Player Firefox NPAPI"
    $DistribPath = '.\'
    $FileName = 'install_flash_player.exe'
    
	# Получаем ссылку на скачивание. Она всегда одинакова.
    $DownLoadURL = "https://fpdownload.macromedia.com/pub/flashplayer/latest/help/install_flash_player.exe"
    Write-Host "-===========-" -ForegroundColor Green
    Write-Host "Product: $Software"
	
    if (Test-Path "$DistribPath\$FileName")
    {
        $ver1 = ((dir $DistribPath -Filter $FileName -ErrorAction Silentlycontinue).versioninfo).fileversion
        write-host "Существующая версия файла - $ver1"
        if (!(Test-Path "$DistribPath\temp\$FileName"))
        {
            New-Item -Path $DistribPath\temp -ItemType "directory" -ErrorAction Silentlycontinue |out-null
            write-host
        }
		# Указываем куда будем сохранять скачиваемый файл
		$destination = "$DistribPath\temp\$FileName"
        # Скачивание файла
        write-host "Скачиваем файл с сервера"
        $wc = New-Object System.Net.WebClient
        $wc.DownloadFile($DownLoadURL, $destination)
        $ver2 = ((dir $DistribPath\temp -Filter $FileName -ErrorAction Silentlycontinue).versioninfo).fileversion
		#сравниваем контрольные суммы
		$hash1 = Get-FileHash $DistribPath\$FileName -Algorithm MD5 |select -exp hash
		$hash2 = Get-FileHash $DistribPath\temp\$FileName -Algorithm MD5 |select -exp hash
		if ($hash1 -eq $hash2)
		{
			write-host "Подтверждаю, что файл на сервере не обновился"
			del $DistribPath\temp -Recurse
		}
		else
		{
			Write-warning "Файл на сервере обновился"
            write-host "Новая версия файла - $ver2"
            try
            {
                Move-Item $DistribPath\temp\$FileName -Destination $DistribPath -Force
				del $DistribPath\temp
				start $DistribPath\$FileName -argumentlist /install
            }
            catch
            {
                Write-Host "Установить не получилось."
            }
			pause
		}
    }
    
    Write-Host "-===========-" -ForegroundColor Green