#!/bin/bash

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null
then
    echo "ffmpeg is not installed. Please install it and try again."
    exit 1
fi

# Default settings
input_file="UKI Standup 7-2-24.mov"
quality="standard"

# Function to print usage
print_usage() {
    echo "Usage: $0 [-q quality]"
    echo "  -q quality: Set quality to 'standard' or 'high' (default: standard)"
}

# Parse command line options
while getopts ":q:" opt; do
    case ${opt} in
        q )
            quality=$OPTARG
            ;;
        \? )
            print_usage
            exit 1
            ;;
    esac
done

# Validate quality option
if [[ "$quality" != "standard" && "$quality" != "high" ]]; then
    echo "Invalid quality option. Please use 'standard' or 'high'."
    print_usage
    exit 1
fi

# Set encoding parameters based on quality
if [[ "$quality" == "high" ]]; then
    video_params="-c:v libx264 -crf 18 -preset slower"
    audio_params="-c:a aac -b:a 320k"
else
    video_params="-c:v libx264 -crf 23 -preset medium"
    audio_params="-c:a aac -b:a 128k"
fi

# Output file
output_file="${input_file%.*}_${quality}.mp4"

# Check if input file exists
if [ ! -f "$input_file" ]; then
    echo "Input file '$input_file' not found."
    exit 1
fi

# Perform the conversion
ffmpeg -i "$input_file" $video_params $audio_params "$output_file"

# Check if conversion was successful
if [ $? -eq 0 ]; then
    echo "Conversion completed successfully. Output file: $output_file"
else
    echo "Conversion failed."
    exit 1
fi