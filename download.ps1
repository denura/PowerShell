Clear-host
# ������������ ����������
$Software = "Firefox ESR"
$DistribPath = '.\'
$FileName = 'Firefox Setup esr.exe'
#$URLPage = 'https://www.mozilla.org/ru/firefox/organizations/all/#ru'

# �������� ������ �� ����������. ��� ������ ���������.
$DownLoadURL = "https://download.mozilla.org/?product=firefox-esr-latest&os=win64&lang=ru"
Write-Host "-===========-" -ForegroundColor Green
Write-Host "Product:  $Software"
	
# ������ ����� ���� ����� ��������� ����������
if (Test-Path "$DistribPath\$FileName")
{
    $ver1 = ((dir $DistribPath -Filter $FileName -ErrorAction Silentlycontinue).versioninfo).fileversion
    if (!(Test-Path "$DistribPath\temp\$FileName"))
    {
        New-Item -Path $DistribPath\temp -ItemType "directory" -ErrorAction Silentlycontinue |out-null
        write-host
    }
	# ��������� ���� ����� ��������� ����������� ����
	$destination = "$DistribPath\temp\$FileName"
    # ���������� �����
    write-host "��������� ���� � �������"
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($DownLoadURL, $destination)
	$hash1 = Get-FileHash $DistribPath\$FileName -Algorithm MD5 |select -exp hash
	$hash2 = Get-FileHash $DistribPath\temp\$FileName -Algorithm MD5 |select -exp hash
	if ($hash1 -eq $hash2)
	{
		write-host "�����������, ��� ���� �� ������� �� ���������"
		del $DistribPath\temp -Recurse
	}
	else
	{
		Write-warning "���� �� ������� ���������"
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