
    $baseuri= "https://d9w0602g.houston.hp.com/IncidentsService/api/IncidentsService"
    $username = "Shannon O'Reilly"
    $password = "aGe}q}LIDLdOR[OdUKU{"
    $body = Get-Content ".\Invoke-WebRequest-SA.txt"

    Invoke-WebRequest -Uri $baseuri -Headers @{"Authorization" = "Basic "+"U2hhbm5vbiBPJ1JlaWxseTphR2V9cX1MSURMZE9SW09kVUtVew=="} -Method get
    #Invoke-WebRequest -Uri $baseuri -Headers @{"Authorization" = "Basic "+"U2hhbm5vbiBPJ1JlaWxseTphR2V9cX1MSURMZE9SW09kVUtVew=="} -Method Post -Body ""
    Invoke-WebRequest -Uri $baseuri -Headers @{"Authorization" = "Basic "+[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($username+":"+$password ))} -Method Post -Body $body
    
