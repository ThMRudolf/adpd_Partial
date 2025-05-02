#!/bin/bash
start_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "Script started at: $start_time"
# This script is used to filter all csv files in a from 2018 to 2024 and save them in a new directory (data/processed/<year>).
# Then it takes the filtered csv files and cleans the csv files.

echo "startinng filtering colum 5"
./clean_data_filt_basicos.sh 2018 5 "BASICOS"
./clean_data_filt_basicos.sh 2019 5 "BASICOS"
./clean_data_filt_basicos.sh 2020 5 "BASICOS"
./clean_data_filt_basicos.sh 2021 5 "BASICOS"
./clean_data_filt_basicos.sh 2022 5 "BASICOS"
./clean_data_filt_basicos.sh 2023 5 "BASICOS"
./clean_data_filt_basicos.sh 2024 5 "BASICOS"

# the raw data are cleaned.
echo "startinng cleaning raw data"
./clean_filt_data.sh 2018 r
./clean_filt_data.sh 2019 r
./clean_filt_data.sh 2020 r
./clean_filt_data.sh 2021 r
./clean_filt_data.sh 2022 r
./clean_filt_data.sh 2023 r
./clean_filt_data.sh 2024 r



# Then, once the csv files are filtered, the filter files are cleaned.
echo "startinng preprocessed filtered data"
./clean_filt_data.sh 2018 p
./clean_filt_data.sh 2019 p
./clean_filt_data.sh 2020 p
./clean_filt_data.sh 2021 p
./clean_filt_data.sh 2022 p
./clean_filt_data.sh 2023 p
./clean_filt_data.sh 2024 p

end_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "Script ended at: $end_time"

start_seconds=$(date -d "$start_time" +%s)
end_seconds=$(date -d "$end_time" +%s)
duration=$((end_seconds - start_seconds))

echo "Total execution time: $duration seconds"