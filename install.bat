@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem Use the local repository when this batch file is inside a clone.
set "SCRIPT_DIR=%~dp0"
if exist "%SCRIPT_DIR%.git\" (
    set "DOTPATH=%SCRIPT_DIR%"
) else (
    set "DOTPATH=%USERPROFILE%\dotfiles"
    if not exist "%DOTPATH%\.git\" (
        git clone --recursive "https://github.com/ckl15071/dotfiles.git" "%DOTPATH%"
        if errorlevel 1 exit /b 1
    )
)

cd /d "%DOTPATH%"
if errorlevel 1 exit /b 1

set "HH=%TIME:~0,2%"
if "!HH:~0,1!"==" " set "HH=0!HH:~1!"
set "TIMESTAMP=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%_!HH!%TIME:~3,2%%TIME:~6,2%"
set "BACKUP_DIR=%USERPROFILE%\dotfiles_backup\!TIMESTAMP!"
set "BACKUP_CREATED=0"
set "FOUND=0"

rem Match Bash's .??* glob: hidden entries with at least two characters after the dot.
for /f "delims=" %%F in ('dir /b /a "%DOTPATH%" 2^>nul') do (
    set "NAME=%%F"
    if "!NAME:~0,1!"=="." if not "!NAME:~2,1!"=="" if /I not "%%F"==".git" if exist "%DOTPATH%\%%F" (
        set "FOUND=1"
        set "TARGET=%USERPROFILE%\%%F"
        set "IS_LINK=0"

        rem Existing symbolic links/junctions are kept, as with Bash's -L check.
        for /f "delims=" %%L in ('dir /al /b "%USERPROFILE%" 2^>nul') do (
            if /I "%%L"=="%%F" set "IS_LINK=1"
        )

        if !IS_LINK! equ 0 if exist "!TARGET!" (
            if !BACKUP_CREATED! equ 0 (
                mkdir "%BACKUP_DIR%" >nul 2>nul
                set "BACKUP_CREATED=1"
            )
            move "!TARGET!" "%BACKUP_DIR%\%%F" >nul
            echo Moved !TARGET! to "%BACKUP_DIR%\%%F"
        )

        if !IS_LINK! equ 1 (
            rmdir /s /q "!TARGET!" >nul 2>nul
            del /f /q "!TARGET!" >nul 2>nul
        )

        echo Linking !TARGET!
        if exist "%DOTPATH%\%%F\" (
            mklink /D "!TARGET!" "%DOTPATH%\%%F"
        ) else (
            mklink "!TARGET!" "%DOTPATH%\%%F"
        )
        if errorlevel 1 echo Failed to link !TARGET!
    )
)

if !FOUND! equ 0 echo No dotfiles found in "%DOTPATH%".

endlocal