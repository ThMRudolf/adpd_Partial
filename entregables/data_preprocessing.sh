#!/bin/bash
# This script processes a CSV file by filtering for specific columns and replacing commas with pipes.
# It handles quoted fields correctly, ensuring that commas within quotes are not replaced.
# Input CSV file
# -----------------------------------------------------------------------------
# SCRIPT NAME: clean_data_filt_basicos.sh
#
# DESCRIPTION:
# This script processes a CSV file by filtering rows based on a specific column 
# and value. It ensures proper handling of quoted fields, preserving the integrity 
# of data with commas within quotes. Additionally, it replaces commas with pipes 
# for easier downstream processing.
#
# USAGE:
#   ./clean_data_filt_basicos.sh <year> <r, p>
#
# PARAMETERS:
#   year (int)          : The year to be processed.
#   r (string)          : filering raw data.
#   p (string)          : filering processed data.
#
# EXAMPLE:
#   ./clean_data_filt_basicos.sh 2023 r
#
# NOTES:
# - Ensure the input CSV file is properly formatted and accessible.
# - The script assumes the column index starts from 1 (not 0-based indexing).
# - Quoted fields are handled correctly to avoid unintended replacements.
#
# AUTHOR:
#   [Sofia/Marta/Thomas]
#
# VERSION:
#   1.0
#
# -----------------------------------------------------------------------------
    echo "Invalid input type. Use 'r' for raw data or 'p' for processed data."
    exit 1
fi
if [ "$input_type" == "r" ]; then
    output_folder="../data/processed/$year/cleaned"
elif [ "$input_type" == "p" ]; then
    output_folder="../data/processed/$year/filtered_and_cleaned"
fi
mkdir -p "$output_folder"


start_time=$(date +%s)
echo "Script started at: $start_time"

echo $basename

# Process all CSV files in the input folder
for file in "$input_folder"/*.csv; do
    echo $(basename "$file")
    if [[ -f "$file" ]]; then
        output_file="$output_folder/$(basename "$file")"
        awk -F',' '{
            for (i = 1; i <= NF; i++){
            gsub("," " ", $i)
            gsub(/,/, "", $i)
        }
        OFS="|"
        print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15
        }' "$file" > "$output_file"
        echo "Processed $file -> $output_file"
    fi
done

end_time=$$(date +%s)
echo "Script ended at: $end_time"
echo "Total time taken: $(( $(date -d "$end_time" +%s) - $(date -d "$start_time" +%s) )) seconds"