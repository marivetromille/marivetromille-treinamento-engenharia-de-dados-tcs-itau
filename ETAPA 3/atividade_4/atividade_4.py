import pandas as pd
import pytest

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

def test_ler_dados_agregacao():
    df = ler_dados_agregacao('c:\\Users\\Fred\\mariana-dados\\Python\\atividade_de_refatoracao\\atividade_4\\dados_agregacao.csv')
    assert list(df.columns) == ['id', 'categoria', 'valor']
    assert len(df) == 6
    assert df.iloc[0].to_dict() == {'id': 1, 'categoria': 'A', 'valor': 100}

def test_agregar_dados():
    df = pd.DataFrame({
        'id': [1, 2, 3, 4, 5, 6],
        'categoria': ['A', 'B', 'A', 'B', 'A', 'C'],
        'valor': [100, 200, 150, 250, 200, 300]
    })
    df_agregado = agregar_dados(df)
    assert list(df_agregado.columns) == ['categoria', 'soma_valor', 'media_valor']
    assert df_agregado[df_agregado['categoria'] == 'A'].iloc[0].to_dict() == {
        'categoria': 'A', 'soma_valor': 450, 'media_valor': 150.0
    }

def test_salvar_e_ler_dados_agregados(tmp_path):
    df = pd.DataFrame({
        'categoria': ['A', 'B', 'C'],
        'soma_valor': [450, 450, 300],
        'media_valor': [150.0, 225.0, 300.0]
    })
    filepath = tmp_path / 'dados_agregados.parquet'
    salvar_dados_agregados(df, filepath)
    df_lido = ler_dados_agregados(filepath)
    pd.testing.assert_frame_equal(df, df_lido)

# Para rodar os testes, utilize o comando: pytest <nome_do_arquivo>.py
