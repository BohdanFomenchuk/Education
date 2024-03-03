#!/bin/bash

# Function to display help message
display_help() {
    echo "Usage: $0 [OPTIONS] [DIRECTORY]"
    echo "Options:"
    echo "  -h          Display this help message"
    echo "  -d ARG      Set the depth of recursion in directory"
    echo "  -r          Search recursively in subdirectories"
    exit 1
}

# Set default values for options
depth=""
recursive=""

# Parse command-line arguments
while getopts ":hd:r" opt; do
    case $opt in
        h)
            display_help
            ;;
        d)
            depth="$OPTARG"
            ;;
        r)
            recursive="true"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            display_help
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            display_help
            ;;
    esac
done

# Shift arguments to get the directory parameter
shift $((OPTIND - 1))
directory="${1:-.}"  # Default to current directory if no directory is provided

# Validate if only one directory is provided
if [ $# -gt 1 ]; then
    echo "Error: More than one directory provided. Only one directory is allowed." >&2
    exit 1
fi

# Function to process files in the directory
process_files() {
    local dir="$1"

    # Traverse all files in the specified directory
    for file in "$dir"/*; do
        # Check if the file is executable
        if [ -x "$file" ]; then
            echo "File $file is executable"
        fi
        # Check if the file is a symbolic link
        if [ -L "$file" ]; then
            echo "File $file is a soft link"
        fi
    done
}

# Main script logic
if [ -n "$recursive" ]; then
    # Process files recursively if the -r option is specified
    if [ -n "$depth" ]; then
        # If depth is specified, use find command with maxdepth option
	find "$directory" -maxdepth "$depth" -type f 
    else
        # If depth is not specified, use find command without maxdepth option
	find "$directory" -type f
    fi
else
    # Process files only in the specified directory
    process_files "$directory"
    
fi

