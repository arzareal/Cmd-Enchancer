#!/bin/bash

while true; do
    # Get the current directory and username
    currentDir=$(pwd)
    folderin=$(basename "$currentDir")
    userName=$(whoami)

    # Display prompt with folderin and username
    echo "Welcome to the Enhanced Terminal, $userName!"
    echo "Current Directory: $currentDir"
    echo
    echo "Available Commands:"
    echo "1. qr [text] - Generate a QR code for the specified text"
    echo "2. edit [filename] - Open a simple command-line text editor"
    echo "3. openurl [url] - Open the specified URL in the default browser"
    echo "4. openfile [filename] - Open the specified file"
    echo "5. view [filename] - View the contents of a text file"
    echo "6. calc [expression] - Perform a calculation (e.g., calc 2+2)"
    echo "7. countdown [seconds] - Start a countdown timer"
    echo "8. listdir - List files in the current directory"
    echo "9. del [filename] - Delete a specified file"
    echo "10. move [source] [destination] - Move a file from source to destination"
    echo "11. copy [source] [destination] - Copy a file from source to destination"
    echo "12. cmd [command] - Execute a command in the Terminal"
    echo "13. ping [hostname] - Ping a specified hostname"
    echo "14. ipconfig - Display network configuration"
    echo "15. clear - Clear the terminal screen"
    echo "16. help - Display this help message"
    echo "17. exit - Exit the terminal"
    echo "18. install [app] - Install an application (macOS uses brew, Linux uses apt)"
    echo "19. search [app] - Search for an application (macOS: brew, Linux: apt)"
    echo "20. cd [directory] - Change the current directory"
    echo "21. dir - List files in the current directory"
    echo "22. sysinfo - Display system information"
    echo "23. searchfile [filename] - Search for a file in the current directory"
    echo "24. rename [oldname] [newname] - Rename a specified file"
    echo

    # Read the user input
    read -p "$folderin@$userName$ " command

    # Handle QR code generation using curl (displays in terminal)
    if [[ "$command" == qr* ]]; then
        text=$(echo "$command" | cut -d' ' -f2-)
        echo "Generating QR code for: $text"
        curl "https://api.qrserver.com/v1/create-qr-code/?data=$text&size=300x300&margin=10"
        echo
    fi

    # Command-line text editor (nano or vi)
    if [[ "$command" == edit* ]]; then
        filename=$(echo "$command" | cut -d' ' -f2)
        nano "$filename"
    fi

    # Open URL in the default browser
    if [[ "$command" == openurl* ]]; then
        url=$(echo "$command" | cut -d' ' -f2)
        echo "Opening URL: $url"
        open "$url" 2>/dev/null || xdg-open "$url"
    fi

    # Open file using default application
    if [[ "$command" == openfile* ]]; then
        filename=$(echo "$command" | cut -d' ' -f2)
        echo "Opening file: $filename"
        open "$filename" 2>/dev/null || xdg-open "$filename"
    fi

    # View file contents using cat
    if [[ "$command" == view* ]]; then
        filename=$(echo "$command" | cut -d' ' -f2)
        echo "Viewing contents of file: $filename"
        cat "$filename"
        echo
    fi

    # Countdown timer
    if [[ "$command" == countdown* ]]; then
        seconds=$(echo "$command" | cut -d' ' -f2)
        echo "Countdown started for $seconds seconds."
        for ((i = seconds; i >= 1; i--)); do
            echo "Countdown: $i seconds remaining..."
            sleep 1
        done
        echo "Time's up!"
    fi

    # Calculator using `bc`
    if [[ "$command" == calc* ]]; then
        expression=$(echo "$command" | cut -d' ' -f2-)
        result=$(echo "$expression" | bc)
        echo "Result: $result"
    fi

    # List files in the current directory
    if [[ "$command" == "listdir" ]]; then
        echo "Listing files in the current directory:"
        ls -1
    fi

    # Delete a file
    if [[ "$command" == del* ]]; then
        filename=$(echo "$command" | cut -d' ' -f2)
        echo "Deleting file: $filename"
        rm "$filename"
    fi

    # Move a file
    if [[ "$command" == move* ]]; then
        source=$(echo "$command" | cut -d' ' -f2)
        destination=$(echo "$command" | cut -d' ' -f3)
        echo "Moving file from $source to $destination"
        mv "$source" "$destination"
    fi

    # Copy a file
    if [[ "$command" == copy* ]]; then
        source=$(echo "$command" | cut -d' ' -f2)
        destination=$(echo "$command" | cut -d' ' -f3)
        echo "Copying file from $source to $destination"
        cp "$source" "$destination"
    fi

    # Execute a command in the terminal
    if [[ "$command" == cmd* ]]; then
        cmdline=$(echo "$command" | cut -d' ' -f2-)
        echo "Executing command: $cmdline"
        eval "$cmdline"
    fi

    # Ping a hostname
    if [[ "$command" == ping* ]]; then
        hostname=$(echo "$command" | cut -d' ' -f2)
        echo "Pinging $hostname..."
        ping -c 4 "$hostname"
    fi

    # Display network configuration (uses `ifconfig` or `ip`)
    if [[ "$command" == "ipconfig" ]]; then
        ifconfig 2>/dev/null || ip a
    fi

    # Clear the terminal screen
    if [[ "$command" == "clear" ]]; then
        clear
    fi

    # Exit the terminal
    if [[ "$command" == "exit" ]]; then
        exit 0
    fi

    # Install an application (macOS: brew, Linux: apt)
    if [[ "$command" == install* ]]; then
        app=$(echo "$command" | cut -d' ' -f2)
        if [[ "$(uname)" == "Darwin" ]]; then
            echo "Installing $app using Homebrew..."
            brew install "$app"
        else
            echo "Installing $app using apt..."
            sudo apt install -y "$app"
        fi
    fi

    # Search for an application (macOS: brew, Linux: apt)
    if [[ "$command" == search* ]]; then
        app=$(echo "$command" | cut -d' ' -f2)
        if [[ "$(uname)" == "Darwin" ]]; then
            echo "Searching for $app using Homebrew..."
            brew search "$app"
        else
            echo "Searching for $app using apt..."
            apt-cache search "$app"
        fi
    fi

    # Change directory (cd)
    if [[ "$command" == cd* ]]; then
        newDir=$(echo "$command" | cut -d' ' -f2)
        cd "$newDir" || echo "Directory not found"
    fi

    # List files in the current directory
    if [[ "$command" == "dir" ]]; then
        ls -l
    fi

    # Display system information (uses `uname`)
    if [[ "$command" == "sysinfo" ]]; then
        uname -a
    fi

    # Search for a file in the current directory
    if [[ "$command" == searchfile* ]]; then
        filename=$(echo "$command" | cut -d' ' -f2)
        find . -name "$filename"
    fi

    # Rename a file
    if [[ "$command" == rename* ]]; then
        oldname=$(echo "$command" | cut -d' ' -f2)
        newname=$(echo "$command" | cut -d' ' -f3)
        echo "Renaming file from $oldname to $newname"
        mv "$oldname" "$newname"
    fi

done
