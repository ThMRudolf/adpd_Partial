#! /bin/bash
#Script para crear una muestra a partir de los archivos filtrado_*.csv

#Nos movemos a la carpeta donde están los archivos filtrado_*.csv
cd ../../data/filtered
archivo="../../data/local/archivo_prueba.csv"

#Borramos archivo_prueba.csv si existe
#Así no concatenamos en diferentes corridas. 
if [ -f $archivo ]
then
    rm $archivo
fi

#Recorremos todos los archivos filtrado_*.csv
for i in filtrado_*.csv;
do
    #Tomamos las primeras 1000 filas de cada archivo filtrado_*.csv
    head -n 1000 $i >> $archivo
done
