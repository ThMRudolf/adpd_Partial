#!/bin/bash

# Carpeta raíz donde están los .rar y las carpetas descomprimidas
RUTA="./profeco_local"

cd "$RUTA" || exit 1

mkdir -p filtrados

echo "📦 Descomprimiendo .rar con unar..."
for archivo in QQP_*.rar; do
    unar -o . "$archivo"
done

echo "📂 Filtrando archivos por año..."
for year in 2018 2019 2020 2021 2022 2023 2024; do
    echo "🧹 Año $year"

    mkdir -p filtrados/$year
    rm -f filtrados/$year/basicos_$year.csv

    for csv in $year/*.csv; do
        # Filtra filas donde columna 5 == "BASICOS"
        awk -F',' '$5 == "BASICOS"' "$csv" >> filtrados/$year/basicos_$year.csv
    done

    # Toma 1000 muestras por año
    head -n 1000 filtrados/$year/basicos_$year.csv > filtrados/muestra_$year.csv
done

echo "🧩 Uniendo muestras en un solo archivo..."
cat filtrados/muestra_*.csv > muestra_basicos_todos.csv

echo "✅ Listo: muestra_basicos_todos.csv creada con 7000 filas."
