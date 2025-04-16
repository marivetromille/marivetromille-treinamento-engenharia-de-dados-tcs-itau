import sqlite3
import pandas as pd

# Conecte ao banco SQLite
conn = sqlite3.connect('ecommerce.db')

# Liste as tabelas do banco
query = "SELECT name FROM sqlite_master WHERE type='table';"
tabelas = pd.read_sql(query, conn)['name'].tolist()

# Para cada tabela, leia os dados
for tabela in tabelas:
    try:
        # Leia os dados da tabela
        df = pd.read_sql(f'SELECT * FROM "{tabela}"', conn)
        # Salve como Parquet
        df.to_parquet(f"{tabela}.parquet", engine="pyarrow", index=False)
        print(f"Tabela {tabela} salva como Parquet.")
    except Exception as e:
        print(f"Erro ao processar a tabela {tabela}: {e}")

# Feche a conexão
conn.close()