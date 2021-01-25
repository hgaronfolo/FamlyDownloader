clear

Write-Host -ForegroundColor Green " ______              _       "
Write-Host -ForegroundColor Green "|  ____|            | |      "
Write-Host -ForegroundColor Green "| |__ __ _ _ __ ___ | |_   _ "
Write-Host -ForegroundColor Green "|  __/ _` | '_ ` _ \| | | | |"
Write-Host -ForegroundColor Green "| | | (_| | | | | | | | |_| |"
Write-Host -ForegroundColor Green "|_|  \__,_|_| |_| |_|_|\__, |"
Write-Host -ForegroundColor Green "       Downloader       __/ |"
Write-Host -ForegroundColor Green "  af Novas og Vidas far|___/ "

$username = Read-Host -Prompt "Indtast Famly brugernavn/email og tryk Enter"
$password = Read-Host -Prompt "Indtast Famly password og tryk Enter"

Write-Host "Logger ind... "
$Server = 'app.famly.co'
$Url = "https://${server}/api/login/login/authenticate"
$Body = @{        
    email = "${username}"
    password = "${password}"
    deviceid = "null"
    locale = "en-US"
}
$accessToken = Invoke-RestMethod -Method Post -uri $Url -Body $Body | select -ExpandProperty accessToken



Write-Host "Finder børn... "
$Url = "https://${server}/api/me/me/me?accessToken=${accessToken}"

$kids = Invoke-RestMethod -Method Get -Uri $Url | select -ExpandProperty roles2 |select -ExpandProperty targetId


$headers = @{
        'x-famly-accesstoken' = $accessToken
    }


ForEach ($line in $($kids -split "`r`n"))
{
    Write-Host "Finder billed oversigt for ${line}... " 
    $url = "https://${server}/api/v2/images/tagged?childId=${Line}"
    $images = Invoke-RestMethod -Method Get -Uri $Url -Headers $headers

    Write-Host "Opretter mappe ${line}..."
    $out = Get-Location
    New-Item -Path $out -Name ${line} -ItemType "directory"

    Write-Host "Downloader billeder"
    for( $i = 0; $i -lt $images.Count ; $i++)
    {        
        $location = $images.GetValue($i) | select -ExpandProperty url_big
        Write-Host -NoNewline "Downloader "
        Write-Host -ForegroundColor Green $location
        wget -Uri $location -OutFile ${out}\${line}\${i}.jpg
    }
    Write-Host "Download udført"
}
