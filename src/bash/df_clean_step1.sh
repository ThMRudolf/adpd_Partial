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


start_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "Script started at: $start_time"

echo $basename

# Process all CSV files in the input folder
for file in "$input_folder"/*.csv; do
    echo $(basename "$file")
    if [[ -f "$file" ]]; then
        output_file="$output_folder/$(basename "$file")"
        awk -F',' '{
            for (i = 1; i <= NF; i++) {
                quoted = substr($0, RSTART, RLENGTH)
                gsub(/,/, ";", quoted)
                $0 = substr($0, 1, RSTART-1) quoted substr($0, RSTART+RLENGTH)
            }
            gsub(/,/, "|", $0)
            split($0, fields, "|")
            if (length(fields) == 15) {
                print
            }
        }' OFS=',' "$file" > "$output_file"
        echo "Processed $file -> $output_file"
    fi
done

end_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "Script ended at: $end_time"
echo "Total time taken: $(( $(date -d "$end_time" +%s) - $(date -d "$start_time" +%s) )) seconds"