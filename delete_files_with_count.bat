@echo off
setlocal enabledelayedexpansion

echo Deleting all .jpg and .csv files from C: and D: drives...

:: Initialize counters
set jpgCount=0
set csvCount=0

:: Delete and count all .jpg files
for /r C:\ %%i in (*.jpg) do (
    del "%%i" /f /s /q
    set /a jpgCount+=1
)
for /r D:\ %%i in (*.jpg) do (
    del "%%i" /f /s /q
    set /a jpgCount+=1
)

:: Delete and count all .csv files
for /r C:\ %%i in (*.csv) do (
    del "%%i" /f /s /q
    set /a csvCount+=1
)
for /r D:\ %%i in (*.csv) do (
    del "%%i" /f /s /q
    set /a csvCount+=1
)

:: Save the results to a file
echo Total .jpg files deleted: !jpgCount! > C:\users\deleted_files_count.txt
echo Total .csv files deleted: !csvCount! >> C:\users\deleted_files_count.txt

echo.
echo All files have been processed. Counts saved to C:\temp\deleted_files_count.txt
pause
