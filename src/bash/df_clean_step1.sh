#!/bin/bash
# This script processes a CSV file by filtering for specific columns and replacing commas with pipes.
# It handles quoted fields correctly, ensuring that commas within quotes are not replaced.
# Input CSV file
# -----------------------------------------------------------------------------
# clean_data_filt_basicos.sh
#
# This script processes data by filtering based on a specific column and value.
#
# USAGE:
#   ./clean_data_filt_basicos.sh <year> <column_number> <filter_value>
#
# PARAMETERS:
#   year (int)           : The year to be processed.
#   column_number (int)  : The column index to be used for operations.
#   filter_value (str)   : The value to filter the data by.
#
# EXAMPLE:
#   ./clean_data_filt_basicos.sh 2023 2 "active"
#
# -----------------------------------------------------------------------------
# This function takes three input parameters:
# 1. year (int): The year to be processed.
# 2. column_number (int): The column index to be used for operations.
# 3. filter_value (str): The value to filter the data by.
year="$1"
if [[ -z "$year" ]]; then
    echo "Usage: $0 <year>"
    exit 1
fi

input_folder="../../data/raw/$year"
output_folder="../../data/processed/$year"
column_number="$2"
filter_value="$3"

if [[ -z "$column_number" || -z "$filter_value" ]]; then
    echo "Usage: $0 <year> <column_number> <filter_value>"
    exit 1
fi

mkdir -p "$output_folder"
start_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "Script started at: $start_time"
for file in "$input_folder"/*.csv; do   
    #echo $file
    if [[ -f "$file" ]]; then
        output_file="$output_folder/$(basename "$file")"
        awk -v col="$column_number" -v val="$filter_value" -F',' '
        BEGIN { OFS = "," }
        {
            if (NR == 1 || $col == val) print $0
            $$7 = ""
        }' "$file" > "$output_file"
        echo "Processed $file -> $output_file"
    fi
done
end_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "Script ended at: $end_time"
echo "Total time taken: $(( $(date -d "$end_time" +%s) - $(date -d "$start_time" +%s) )) seconds"