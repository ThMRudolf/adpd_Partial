#!/bin/bash
# This script processes a CSV file by replacing commas with pipes and converting all characters to lowercase.
# It handles quoted fields correctly, ensuring that commas within quotes are not replaced.
# Input CSV file
year="$1"
input_folder="../../data/raw/$year"
output_folder="../../data/processed/$year/basico"

if [ -z "$year" ]; then
    echo "Usage: $0 <year>"
    exit 1
fi
mkdir -p "$output_folder"
#
# print the current date and time
echo "Current date and time: $(date)"
start_time=$(date +%s)
echo "Processing started at: $(date)"
# Process all CSV files in the input folder
#for output_file in "$output_folder"/*.csv; do

#    # Process the file cleaning it up
#    iconv -f UTF-8 -t  ASCII "$output_file" #//TRANSLIT
#    #rm "$output_file.tmp"
#    # Print progress to the console
#    processed_files=$((processed_files + 1))
#    total_files=$(ls "$input_folder"/*.csv | wc -l)
#    echo "Processed $processed_files/$total_files: $(basename "$input_file")"
#    # Remove accents from the output file using iconv
    
#done
# Create a new folder for filtered files
filtered_folder= output_folder
# Filter the CSV files by the 5th column, selecting only rows where the content is "basico"
for input_file in "$input_folder"/*.csv; do
    awk -F',' '$5 == "BASICOS"' "$input_file" > "$filtered_folder/$(basename "$input_file")"
    # Print progress to the console
    processed_files=$((processed_files + 1))
    total_files=$(ls "$input_folder"/*.csv | wc -l)
    echo "Processed $processed_files/$total_files: $(basename "$input_file")"
done



echo "Current date and time: $(date)"
start_time=$(date +%s)
echo "Processing ended at: $(date)"
