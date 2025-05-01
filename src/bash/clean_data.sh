#!/bin/bash
# This script processes a CSV file by replacing commas with pipes and converting all characters to lowercase.
# It handles quoted fields correctly, ensuring that commas within quotes are not replaced.
# Input CSV file
input_folder="../../data/raw/2018"
output_folder="../../data/processed/2018"
mkdir -p "$output_folder"

# Process all CSV files in the input folder
for input_file in "$input_folder"/*.csv; do
    output_file="$output_folder/$(basename "$input_file")"
    mkdir -p "$(dirname "$output_file")"

    # Process the file
    awk '
    BEGIN {
        FS = ""; OFS = "";
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
        }
        print;
    }
    ' "$input_file" > "$output_file"

    # Remove accents from the output file using iconv
    iconv -f UTF-8 -t ASCII//TRANSLIT "$output_file" -o "$output_file.tmp" && mv "$output_file.tmp" "$output_file"
done

# Remove accents from the output file using iconv
#iconv -f UTF-8 -t ASCII//TRANSLIT "$output_file" #-o "$output_file.tmp" && mv "$output_file.tmp" "$output_file"