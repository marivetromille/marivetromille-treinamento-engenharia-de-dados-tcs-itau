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

import unittest
from io import StringIO

class TestAtividade2(unittest.TestCase):
    def setUp(self):
        self.mock_csv = StringIO("""nome,nota1,nota2,nota3
Maria,7,8,9
João,5,5,5
Ana,10,10,10
""")
        self.df = pd.read_csv(self.mock_csv)

    def test_calcular_media_notas(self):
        df_com_media = calcular_media_notas(self.mock_csv)
        self.assertAlmostEqual(df_com_media.loc[0, 'media_notas'], 8.0)
        self.assertAlmostEqual(df_com_media.loc[1, 'media_notas'], 5.0)
        self.assertAlmostEqual(df_com_media.loc[2, 'media_notas'], 10.0)

    def test_gerar_relatorio_status(self):
        df_com_media = calcular_media_notas(self.mock_csv)
        relatorio = gerar_relatorio(df_com_media)
        self.assertEqual(relatorio.loc[0, 'status'], 'Aprovado')
        self.assertEqual(relatorio.loc[1, 'status'], 'Reprovado')
        self.assertEqual(relatorio.loc[2, 'status'], 'Aprovado')

    def test_gerar_relatorio_estrutura(self):
        df_com_media = calcular_media_notas(self.mock_csv)
        relatorio = gerar_relatorio(df_com_media)
        self.assertListEqual(list(relatorio.columns), ['nome', 'media_notas', 'status'])
        self.assertEqual(len(relatorio), 3)

if __name__ == '__main__':
    unittest.main()