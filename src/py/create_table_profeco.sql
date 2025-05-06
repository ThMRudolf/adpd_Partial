
CREATE EXTERNAL TABLE IF NOT EXISTS profeco_db.profeco (
    id STRING,
    categoria STRING,
    precio FLOAT,
    fecha DATE,
    estado STRING,
    marca STRING
)
PARTITIONED BY (anio INT)
STORED AS PARQUET
LOCATION "{BUCKET}/{FOLDER}/sql"
/"
TBLPROPERTIES ('parquet.compression'='SNAPPY');
