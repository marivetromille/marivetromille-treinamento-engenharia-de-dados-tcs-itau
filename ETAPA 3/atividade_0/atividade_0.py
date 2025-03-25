import time
def fibonacci(n):
    """Retorna o N-ésimo número da sequência de Fibonacci."""
    if n <= 0:
        raise ValueError("O índice deve ser um inteiro positivo.")
    if n == 1:
        return 0
    elif n == 2:
        return 1
    else:
        a, b = 0, 1
        for _ in range(2, n):
            a, b = b, a + b            
        return b
        
        
print("-----------------------------------")
print("* Sequência de Fibonacci *")
print("-----------------------------------")
valor = int(input("Digite o N-ésimo número da sequência: "))
time.sleep(0.8)
print(f"O número {valor} da sequência é {fibonacci(valor)}")
time.sleep(0.8)
print("------------ FIM -------------")