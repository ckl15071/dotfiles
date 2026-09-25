@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem Use the local repository when this batch file is inside a clone.
set "SCRIPT_DIR=%~dp0"
if exist "%SCRIPT_DIR%Code\User\" (
    set "SRC_DIR=%SCRIPT_DIR%Code\User"
) else (
    set "DOTPATH=%USERPROFILE%\dotfiles"
    if not exist "%DOTPATH%\.git\" (
        git clone --recursive "https://github.com/ckl15071/dotfiles.git" "%DOTPATH%"
        if errorlevel 1 exit /b 1
    )
    set "SRC_DIR=%DOTPATH%\Code\User"
)

set "TARGET_DIR=%APPDATA%\Code\User"
if not exist "%SRC_DIR%\" (
    echo Error: "%SRC_DIR%" not found.
    exit /b 1
)

set "HH=%TIME:~0,2%"
if "!HH:~0,1!"==" " set "HH=0!HH:~1!"
set "TIMESTAMP=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%_!HH!%TIME:~3,2%%TIME:~6,2%"
set "BACKUP_DIR=%TARGET_DIR%\backup\!TIMESTAMP!"
set "BACKUP_CREATED=0"

echo Source: "%SRC_DIR%"
echo Target: "%TARGET_DIR%"

rem Copy every file except files below the source old directory.
for /r "%SRC_DIR%" %%F in (*) do (
    echo %%F | findstr /i /c:"\old\" >nul
    if errorlevel 1 (
        set "REL_PATH=%%F"
        set "REL_PATH=!REL_PATH:%SRC_DIR%=!"
        set "DEST_FILE=%TARGET_DIR%!REL_PATH!"

        rem Back up existing real files, but leave existing links in place.
        if exist "!DEST_FILE!" (
            dir /al /b "!DEST_FILE!" >nul 2>nul
            if errorlevel 1 (
                if !BACKUP_CREATED! equ 0 (
                    mkdir "%BACKUP_DIR%" >nul 2>nul
                    set "BACKUP_CREATED=1"
                )
                set "BACKUP_FILE=%BACKUP_DIR%!REL_PATH!"
                for %%D in ("!BACKUP_FILE!") do if not exist "%%~dpD" mkdir "%%~dpD" >nul 2>nul
                move /y "!DEST_FILE!" "!BACKUP_FILE!" >nul
                echo Backed up: !DEST_FILE!
            )
        )

        for %%D in ("!DEST_FILE!") do if not exist "%%~dpD" mkdir "%%~dpD" >nul 2>nul
        copy /y "%%F" "!DEST_FILE!" >nul
        if errorlevel 1 echo Failed to copy: !DEST_FILE!
    )
)

echo Done. Restart VSCode to apply the settings.
endlocal