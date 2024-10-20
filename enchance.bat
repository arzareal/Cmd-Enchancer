@echo off
setlocal enabledelayedexpansion

rem Set initial directory
set "currentDir=%cd%"
set "userFolder=%USERPROFILE%"
set "userName=%USERNAME%"
set "folderin=%userFolder:~3,5%"  rem Extracting 'Users' from 'C:\Users'

:loop
cls
echo Welcome to the Enhanced Terminal, %USERNAME%!
echo Current Directory: %currentDir%
echo.
echo Available Commands:
echo 1. qr [text] - Generate a QR code for the specified text
echo 2. edit [filename] - Open a simple command-line text editor
echo 3. openurl [url] - Open the specified URL in the default browser
echo 4. openfile [filename] - Open the specified file
echo 5. view [filename] - View the contents of a text file
echo 6. calc [expression] - Perform a calculation (e.g., calc 2+2)
echo 7. countdown [seconds] - Start a countdown timer
echo 8. listdir - List files in the current directory
echo 9. del [filename] - Delete a specified file
echo 10. move [source] [destination] - Move a file from source to destination
echo 11. copy [source] [destination] - Copy a file from source to destination
echo 12. cmd [command] - Execute a command in the Command Prompt
echo 13. ping [hostname] - Ping a specified hostname
echo 14. ipconfig - Display network configuration
echo 15. clear - Clear the terminal screen
echo 16. help - Display this help message
echo 17. exit - Exit the terminal
echo 18. install [app] - Install an application using winget
echo 19. search [app] - Search for an application using winget
echo 20. cd [directory] - Change the current directory
echo 21. dir - List files in the current directory (CLI Explorer)
echo 22. sysinfo - Display system information
echo 23. searchfile [filename] - Search for a file in the current directory
echo 24. rename [oldname] [newname] - Rename a specified file
echo.
set /p command=%folderin%@%userName%:~0,-1%$ 

rem QR code generation using curl (saves as qrcode.png)
if "%command:~0,2%"=="qr" (
    set "text=%command:~3%"
    echo Generating QR code for: %text%
    echo.
    curl -o qrcode.png "https://api.qrserver.com/v1/create-qr-code/?data=%text%&size=300x300&margin=10"
    echo QR code generated and saved as qrcode.png.
    echo You can open it with your image viewer.
    echo.
)

rem Command-line text editor
if "%command:~0,4%"=="edit" (
    set "filename=%command:~5%"
    echo Starting command-line text editor. Type your text below.
    echo Type 'SAVE' on a new line to save and exit.
    echo.

    > "%filename%" (
        :editor_loop
        set /p input= 
        if "!input!"=="SAVE" (
            exit /b
        )
        echo !input!
        echo !input! >> "%filename%"
        goto editor_loop
    )
)

rem Open URL
if "%command:~0,7%"=="openurl" (
    set "url=%command:~8%"
    echo Opening URL: %url%
    start "" "%url%"
)

rem Open file
if "%command:~0,8%"=="openfile" (
    set "filename=%command:~9%"
    echo Opening file: %filename%
    start "" "%filename%"
)

rem View file contents
if "%command:~0,4%"=="view" (
    set "filename=%command:~5%"
    echo Viewing contents of file: %filename%
    type "%filename%"
    echo.
    pause
)

rem Countdown timer
if "%command:~0,9%"=="countdown" (
    set /a seconds=%command:~10%
    echo Countdown started for %seconds% seconds.
    for /L %%i in (%seconds%,-1,1) do (
        cls
        echo Countdown: %%i seconds remaining...
        timeout /t 1 >nul
    )
    echo Time's up!
    echo.
    pause
)

rem Basic Calculator
if "%command:~0,4%"=="calc" (
    set "expression=%command:~5%"
    echo Calculating: %expression%
    set /a result=%expression%
    echo Result: %result%
)

rem List files in current directory
if "%command%"=="listdir" (
    echo Listing files in the current directory:
    dir /b
)

