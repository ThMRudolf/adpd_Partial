# !/bin/bash
# -----------------------------------------------------------------------------
# Code to do an ETL process on the data
# Wed 17 Apr 2024
# @roman
# -----------------------------------------------------------------------------
# create function that cleans data
function etl() {
    # $1: dir to clean
    # $2: name of the file to write to
    # S0: list all files in the directory
    files=($(ls $1/*.csv))
    # echo # of files in dir
    echo "\nNumber of files in $1: ${#files[@]}"

    # S1: Create Working files
    # create working dir
    mkdir -p data/interim
    mkdir -p data/clean

    # create working file
    file_clean="data/clean/qqp$2.csv"
    file_work="data/interim/temp.csv"
    touch $file_clean
    touch $file_work

    # S2: Transform Data
    # header
    header="product,presentation,brand,category,catalog,price,created_at,store,type_of_store,branch,direction,state,city,latitude,longitude"
    echo $header > $file_clean

    # loop through files
    for file in $files; do
        # append to working file
        cat $file >> $file_clean
        # head -n 100 $file >> $file_clean
    done

    # echo num of lines
    echo "\nNumber of lines in $file_clean: $(wc -l $file_clean)"

    # S3: Clean Data
    # cleaning file to lower case
    awk '{print tolower($0)}' $file_clean > $file_work

    # get rid of latin characters in cleaning file
    sed -i '' 's/á/a/g' $file_work
    sed -i '' 's/é/e/g' $file_work
    sed -i '' 's/í/i/g' $file_work
    sed -i '' 's/ó/o/g' $file_work
    sed -i '' 's/ú/u/g' $file_work
    sed -i '' 's/ñ/n/g' $file_work

    # get rid of U+feff character
    sed -i '' 's/\xEF\xBB\xBF//' $file_work

    # # substitute commas for semicolons that are between quotes
    awk -F'"' -v OFS='' '{ for (i=2; i<=NF; i+=2) gsub(",", ";", $i) } 1' $file_work > $file_clean
}

# main ####
# list dirs to clean
DIRS_TO_CLEAN=("data/raw/2018" "data/raw/2019" "data/raw/2020" "data/raw/2021" "data/raw/2022" "data/raw/2023" "data/raw/2024")

# loop through dirs
for dir in "${DIRS_TO_CLEAN[@]}"; do
    # get name of the file to write to
    file_name=$(echo $dir | awk -F'/' '{print $NF}')

    # echo
    echo "----- Cleaning data in $dir -----"

    # call etl function
    etl $dir $file_name
done

# join all files into one but skip the header
echo "\nJoining all files into one..."
echo $header > data/clean/qqp.csv
for file in data/clean/*.csv; do
    tail -n +2 $file >> data/clean/qqp.csv
done


# echo num of lines
echo "\nNumber of lines in QQP: $(wc -l data/clean/qqp.csv)"

# count the unique values in the catalog column
awk -F',' '{print $5}' data/clean/qqp.csv | sort | uniq -c | sort -nr

# finished
echo "\n\t\tFinished cleaning data!"