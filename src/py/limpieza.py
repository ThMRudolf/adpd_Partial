'''
Este módulo contiene funciones para la limpieza de datos. 
Contiene las siguientes funciones: 
1. anhadir_encabezados: Añade encabezados al archivo csv.
2. eliminar_columnas: Elimina columnas no necesarias del archivo csv.
3. convertir_a_minusculas: Convierte los datos de las columnas a minúsculas.
4. eliminar_acentos: Elimina los acentos de los datos de las columnas.
'''
import pandas as pd
import unicodedata
import os

def anhadir_encabezados(in_file, out_file):
    '''
    Esta función añade los encabezados al archivo csv.
    :param in_file: str, ruta del archivo csv
    :param out_file: str, ruta del archivo csv con encabezados
    :return: str, ruta del archivo csv con encabezados
    '''
    #Leemos el contenido del archivo en un dataframe: 
    local_df = pd.read_csv(in_file,header = None)
    #Añadimos los encabezados al dataframe
    local_df.columns = ["producto", "presentacion", 
                        "marca", "tipo",
                        "catalogo", "precio", 
                        "fecha", "tienda", 
                        "tipo_tienda", "sucursal", 
                        "direccion", "estado", 
                        "ciudad", "desconocido1", "desconocido2"]
    #Guardamos el dataframe en un nuevo archivo csv
    local_df.to_csv(out_file, index = False)
    return out_file

def eliminar_columnas(in_file, out_file):
    '''
    Esta función elimina las columnas no necesarias del archivo csv.
    :param in_file: str, ruta del archivo csv
    :param out_file: str, ruta del archivo csv sin columnas no necesarias

    :return: str, ruta del archivo csv sin columnas no necesarias
    '''
    #Leemos el contenido del archivo en un dataframe:
    local_df = pd.read_csv(in_file)
    #Eliminamos las columnas desconocidas
    local_df = local_df.drop(columns = ["direccion", "desconocido1", "desconocido2"])
    #Guardamos el dataframe en un nuevo archivo csv
    local_df.to_csv(out_file, index = False)
    return out_file

def convertir_a_minusculas(in_file, out_file):
    '''
    Esta función convierte los datos de las columnas a minúsculas.
    :param in_file: str, ruta del archivo csv
    :param out_file: str, ruta del archivo csv con datos en minúsculas

    :return: str, ruta del archivo csv con datos en minúsculas
    '''
    #Leemos el contenido del archivo en un dataframe:
    local_df = pd.read_csv(in_file)
    #Convertimos los datos de las columnas a minúsculas
    for col in local_df.columns:
        local_df[col] = local_df[col].apply(
            lambda x: x.lower() if isinstance(x, str) else x
        )
    #Guardamos el dataframe en un nuevo archivo csv
    local_df.to_csv(out_file, index = False)
    return out_file

def eliminar_acentos(in_file, out_file):
    '''
    Esta función elimina los acentos de los datos de las columnas.
    :param archivo: str, ruta del archivo csv

    :return: str, ruta del archivo csv sin acentos
    '''
    #Leemos el contenido del archivo en un dataframe:
    local_df = pd.read_csv(in_file)
    #Recorremos cada columna del dataframe y eliminamos los acentos
    for col in local_df.columns:
        local_df[col] = local_df[col].apply(
            lambda x: unicodedata.normalize('NFKD', x).encode('ascii', errors='ignore').decode('utf-8') if isinstance(x, str) else x
        )
    #Guardamos el dataframe en un nuevo archivo csv
    local_df.to_csv(out_file, index=False)
    return out_file
def cambiar_tipos(in_file):
    '''
    Esta función cambia los tipos de datos de las columnas.
    :param in_file: str, ruta del archivo csv

    :return: str, ruta del archivo csv con tipos de datos cambiados
    '''
    #Leemos el contenido del archivo en un dataframe:
    local_df = pd.read_csv(in_file)
    #Cambiamos los tipos de datos de las columnas
    local_df["precio"] = local_df["precio"].astype(float)
    local_df["fecha"] = pd.to_datetime(local_df["fecha"])
    #Guardamos el dataframe en un nuevo archivo csv
    local_df.to_csv(in_file, index=False)
    return in_file  

#Creamos un main para probar las funciones
if __name__ == "__main__":
    #Ruta del archivo csv
    archivo_entrada = "../../data/local/archivo_prueba.csv"
    #Añadimos encabezados al archivo csv
    archivo_encabezados = "../../data/local/archivo_encabezado.csv"
    anhadir_encabezados(archivo_entrada, archivo_encabezados)
    #Eliminamos columnas no necesarias del archivo csv
    archivo_columnas = "../../data/local/archivo_sin_columnas.csv"
    eliminar_columnas(archivo_encabezados, archivo_columnas)
    #eliminamos archivo_encabezado
    os.remove(archivo_encabezados)
    #Convertimos los datos de las columnas a minúsculas
    archivo_minusculas = "../../data/local/archivo_minusculas.csv"
    convertir_a_minusculas(archivo_columnas, archivo_minusculas)
    os.remove(archivo_columnas)
    #Eliminamos los acentos de los datos de las columnas
    archivo_acentos = "../../data/local/archivo_sin_acentos.csv"
    eliminar_acentos(archivo_minusculas, archivo_acentos)
    os.remove(archivo_minusculas)
    #Cambiamos los tipos de datos de las columnas
    cambiar_tipos(archivo_acentos)
    #Cambiamos nombre del archivo final
    os.rename(archivo_acentos, "../../data/local/archivo_final.csv")

