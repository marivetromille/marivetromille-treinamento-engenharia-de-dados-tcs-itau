import unittest
import pandas as pd
from atividades_3 import (
    ler_usuarios_para_dataframe,
    filtrar_usuarios_maiores_de_idade,
    ordenar_usuarios_por_idade,
    gerar_relatorio_final,
)

class TestAtividades3(unittest.TestCase):
    def setUp(self):
        self.dados_mock = {
            "usuarios": [
                {"nome": "Alice", "idade": 25},
                {"nome": "Bob", "idade": 17},
                {"nome": "Carol", "idade": 30},
            ]
        }
        self.df_mock = pd.DataFrame(self.dados_mock["usuarios"])

    def test_ler_usuarios_para_dataframe(self):
        # Simula a leitura de um arquivo JSON
        with unittest.mock.patch("builtins.open", unittest.mock.mock_open(read_data='{"usuarios": [{"nome": "Alice", "idade": 25}]}')):
            df = ler_usuarios_para_dataframe("mock_path.json")
            self.assertEqual(len(df), 1)
            self.assertEqual(df.iloc[0]["nome"], "Alice")
            self.assertEqual(df.iloc[0]["idade"], 25)

    def test_filtrar_usuarios_maiores_de_idade(self):
        df_filtrado = filtrar_usuarios_maiores_de_idade(self.df_mock)
        self.assertEqual(len(df_filtrado), 2)
        self.assertTrue((df_filtrado["idade"] > 18).all())

    def test_ordenar_usuarios_por_idade(self):
        df_ordenado = ordenar_usuarios_por_idade(self.df_mock)
        idades_ordenadas = df_ordenado["idade"].tolist()
        self.assertEqual(idades_ordenadas, sorted(idades_ordenadas))

    def test_gerar_relatorio_final(self):
        with unittest.mock.patch("builtins.open", unittest.mock.mock_open(read_data='{"usuarios": [{"nome": "Alice", "idade": 25}, {"nome": "Bob", "idade": 17}, {"nome": "Carol", "idade": 30}]}')):
            relatorio = gerar_relatorio_final("mock_path.json")
            self.assertEqual(len(relatorio), 2)
            self.assertEqual(relatorio[0]["nome"], "Alice")
            self.assertEqual(relatorio[1]["nome"], "Carol")

if __name__ == "__main__":
    unittest.main()
