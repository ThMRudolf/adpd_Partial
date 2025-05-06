#!/bin/bash

# call the script with the data_preprocessing for each year (2018 to 2024)
# Usage: ./data_preprocessing.sh <year> r
echo "Start time: $(date)"

echo " "
echo "2018"
./data_preprocessing.sh 2018 r
echo " "
echo "2019"
./data_preprocessing.sh 2019 r
echo " "
echo "2020"
./data_preprocessing.sh 2020 r
echo " "
echo "2021"
./data_preprocessing.sh 2021 r
echo " "
echo "2022"
./data_preprocessing.sh 2022 r
echo " "
echo "2023"
./data_preprocessing.sh 2023 r
echo " "
echo "2024"
./data_preprocessing.sh 2024 r

echo "End time: $(date)"
echo "All data preprocessing completed."
start_time=$(date +%s)
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
echo "Total elapsed time: ${elapsed_time} seconds."