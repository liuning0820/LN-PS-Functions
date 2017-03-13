#initialization
      $timeInterval = 30  #监测间隔
      $record = @{"Coding" = 0; "Outlook Email" = 0; "Gmail" = 0; "Google Reader" = 0; "BBS" = 0; "Other Internet" = 0; "Documents" = 0;}
     $count = 0
     $date = date -format "yyyyMMdd"
     #try to resume
     if (test-path "d:\temp\timeRecord$date.txt") {
         Get-Content "d:\temp\timeRecord$date.txt" | % {if ($_ -match "\w+\s+\d+") {
             $groups = [Regex]::Match($_, "^(\w+\s?\w+)\s+(\d+)").Groups;
             $record[$groups[1].Value] = [int]::Parse($groups[2].Value);
         }}
     }
     #start to monitor
     while ($true)
     {
         $titles = Get-Process | ? {$_.MainWindowTitle} | select MainWindowTitle
         $titles | % {
             if ($_ -match "Google 阅读器 - Windows Internet Explorer") {$record["Google Reader"]++;}
             else {if ($_ -match "Gmail - Windows Internet Explorer") {$record["Gmail"]++;}
             else {if ($_ -match "Internet Explorer") {$record["Other Internet"]++;}
             else {if ($_ -match "Visual Studio") {$record["Coding"]++;}
             else {if ($_ -match "Microsoft Word") {$record["Documents"]++;}
             else {if ($_ -match "Microsoft Office OneNote") {$record["Documents"]++;}
             else {if ($_ -match "Microsoft PowerPoint") {$record["Documents"]++;}
             else {if ($_ -match "Message (HTML)") {$record["Outlook Email"]++;}
             else {if ($_ -match "bbs") {$record["BBS"]++;}
             }}}}}}}}
         }
         sleep($timeInterval)
         $count = ($count + 1) % 10 #为了防止数据丢失，每10次记录写入文件一次
         if ($count -eq 0) {$record > "C:\Logs\timeRecord$date.txt"}
     }