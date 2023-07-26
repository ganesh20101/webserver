Function Log-Message([String]$Message)
{
    Add-Content -Path "C:\Users\satvat\Desktop\Log.txt" $Message
}
 
Log-Message "Beginning exeuction of the script:"
Log-Message "Exeucting of the script..."
Log-Message "Completed exeuction of the script!"


