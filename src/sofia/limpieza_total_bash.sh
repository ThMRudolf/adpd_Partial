#!/bin/bash

set -e

echo "🧼 Iniciando limpieza sin iconv..."

for year in 2018 2019 2020 2021 2022 2023 2024; do
    echo "🔍 Procesando año $year..."
    mkdir -p limpio

    for archivo in $year/*.csv; do
        nombre_salida="limpio/$(basename "$archivo" .csv)_${year}_limpio.csv"

        # Paso 1: quitar comillas, tabs, saltos y pasar a minúsculas
        sed 's/["'\''\r\t]//g' "$archivo" | \
        tr '[:upper:]' '[:lower:]' | \
        sed -E 's/  +/ /g' > temp_clean.csv

        # Paso 2: procesar columnas con awk
        awk -F',' '
        {
            out = "";
            for (i = 1; i <= NF; i++) {
                if (i == 11) {
                    out = out $i "|";  # direccion: mantener comas
                } else if (i == 15 || i == 16) {
                    continue;          # eliminar latitud y longitud
                } else {
                    gsub(",", "|", $i);
                    out = out $i "|";
                }
            }
            sub(/\|$/, "", out);
            print out;
        }' temp_clean.csv > "$nombre_salida"

        echo "✅ Generado: $nombre_salida"
    done
done

rm -f temp_clean.csv

echo "🏁 Limpieza terminada."
