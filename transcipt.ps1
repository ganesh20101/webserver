Start-Transcript -Append C:\Users\satvat\Desktop\PSScriptLog.txt

Get-Process| where-object {$_.WorkingSet -GT 500000*1024}|select processname,@{l="Used RAM(MB)"; e={$_.workingset / 1mb}} |sort "Used RAM(MB)" –Descending



Stop-Transcript



