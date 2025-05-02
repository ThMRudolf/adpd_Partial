#!/bin/bash
# This script processes a CSV file by replacing commas with pipes and converting all characters to lowercase.
# It handles quoted fields correctly, ensuring that commas within quotes are not replaced.
# Input CSV file
# Usage:
#   ./clean_filt_data.sh <year>
#
# Arguments:
#   <year>   Year of the data to be processed. The script will process all CSV files in the folder corresponding to the specified year.
#
# Description:
#   This script processes the specified input CSV file by:
#     1. Replacing commas (`,`) with pipes (`|`) as field delimiters.
#     2. Converting all characters in the file to lowercase.
#   The script ensures that commas within quoted fields are not replaced, preserving the integrity of the data.
# This script is designed to [describe the purpose of the script].
# 
# This script is used to clean and filter data based on the provided inputs.
# 
# Input Parameters:
# 1. <year>: The year in the format <yyyy>. Example: 2023
# 2. <data_source>: Specify the data source:
#    - "r" for raw data
#    - "p" for preprocessed data
# 
# Example Usage:
# ./clean_filt_data.sh 2023 r
# - This command processes raw data for the year 2023.
# 
# Notes:
# - Ensure the year is provided in the correct <yyyy> format.
# - The second parameter must be either "r" or "p".

year="$1"
input_type="$2"
if [ "$input_type" == "r" ]; then
    input_folder="../../data/raw/$year"
elif [ "$input_type" == "p" ]; then
    input_folder="../../data/processed/$year"
else
    echo "Invalid input type. Use 'r' for raw data or 'p' for processed data."
    exit 1
fi
if [ "$input_type" == "r" ]; then
    output_folder="../../data/processed/$year/cleaned"
elif [ "$input_type" == "p" ]; then
    output_folder="../../data/processed/$year/filtered_and_cleaned"
fi
mkdir -p "$output_folder"
#
# print the current date and time
echo "Current date and time: $(date)"
start_time=$(date +%s)
echo "Processing started at: $(date)"
# Process all CSV files in the input folder
for input_file in "$input_folder"/*.csv; do
    output_file="$output_folder/$(basename "$input_file")"
    mkdir -p "$(dirname "$output_file")"

    # Process the file
    awk '
    BEGIN {
        FS = ""; OFS = "";
        # Define accent mapping
        map["á"] = "a"; map["é"] = "e"; map["í"] = "i";
        map["ó"] = "o"; map["ú"] = "u"; map["ñ"] = "n";
        map["Á"] = "a"; map["É"] = "e"; map["Í"] = "i";
        map["Ó"] = "o"; map["Ú"] = "u"; map["Ñ"] = "n";
        map["ä"] = "a"; map["ë"] = "e"; map["ï"] = "i";
        map["ö"] = "o"; map["ü"] = "u";
        map["Ä"] = "a"; map["Ë"] = "e"; map["Ï"] = "i";
        map["Ö"] = "o"; map["Ü"] = "u";
    }
    {
        in_quotes = 0;
        for (i = 1; i <= NF; i++) {
            c = $i;
            if (c == "\"") {
                in_quotes = !in_quotes;
            }
            if (c == "," && !in_quotes) {
                $i = "|";
            } else {
                $i = tolower($i);
            }
            # Replace accented characters
            for (j in map) {
                if (index($i, j) > 0) {
                    gsub(j, map[j], $i);
                }
            }           
            
        }
        print;
    }
    ' "$input_file" > "$output_file"
    # Print progress to the console
    processed_files=$((processed_files + 1))
    total_files=$(ls "$input_folder"/*.csv | wc -l)
    echo "Processed $processed_files/$total_files: $(basename "$input_file")"
done
# Print the total number of processed files
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
echo "Total processing time: $elapsed_time seconds"