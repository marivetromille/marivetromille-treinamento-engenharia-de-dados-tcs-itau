import pandas as pd
import json

def ler_usuarios_para_dataframe(caminho_arquivo):
    with open(caminho_arquivo, 'r') as file:
        dados = json.load(file)
    df = pd.DataFrame(dados['usuarios'])
    return df

def filtrar_usuarios_maiores_de_idade(df):
    return df[df['idade'] > 18]

def ordenar_usuarios_por_idade(df):
    return df.sort_values(by='idade')

def gerar_relatorio_final(caminho_arquivo):
    df_usuarios = ler_usuarios_para_dataframe(caminho_arquivo)
    df_usuarios_maiores = filtrar_usuarios_maiores_de_idade(df_usuarios)
    df_usuarios_ordenados = ordenar_usuarios_por_idade(df_usuarios_maiores)
    return df_usuarios_ordenados.to_dict(orient='records')

# Exemplo de uso
caminho_arquivo = 'c:\\Users\\Fred\\mariana-dados\\Python\\atividade_de_refatoracao\\atividade_3\\usuario.json'
relatorio_final = gerar_relatorio_final(caminho_arquivo)
print(relatorio_final)
