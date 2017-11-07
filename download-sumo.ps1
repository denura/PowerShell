Clear-host
Add-Type -AssemblyName "System.IO.Compression.FileSystem"
    $Software = "SuMo"
    $DistribPath = '.\'
    $FileName = 'sumo.zip'
    #$URLPage = 'http://www.kcsoftwares.com/?download'
    
    $DownLoadURL = "http://www.kcsoftwares.com/files/sumo.zip"
    #$DownLoadURL = "http://www.kcsoftwares.com/files/sumo.exe"
    #$DownLoadURL = "http://www.kcsoftwares.com/files/sumo_lite.exe"
    #$DownLoadURL = "http://www.kcsoftwares.com/files/sumo.7z"
    Write-Host "-===========-" -ForegroundColor Green
    Write-Host "Product:  $Software"
	
    if (Test-Path "$DistribPath\$FileName")
    {
        if (!(Test-Path "$DistribPath\temp\$FileName"))
        {
            New-Item -Path $DistribPath\temp -ItemType "directory" -ErrorAction Silentlycontinue |out-null
            write-host
        }
		$destination = "$DistribPath\temp\$FileName"
        write-host "Скачиваем файл с сервера"
        $wc = New-Object System.Net.WebClient
        $wc.DownloadFile($DownLoadURL, $destination)
		$hash1 = Get-FileHash $DistribPath\$FileName -Algorithm MD5 |select -exp hash
		$hash2 = Get-FileHash $DistribPath\temp\$FileName -Algorithm MD5 |select -exp hash
		if ($hash1 -eq $hash2)
		{
			write-host "Подтверждаю, что файл на сервере не обновился"
			del $DistribPath\temp -recurse
		}
		else
		{
			Write-warning "Файл на сервере обновился"
            try
            {
				Move-Item $DistribPath\temp\$FileName -Destination $DistribPath -Force
                Start-Process "$env:ProgramFiles\7-Zip\7z.exe" -ArgumentList "x -r $DistribPath\temp\$FileName -od:\WPI\sumo" -wait
				del $DistribPath\temp
            }
            catch
            {
                Write-Host "Ошибка распаковки или удаления"
            }
            Write-Host "Распаковали zip архив"
			pause
		}
    }
    
    Write-Host "-===========-" -ForegroundColor Green