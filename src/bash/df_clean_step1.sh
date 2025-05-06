#!/bin/bash
# This script processes CSV files in a specified folder by replacing commas inside quotes with semicolons.
# Get the input year folder
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


# Loop through all CSV files in the folder
for file in "$input_folder" /*.csv; do
    if [[ -f "$file" ]]; then
        output_file="$output_folder/$(basename "$file")"

        # Use awk to replace commas inside quotes with semicolons
        awk -v OFS=',' '{
            while (match($0, /"[^"]*"/)) {
                part = substr($0, RSTART, RLENGTH)
                gsub(/,/, "", part)
                $0 = substr($0, 1, RSTART-1) part substr($0, RSTART+RLENGTH)
            }
            print
        }' "$file" > "$output_file"
        echo "Processed $file -> $output_file"
    fi
done

echo "Processing completed! Modified files are in '$output_folder'."

