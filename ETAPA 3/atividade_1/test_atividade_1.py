import unittest
import pandas as pd
import os
from atividade_1 import adicionar_valor_total, filtrar_valor_total

class TestAtividade1(unittest.TestCase):
    def setUp(self):
        # Create a sample DataFrame for testing
        self.sample_data = {
            'produto': ['A', 'B', 'C'],
            'quantidade': [10, 5, 2],
            'preco_unitario': [50, 200, 300]
        }
        self.df = pd.DataFrame(self.sample_data)

    def test_adicionar_valor_total(self):
        # Test if the function adds the 'valor_total' column correctly
        df_result = adicionar_valor_total('test_vendas.csv')
        self.assertIn('valor_total', df_result.columns)
        self.assertEqual(df_result['valor_total'].tolist(), [500, 1000, 600])

    def test_filtrar_valor_total(self):
        # Test if the filtering works correctly
        self.df['valor_total'] = self.df['quantidade'] * self.df['preco_unitario']
        df_filtered = filtrar_valor_total(self.df, 500)
        self.assertEqual(len(df_filtered), 2)
        self.assertTrue((df_filtered['valor_total'] > 500).all())

    def test_csv_generation(self):
        # Test if the CSV file is generated correctly
        test_filepath = 'test_vendas.csv'
        self.df.to_csv(test_filepath, index=False)
        self.assertTrue(os.path.exists(test_filepath))
        os.remove(test_filepath)

if __name__ == "__main__":
    unittest.main()
