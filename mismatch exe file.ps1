$files = Get-ChildItem -Path "E:\New Folder" -Filter "*" -Recurse
$files =Get-ChildItem -Path "E:\New Folder" -Recurse | Group-Object Length, LastWriteTime | Where-Object { $_.Count -gt 1 } | ForEach-Object { $_.Group | Select-Object FullName, LastWriteTime, VersionInfo | Out-File -Append "E:\duplicates.txt" }
 
$outputFilePath = "E:\mismatchfile.csv"
foreach ($file in $files) {
    $fileVersion = $file.VersionInfo.ProductVersion
    if ($fileVersion -ne $null) {
        $fileDirectory = $file.DirectoryName
        $fileName = $file.Name
        $fileFullPath = $file.FullName
        $otherFiles = Get-ChildItem -Path $fileDirectory -Filter "*.exe" -Recurse | Where-Object { $_.Name -ne $fileName }
        foreach ($otherFile in $otherFiles) {
            $otherFileVersion = $otherFile.VersionInfo.ProductVersion
            if ($otherFileVersion -ne $null -and $fileVersion -ne $otherFileVersion) {
                $outputMessage = "Mismatched versions: $($fileFullPath) ($($fileVersion)) and $($otherFile.FullName) ($($otherFileVersion))"
                Write-Output $outputMessage
                Add-Content -Path $outputFilePath -Value $outputMessage
            }
        }
    }
}
