#!/bin/bash

set -e  # Detiene el script si algo falla

echo "📦 Descomprimiendo todos los archivos .rar con unar..."

for archivo in QQP_*.rar; do
    echo "📂 Descomprimiendo $archivo..."
    unar -o . "$archivo"
done

echo "✅ Listo. Todos los archivos han sido descomprimidos."
