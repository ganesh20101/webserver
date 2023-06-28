# Import the module
Import-Module -Name ImportExcel

# Create sample data
$data = @(
    [PSCustomObject]@{
        Name = "John"
        Age = 25
    }
    [PSCustomObject]@{
        Name = "Alice"
        Age = 30
    }
    [PSCustomObject]@{
        Name = "Bob"
        Age = 35
    }
)

# Specify the path for the Excel file
$excelFilePath = "$env:USERPROFILE\Desktop\output.xlsx"

# Export data to Excel
$data | Export-Excel -Path $excelFilePath -AutoSize -AutoFilter

Write-Host "Excel file created successfully at: $excelFilePath"
