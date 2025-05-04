#!/bin/bash
# This script processes a CSV file by filtering for specific columns and replacing commas with pipes.
# It handles quoted fields correctly, ensuring that commas within quotes are not replaced.
# Input CSV file
year="$1"
if [[ -z "$year" ]]; then
    echo "Usage: $0 <year>"
    exit 1
fi

input_folder="../../data/raw/$year"

count=0
for file in "$input_folder"/*.csv; do
    if [[ -f "$file" ]]; then
        while IFS= read -r line; do
            occurrences=$(grep -o '""' <<< "$line" | wc -l)
            if [[ $occurrences -gt 0 ]]; then
                echo "File: $file, Line: $line"
                count=$((count + occurrences))
            fi
        done < "$file"
    fi
done

echo "Total occurrences of \"\" in CSV files: $count"