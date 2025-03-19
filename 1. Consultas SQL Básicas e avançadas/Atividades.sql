/* Atividade 1 - Listar os nomes e cidades de todos os clientes em uma só consulta */

SELECT nome, cidade
FROM Clientes 



/* Atividade 2 - Listar os pedidos com valor acima de R$100 */

SELECT *
FROM Pedidos
WHERE valor > 100 



/* Atividade 3 - Listar os pedidos ordenados pelo valor (decrescente) */

SELECT *
FROM Pedidos
ORDER BY valor desc



/* Atividade 4 - Listar os 3 primeiros produtos cadastrados */

SELECT nome_produto
FROM Produtos
WHERE id_produto BETWEEN 1 AND 3



/* Atividade 5 - Listar o total de valor gasto por cada cliente em pedidos */

SELECT c.nome, SUM(p.valor) total_gasto
FROM Pedidos p
JOIN Clientes c ON p.id_cliente = c.id_cliente
GROUP BY c.nome



/* Atividade 6 - Encontrar o cliente com o maior valor gasto */

SELECT MAX(p.valor) AS maior_valor, c.nome cliente_com_maior_valor_gasto
FROM Pedidos p
JOIN Clientes c ON p.id_cliente = c.id_cliente



/* Atividade 7 - Utilizar CTE para calcular o total de vendas por produto */

WITH total_de_vendas
AS 
(
	SELECT p.valor, it.id_pedido, sum(it.quantidade) 
	AS quant_total
	FROM ItensPedido it 
	JOIN Pedidos p ON  p.id_pedido = it.id_pedido
	GROUP BY  p.valor, it.id_pedido
)
SELECT it.id_produto, sum((tot.valor/quant_total)*it.quantidade) 
AS valor_vendas_total 
FROM total_de_vendas tot 
JOIN ItensPedido it 
ON tot.id_pedido = it.id_pedido 
GROUP BY it.id_produto



/* ATIVIDADE 8 - Listar todos os produtos comprados por cada cliente */

SELECT 
    c.nome AS nome_do_cliente,
    prod.nome_produto AS produto,
    SUM(it.quantidade) AS quantidade_total
FROM 
    Clientes c
JOIN pedidos ped ON c.id_cliente = ped.id_cliente
JOIN itenspedido it ON ped.id_pedido = it.id_pedido
JOIN produtos prod ON it.id_produto = prod.id_produto
GROUP BY 
    c.id_cliente, c.nome, prod.id_produto, prod.nome_produto



/* ATIVIDADE 9 - Ranquear clientes pelo valor total gasto começando pelo rank 1 para o maior valor. */

SELECT c.nome, SUM(p.valor) AS total_gasto
FROM Pedidos AS p
JOIN Clientes AS c ON p.id_cliente = c.id_cliente
GROUP BY c.nome
ORDER BY total_gasto desc



/* ATIVIDADE 10 - Número de pedidos por cliente, considerando apenas aqueles com mais de 1 pedido */

SELECT c.nome, SUM(it.quantidade) AS quant_total_pedidos
FROM ItensPedido AS it
JOIN Pedidos AS ped ON it.id_pedido = ped.id_pedido
JOIN Clientes AS c ON ped.id_cliente = c.id_cliente
WHERE it.quantidade > 1
GROUP BY c.nome



/* ATIVIDADE 11 - Calcular para cada cliente a quantidade de dias entre um pedido e o pedido imediatamente anterior

WITH ped_clientes AS (
SELECT 
    id_cliente,
    id_pedido,
    data_pedido,
    LAG(data_pedido) OVER (PARTITION BY id_cliente ORDER BY data_pedido) AS data_ped_anterior
  FROM Pedidos)
SELECT c.nome as cliente, pc.data_pedido AS data_atual, pc.data_ped_anterior AS data_anterior,
 Ifnull (Cast ((JulianDay(pc.data_pedido) - JulianDay(pc.data_ped_anterior)) As Integer), 0) as dias_de_diferenca
  FROM Clientes c 
  JOIN ped_clientes pc ON c.id_cliente = pc.id_cliente

/* ATIVIDADE 12
Crie uma consulta que retorne um relatórios contendo as seguintes colunas (obs: use o padrão que preferir para nomear as colunas):
ID do cliente
Nome do cliente
Cidade do cliente
ID do pedido
Data do pedido
Valor do pedido
Preço do pedido sem desconto (pode ser recuperado somando a coluna "preço" de cada produto dentro do pedido)
Quantidade de dias entre o pedido e seu pedido imediatamente anterior
 */

WITH PedidosComPrecoTotal AS (
    SELECT 
        p.ID_CLIENTE,
        p.ID_PEDIDO,
        p.DATA_PEDIDO,
        SUM(ip.QUANTIDADE * pr.PRECO) AS VALOR_PEDIDO_SEM_DESCONTO,
        p.VALOR_PEDIDO
    FROM 
        Pedidos p
    JOIN 
        ItensDoPedido ip ON p.ID_PEDIDO = ip.ID_PEDIDO
    JOIN 
        Produtos pr ON ip.ID_PRODUTO = pr.ID_PRODUTO
    GROUP BY 
        p.ID_CLIENTE, p.ID_PEDIDO, p.DATA_PEDIDO, p.VALOR_PEDIDO
),
PedidosComDiasAtras AS (
    SELECT 
        ID_CLIENTE,
        ID_PEDIDO,
        DATA_PEDIDO,
        VALOR_PEDIDO_SEM_DESCONTO,
        VALOR_PEDIDO,
        LAG(DATA_PEDIDO) OVER (PARTITION BY ID_CLIENTE ORDER BY DATA_PEDIDO) AS DATA_PEDIDO_ANTERIOR
    FROM 
        PedidosComPrecoTotal
)
SELECT 
    c.ID_CLIENTE,
    c.NOME AS NOME_CLIENTE,
    c.CIDADE,
    p.ID_PEDIDO,
    p.DATA_PEDIDO,
    p.VALOR_PEDIDO,
    p.VALOR_PEDIDO_SEM_DESCONTO,
    DATEDIFF(p.DATA_PEDIDO, p.DATA_PEDIDO_ANTERIOR) AS DIAS_ENTRE_PEDIDOS
FROM 
    PedidosComDiasAtras p
JOIN 
    Clientes c ON p.ID_CLIENTE = c.ID_CLIENTE
WHERE 
    p.DATA_PEDIDO_ANTERIOR IS NOT NULL;