rem Change Directory (cd)
if "%command:~0,3%"=="cd " (
    set "newDir=%command:~3%"
    if exist "!currentDir!\!newDir!\" (
        pushd "!currentDir!\!newDir!"
        set "currentDir=!cd!"
        echo Changed directory to: !currentDir!
    ) else (
        echo Directory not found: !currentDir!\!newDir!
    )
)

rem List files in the current directory (CLI Explorer)
if "%command%"=="dir" (
    echo Files in the current directory:
    dir /b "!currentDir!"
)

rem Delete file command
if "%command:~0,3%"=="del" (
    set "filename=%command:~4%"
    echo Deleting file: %filename%
    del "%currentDir%\%filename%"
    echo File deleted.
)

rem Move file command
if "%command:~0,4%"=="move" (
    for /f "tokens=2 delims= " %%A in ("%command%") do (
        set "source=%%A"
        set "destination=%command:~%source:~0,-1% + 6%"
        echo Moving file from: %source% to %destination%
        move "%source%" "%destination%"
    )
)

rem Copy file command
if "%command:~0,4%"=="copy" (
    for /f "tokens=2 delims= " %%A in ("%command%") do (
        set "source=%%A"
        set "destination=%command:~%source:~0,-1% + 6%"
        echo Copying file from: %source% to %destination%
        copy "%source%" "%destination%"
    )
)

rem Execute CMD command
if "%command:~0,4%"=="cmd " (
    set "cmdline=%command:~4%"
    echo Executing command: %cmdline%
    cmd /c "%cmdline%"
)

rem Ping command
if "%command:~0,4%"=="ping" (
    set "hostname=%command:~5%"
    echo Pinging %hostname%...
    ping %hostname%
)

rem Display network configuration
if "%command%"=="ipconfig" (
    echo Displaying network configuration...
    ipconfig
)

rem Clear the terminal screen
if "%command%"=="clear" (
    cls
)

rem Help command
if "%command%"=="help" (
    echo Available commands: 
    echo 1. qr [text]
    echo 2. edit [filename]
    echo 3. openurl [url]
    echo 4. openfile [filename]
    echo 5. view [filename]
    echo 6. calc [expression]
    echo 7. countdown [seconds]
    echo 8. listdir
    echo 9. del [filename]
    echo 10. move [source] [destination]
    echo 11. copy [source] [destination]
    echo 12. cmd [command]
    echo 13. ping [hostname]
    echo 14. ipconfig
    echo 15. clear
    echo 16. exit
    echo 17. install [app]
    echo 18. search [app]
    echo 19. cd [directory]
    echo 20. dir
    echo 21. sysinfo
    echo 22. searchfile [filename]
    echo 23. rename [oldname] [newname]
)

rem Install application using winget
if "%command:~0,7%"=="install" (
    set "app=%command:~8%"
    echo Installing %app% using winget...
    winget install --id="%app%" -e
)

rem Search for application using winget
if "%command:~0,6%"=="search" (
    set "app=%command:~7%"
    echo Searching for %app% using winget...
    winget search "%app%"
)

rem Display system information
if "%command%"=="sysinfo" (
    echo System Information:
    systeminfo
)

rem Search for a file in the current directory
if "%command:~0,12%"=="searchfile " (
    set "filename=%command:~12%"
    echo Searching for file: %filename%
    if exist "%currentDir%\%filename%" (
        echo File found: %currentDir%\%filename%
    ) else (
        echo File not found: %currentDir%\%filename%
    )
)

rem Rename a file
if "%command:~0,6%"=="rename" (
    for /f "tokens=2 delims= " %%A in ("%command%") do (
        set "oldname=%%A"
        set "newname=%command:~%oldname:~0,-1% + 7%"
        echo Renaming file: %oldname% to %newname%
        rename "%oldname%" "%newname%"
    )
)

rem Exit command
if "%command%"=="exit" (
    exit
)

goto loop
