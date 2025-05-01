#!/bin/bash

#Nos movemos a la carpeta donde están los archivos CSV
cd ../../data/raw

# Recorre carpetas 2018 a 2024
for year in {2018..2024}; do 
    carpeta="$year"
    salida="../filtered/filtrado_${year}.csv"
    > "$salida" # Limpiamos el archivo de salida
    # Buscamos archivos CSV en la carpeta y los filtramos por la 5ª columna
    if [ -d "$carpeta" ]; then
        find "$carpeta" -type f | while read archivo; 
        do
            # Usar csvkit para filtrar filas donde la 5ª columna es BASICOS
            # Verificamos si el archivo es un CSV
            if [[ "$archivo" == *.csv ]]; then
                echo "Filtrando $archivo en carpeta $carpeta"
                # Filtramos el archivo CSV y lo guardamos en el archivo de salida
                # Filtrar filas donde la 5ª columna es BASICOS y redirigimos la salida al archivo de salida
                csvgrep --no-header-row -c 5 -m "BASICOS" "$archivo" >> "$salida"
            fi
        done
    fi
done

#Vamos a la carpeta donde están los archivos filtrados
cd ../filtered
#Eliminamos la primera fila de cada archivo filtrado 
#por alguna razón aparece "a,b,c,d,e" en la primera fila.
for archivo in filtrado_*.csv; do
    tail -n +2 "$archivo" > temp && mv temp "$archivo"
    echo "Archivo $archivo mejorado"
done
