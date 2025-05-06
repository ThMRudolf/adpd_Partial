#!/bin/bash

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
find $input_folder -type f -name "*.csv" | while read FILE; do
    RELATIVE_PATH="$input_folder/"  # Get relative path
    OUTPUT_FILE="$output_folder"  # Define output path

    echo "Processing: $FILE -> $output_folder"
    
    # Use sed to replace commas inside quotes with semicolons
    sed -E 's/"([^"]*),([^"]*)"/"\1;\2"/g' "$FILE" > "$output_folder"
    
done

echo "Processing completed! Modified files are in '$output_folder'."

