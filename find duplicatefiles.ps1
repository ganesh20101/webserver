﻿Get-ChildItem -Path "E:\New Folder" -Recurse | Group-Object Length, LastWriteTime | Where-Object { $_.Count -gt 1 } | ForEach-Object { $_.Group | Select-Object FullName, LastWriteTime, VersionInfo | Out-File -Append "E:\duplicates.txt" }
