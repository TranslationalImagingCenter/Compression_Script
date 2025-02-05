@echo off
@echo off
SETLOCAL EnableExtensions EnableDelayedExpansion

REM Path to 7-Zip ZS executable
SET "7ZIP_PATH=C:\Program Files\7-Zip-Zstandard\7z.exe"

REM Get the current directory
SET "SOURCE_DIR=%CD%"

REM Check if running from a mapped drive (e.g., Y:\)
ECHO %SOURCE_DIR% | FINDSTR /R "^[A-Z]:\\" >NUL
IF %ERRORLEVEL%==0 (
    REM Use PowerShell to resolve the UNC path
    FOR /F "usebackq tokens=*" %%I IN (`powershell -Command "& {(Get-PSDrive | Where-Object { $_.Name -eq '%SOURCE_DIR:~0,1%' }).Root}"`) DO SET "UNC_PATH=%%I"

    REM If PowerShell returned a UNC path, use it instead
    IF NOT "!UNC_PATH!"=="" SET "SOURCE_DIR=!UNC_PATH!!SOURCE_DIR:~2!"
)

ECHO Using source directory: "%SOURCE_DIR%"

REM Verify the corrected directory exists
IF NOT EXIST "%SOURCE_DIR%" (
    ECHO ERROR: The specified directory does not exist: "%SOURCE_DIR%"
    EXIT /B 1
)

REM Compression method and level
SET "COMPRESSION_METHOD=zstd"
SET "COMPRESSION_LEVEL=19"

REM Name of the script to exclude
SET "SCRIPT_NAME=compress_7zip-std.bat"

REM Get today's date in YYYYMMDD format
FOR /F "tokens=2-4 delims=/ " %%A IN ('date /t') DO (
    SET "TODAY=%%C%%A%%B"
)

REM Initialize log file
SET "LOG_FILE=%SOURCE_DIR%\compression_log_%TODAY%.txt"
ECHO "Compression Log - %DATE% %TIME%" > "!LOG_FILE!"
ECHO ============================================ >> "!LOG_FILE!"

REM Compressed file extensions to skip
SET "SKIP_EXTENSIONS=.zst .7z .zip .rar .gz .tgz .bz2 .xz .tar .lz4 .cab .arj .iso .dmg .pkg .deb .rpm"

REM Description of the script
CLS
echo ============================================
echo "7-Zip Zstandard Compression Script"
echo ============================================
echo.
echo Description:
echo This script was designed to use 7-Zip with the Zstandard (zstd) compression
echo extension. The script will:
echo - Compress each individual file in the folder it is run from and its subfolders.
echo - Skip files that are already compressed (e.g., .zst, .7z, .zip, etc.).
echo - Check for cases where both compressed and uncompressed files exist and:
echo   - Validate the compressed file's integrity using a checksum test.
echo   - Delete the uncompressed file if the compressed file is valid.
echo - Compress eligible files using Zstandard compression at maximum level.
echo - Validate compression using a checksum test to ensure data integrity.
echo - Delete the original file only if compression is successful.
echo - Create a detailed log file "compression_log_%TODAY%.txt" that includes:
echo   - Files that were compressed successfully.
echo   - Files that were already compressed and skipped.
echo   - Any errors encountered during compression or validation.
echo.
echo The Zstandard compression is implemented using the 7-Zip Zstandard fork:
echo https://github.com/mcmilk/7-Zip-zstd
echo.
echo This script was created for use at the Translational Imaging Center at the
echo University of Southern California (USC).
echo.
echo Legal Disclaimer:
echo This script is provided "as is," without any express or implied warranties,
echo including but not limited to the implied warranties of merchantability,
echo fitness for a particular purpose, or non-infringement. The developers and
echo distributors of this script make no guarantees as to the functionality,
echo accuracy, or reliability of the script, and expressly disclaim any liability
echo for errors, omissions, or damages resulting from the use of this script.
echo By using this script, you accept these terms and acknowledge that any use
echo is at your own risk.
echo.
echo ============================================
echo.
echo Would you like to continue? (Y/N)
set /p "USER_INPUT=Your choice: "
IF /I NOT "!USER_INPUT!"=="Y" (
    echo Script terminated by the user.
    exit /b
)
echo.
echo You have chosen to proceed.
echo This script will process all files in the folder where it is being run from, including all subfolders, by first compressing each uncompressed file individually, then verifying the integrity of the compressed version, and finally deleting the original uncompressed file only if the compression and verification steps are successful.
echo.
echo Are you sure you want to continue? This action cannot be undone. (Y/N)
set /p "FINAL_CONFIRMATION=Your choice: "
IF /I NOT "!FINAL_CONFIRMATION!"=="Y" (
    echo Script terminated by the user.
    exit /b
)

REM Recursively loop through all files in the current directory
for /R "%SOURCE_DIR%" %%F in (*) do (
    REM Get the file extension
    SET "FILE_EXT=%%~xF"

    REM Skip the script file, log file, and compressed formats
    SET "SKIP=0"
    IF /I "%%~nxF"=="!SCRIPT_NAME!" SET "SKIP=1"
    IF /I "%%~fF"=="!LOG_FILE!" SET "SKIP=1"
    FOR %%E IN (!SKIP_EXTENSIONS!) DO (
        IF /I "!FILE_EXT!"=="%%E" SET "SKIP=1"
    )

    IF "!SKIP!"=="0" (
        SET "FILE_NAME=%%~nF"
        SET "FILE_DIR=%%~dpF"
        SET "ZSTD_FILE=%%~dpnF.zst"

        REM If a compressed file exists, verify and handle duplicates
        IF EXIST "!ZSTD_FILE!" (
            "!7ZIP_PATH!" t "!ZSTD_FILE!" >nul
            IF ERRORLEVEL 1 (
                echo ERROR: "!ZSTD_FILE!" is corrupted. Skipping deletion of "%%F".
                ECHO ERROR: "!ZSTD_FILE!" is corrupted. Skipping deletion of "%%F". >> "!LOG_FILE!"
            ) ELSE (
                echo OK: Verified "!ZSTD_FILE!". Deleting original: "%%F".
                DEL "%%F"
                ECHO OK: Verified "!ZSTD_FILE!". Deleted original: "%%F". >> "!LOG_FILE!"
            )
        ) ELSE (
            REM Compress the file if no compressed version exists
            "!7ZIP_PATH!" a -t!COMPRESSION_METHOD! -mx!COMPRESSION_LEVEL! "!ZSTD_FILE!" "%%F"
            IF ERRORLEVEL 1 (
                echo ERROR: Failed to compress "%%F". Skipping deletion.
                ECHO ERROR: Failed to compress "%%F". >> "!LOG_FILE!"
            ) ELSE (
                REM Verify the new compressed file using 7-Zip's test command
                "!7ZIP_PATH!" t "!ZSTD_FILE!" >nul
                IF ERRORLEVEL 1 (
                    echo ERROR: Verification failed for "!ZSTD_FILE!". Skipping deletion of "%%F".
                    ECHO ERROR: Verification failed for "!ZSTD_FILE!". Skipping deletion of "%%F". >> "!LOG_FILE!"
                ) ELSE (
                    echo OK: Compressed and verified "%%F" to "!ZSTD_FILE!".
                    DEL "%%F"
                    ECHO OK: Compressed and verified "%%F" to "!ZSTD_FILE!". Deleted original. >> "!LOG_FILE!"
                )
            )
        )
    )
)

REM Summary of actions
echo ============================================
echo Compression completed. See log file for details:
echo "!LOG_FILE!"
echo ============================================
pause
