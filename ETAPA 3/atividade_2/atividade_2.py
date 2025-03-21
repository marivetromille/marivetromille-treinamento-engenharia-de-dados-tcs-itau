import pandas as pd

def calcular_media_notas(caminho_arquivo):
    df = pd.read_csv(caminho_arquivo)
    
    df['media_notas'] = df.mean(axis=1)
    
    return df

def gerar_relatorio(df):
    df['status'] = df['media_notas'].apply(lambda x: 'Aprovado' if x > 6 else 'Reprovado')
    return df[['nome', 'media_notas', 'status']]

caminho_arquivo = '/c:/Users/Fred/mariana-dados/Python/atividade_de_refatoracao/atividade_2/alunos.csv'
df_com_media = calcular_media_notas(caminho_arquivo)
relatorio = gerar_relatorio(df_com_media)
print(relatorio)