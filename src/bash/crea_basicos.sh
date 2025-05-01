#! /bin/bash
#Script para crear una muestra a partir de los archivos filtrado_*.csv

#Nos movemos a la carpeta donde están los archivos filtrado_*.csv
cd ../../data/filtered
archivo="../../data/raw/archivo_basicos.csv"

#Borramos archivo_prueba.csv si existe
#Así no concatenamos en diferentes corridas. 
if [ -f $archivo ]
then
    rm $archivo
fi

#Recorremos todos los archivos filtrado_*.csv
for i in filtrado_*.csv;
do
    #Concatenamos los archivos filtrado_*.csv
    $i >> $archivo
    echo "Archivo $i concatenado a  archivo_basicos.csv"
done