import pandas as pd

def ler_dados_agregacao(filepath):
    return pd.read_csv(filepath)

def agregar_dados(df):
    agregados = df.groupby('categoria').agg(
        soma_valor=('valor', 'sum'),
        media_valor=('valor', 'mean')
    ).reset_index()
    return agregados

def salvar_dados_agregados(df, filepath):
    df.to_parquet(filepath, index=False)

def ler_dados_agregados(filepath):
    return pd.read_parquet(filepath)

df = ler_dados_agregacao('c:\\Users\\Fred\\mariana-dados\\Python\\atividade_de_refatoracao\\atividade_4\\dados_agregacao.csv')
print(df)

df_agregado = agregar_dados(df)
print(df_agregado)

salvar_dados_agregados(df_agregado, 'c:\\Users\\Fred\\mariana-dados\\Python\\atividade_de_refatoracao\\atividade_4\\dados_agregados.parquet')

df_validacao = ler_dados_agregados('c:\\Users\\Fred\\mariana-dados\\Python\\atividade_de_refatoracao\\atividade_4\\dados_agregados.parquet')
print(df_validacao)
