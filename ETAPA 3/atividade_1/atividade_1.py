#Atividade 1: Processamento de Dados de Vendas com Pandas
import pandas as pd

df = pd.read_csv('vendas.csv')

def adicionar_valor_total(filepath):
    df = pd.read_csv(filepath)
    
    df['valor_total'] = df['quantidade'] * df['preco_unitario']
    
    return df

def filtrar_valor_total(df, valor_minimo):
    return df[df['valor_total'] > valor_minimo]

csv_filepath = 'C:\\Users\\Fred\\mariana-dados\\Python\\atividade_de_refatoracao\\atividade_1\\vendas.csv'

df_vendas = adicionar_valor_total(csv_filepath)

df_vendas_filtradas = filtrar_valor_total(df_vendas, 500)

print(df_vendas_filtradas)