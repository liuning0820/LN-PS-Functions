# #CHECK THE PATH ON LINE 2 and the FEED on LINE 3
# cd "$env:USERPROFILE\Downloads"
# $a = ([xml](new-object net.webclient).downloadstring("https://channel9.msdn.com/Series/CSharp-101/feed/mp4"))
# $a.rss.channel.item | foreach{  
#     $url = New-Object System.Uri($_.enclosure.url)
#     $file = $url.Segments[-1]
#     $file
#     if (!(test-path $file)) {
#         (New-Object System.Net.WebClient).DownloadFile($url, $file)
#     }
# }


Param (
   $DownloadFolder = "$env:USERPROFILE\Downloads\",
   $DownloadURL = 'https://channel9.msdn.com/Series/CSharp-101/feed/mp4'
)

#CHECK THE PATH ON LINE 2 and the FEED on LINE 3
Push-Location $DownloadFolder
$a = ([xml](New-Object net.webclient).downloadstring($DownloadURL))
$a.rss.channel.item | ForEach-Object {  
    $url = New-Object System.Uri($_.enclosure.url)
    $file = $url.Segments[-1]
    $file
    if (!(Test-Path $file)) {
        (New-Object System.Net.WebClient).DownloadFile($url, $file)
    }
}

Pop-Location
