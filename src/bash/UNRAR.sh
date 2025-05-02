#!/bin/bash
#Move to data/raw directory
cd ../../data/raw

for f in *????.rar; do  
    # Extraer el año del nombre del archivo (últimos 4 caracteres antes de .rar)
    year=${f%%.rar}
    year=${year: -4}
    # Verificar si el directorio del año ya existe
    if [ -d "$year" ]; then
        echo "El directorio $year ya existe. Saltando..." 
        continue    
    fi
    echo "Creando directorio $year..."
    mkdir "$year"
    # Descomprimir el archivo en el directorio creado
    unar "$f" -o "$year"
done

#volver al directorio original
cd ../../src/bash