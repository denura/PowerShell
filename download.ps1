Clear-host
# Присваивание переменных
$Software = "Firefox ESR"
$DistribPath = '.\'
$FileName = 'Firefox Setup esr.exe'
#$URLPage = 'https://www.mozilla.org/ru/firefox/organizations/all/#ru'

# Получаем ссылку на скачивание. Она всегда одинакова.
$DownLoadURL = "https://download.mozilla.org/?product=firefox-esr-latest&os=win64&lang=ru"
Write-Host "-===========-" -ForegroundColor Green
Write-Host "Product:  $Software"
	
# Создаём папку куда будем скачивать дистибутив
if (Test-Path "$DistribPath\$FileName")
{
    $ver1 = ((dir $DistribPath -Filter $FileName -ErrorAction Silentlycontinue).versioninfo).fileversion
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