resource "aws_glue_catalog_database" "database-sor-da-mari" {
    name = "mariana_vetromille_database_sor"
}

resource "aws_glue_catalog_table" "tb-contas-da-mari" {
    name = "mariana_vetromille_table_contas"
    database_name = aws_glue_catalog_database.database-sor-da-mari.name
    table_type = "EXTERNAL_TABLE"

    parameters = {
        "classification" = "parquet"
        "compressionType" = "SNAPPY"
    }

    storage_descriptor {
        location = "s3://mariana-vetromille-bucket/contas/"
         input_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
         output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

        ser_de_info {
            serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
        }

        columns {
            name = "id"
            type = "int"
        }
        columns {
            name = "nome"
            type = "string"
        }
        columns {
            name = "descricao"
            type = "string"
        }
    }

    partition_keys {
        name = "data_ingestao"
        type = "string"
    }

depends_on = [ aws_glue_catalog_database.database-sor-da-mari ]

}

resource "aws_glue_catalog_table" "tb-categorias-da-mari" {
    name = "mariana_vetromille_table_categorias"
    database_name = aws_glue_catalog_database.database-sor-da-mari.name
    table_type = "EXTERNAL_TABLE"

    parameters = {
        "classification" = "parquet"
        "compressionType" = "SNAPPY"
    }

    storage_descriptor {
        location = "s3://mariana-vetromille-bucket/categorias/"
         input_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
         output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

        ser_de_info {
            serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
        }

        columns {
            name = "id"
            type = "int"
        }
        columns {
            name = "nome"
            type = "string"
        }
        columns {
            name = "tipo"
            type = "string"
        }
    }

    partition_keys {
        name = "data_ingestao"
        type = "string"
    }

depends_on = [ aws_glue_catalog_database.database-sor-da-mari ]

}

resource "aws_glue_catalog_table" "tb-transacoes-da-mari" {
    name = "mariana_vetromille_table_transacoes"
    database_name = aws_glue_catalog_database.database-sor-da-mari.name
    table_type = "EXTERNAL_TABLE"

    parameters = {
        "classification" = "parquet"
        "compressionType" = "SNAPPY"
    }

    storage_descriptor {
        location = "s3://mariana-vetromille-bucket/transacoes/"
         input_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
         output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

        ser_de_info {
            serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
        }

        columns {
            name = "id"
            type = "int"
        }
        columns {
            name = "conta-id"
            type = "int"
        }
        columns {
            name = "categoria-id"
            type = "int"
        }
        columns {
            name = "data"
            type = "date"
        }
        columns {
            name = "descricao"
            type = "string"
        }
        columns {
            name = "valor"
            type = "decimal(10,2)"
        }
        columns {
            name = "data_criacao"
            type = "timestamp"
        }
        
    }

    partition_keys {
        name = "data_ingestao"
        type = "string"
    }

depends_on = [ aws_glue_catalog_database.database-sor-da-mari ]

}