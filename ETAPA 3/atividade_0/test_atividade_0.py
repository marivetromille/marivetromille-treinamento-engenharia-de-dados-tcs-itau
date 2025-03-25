import unittest
from atividade_0 import fibonacci

class TestFibonacci(unittest.TestCase):
    def test_basic_cases(self):
        # Test N = 1
        self.assertEqual(fibonacci(1), 0)
        # Test N = 2
        self.assertEqual(fibonacci(2), 1)
        # Test N = 3
        self.assertEqual(fibonacci(3), 1)
        # Test N = 10
        self.assertEqual(fibonacci(10), 34)

    def test_invalid_inputs(self):
        # Test N = 0 (invalid input)
        with self.assertRaises(ValueError):
            fibonacci(0)
        # Test negative N (invalid input)
        with self.assertRaises(ValueError):
            fibonacci(-5)

if __name__ == "__main__":
    unittest.main()
