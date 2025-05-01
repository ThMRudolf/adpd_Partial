#!/bin/bash
# This script processes a CSV file by replacing commas with pipes and converting all characters to lowercase.
# It handles quoted fields correctly, ensuring that commas within quotes are not replaced.
# Input CSV file
input_folder="../../data/raw/2018"
output_folder="../../data/processed/2018"
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
    # Remove accents from the output file using iconv
    #iconv -f UTF-8 -t ASCII//TRANSLIT "$output_file" -o "$output_file.tmp" && mv "$output_file.tmp" "$output_file"
done

# Remove accents from the output file using iconv
#iconv -f UTF-8 -t ASCII//TRANSLIT "$output_file" #-o "$output_file.tmp" && mv "$output_file.tmp" "$output_file"

echo "Current date and time: $(date)"
start_time=$(date +%s)
echo "Processing ended at: $(date)"
