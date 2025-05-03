#!/bin/bash

# Define the year and folders
year=$1
input_folder="../../data/processed/$year/cleaned"
output_folder="../../data/processed/$year/spaces_cleaned"

# Create the output folder if it doesn't exist
mkdir -p "$output_folder"

# Process each CSV file in the input folder
for file in "$input_folder"/*.csv; do
    # Get the base name of the file
    filename=$(basename "$file")
    
    # Remove spaces and save to the output folder
    sed 's/ //g' "$file" > "$output_folder/$filename"
    echo "Processed $file -> $output_folder/$filename"
    # Plot progress
    total_files=$(ls "$input_folder"/*.csv | wc -l)
    processed_files=$(ls "$output_folder"/*.csv | wc -l)
    echo "Progress: $processed_files/$total_files files processed."
done

echo "All CSV files have been cleaned and saved to $output_folder."
