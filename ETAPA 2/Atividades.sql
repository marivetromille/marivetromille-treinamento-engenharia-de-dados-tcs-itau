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
ORDER BY valor DESC



/* Atividade 4 - Listar os 3 primeiros produtos cadastrados */

SELECT nome_produto
FROM Produtos
WHERE id_produto BETWEEN 1 AND 3

OU

SELECT *
FROM Produtos
ORDER BY id_produto
LIMIT 3

WHERE
GROUP BY
HAVING
ORDER BY
LIMIT


/* Atividade 5 - Listar o total de valor gasto por cada cliente em pedidos */

SELECT c.nome, SUM(p.valor) total_gasto
FROM Pedidos p
JOIN Clientes c ON p.id_cliente = c.id_cliente
GROUP BY c.nome

SELECT
  c.id_cliente,
  c.nome,
  SUM(p.valor
FROM
  Clientes c
  INNER JOIN Pedidos p
     ON c.id_cliente = p.id_cliente
GROUP BY
  c.id_cliente,
  c.nome


/* Atividade 6 - Encontrar o cliente com o maior valor gasto */

SELECT MAX(p.valor) AS maior_valor, c.nome cliente_com_maior_valor_gasto
FROM Pedidos p
JOIN Clientes c ON p.id_cliente = c.id_cliente

SELECT 
   c.id_cliente,
   c.nome,
   SUM(p.valor)
FROM
   Clientes c
   INNER JOIN Pedidos p
      ON c.id_cliente = p.id_cliente
GROUP BY
   c.id_cliente,
   c.nome
ORDER BY valor_gasto DESC
LIMIT 1


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


WITH VendasPorProduto AS (
	SELECT
	ip.id_produto,
	SUM(ip.quantidade) total_vendido
FROM ItensPedido ip
GROUP BY ip.id_produto
)
SELECT 
	p.id_produto, 
	p.nome_produto, 
	vp.total_vendido,
	(vp.total_vendido * p.preco) valor_total_vendas
FROM 
	Produtos p
	INNER JOIN VendasPorProduto vp
	ON p.id_produto = vp.id_produto



/* Atividade 8 - Listar todos os produtos comprados por cada cliente */

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


SELECT 
    c.id_cliente,
    c.nome,
    p.id_produto,
    p.nome_produto
FROM 
    Clientes c
	INNER JOIN Pedidos pd 
		ON c.id_cliente = pd.id_cliente
	INNER JOIN ItensPedido ip 
		ON pd.id_pedido = ip.id_pedido
	INNER JOIN Produtos p 
		ON p.id_produto = ip.id_produto


/* Atividade 9 - Ranquear clientes pelo valor total gasto começando pelo rank 1 para o maior valor. */

SELECT c.nome, SUM(p.valor) AS total_gasto
FROM Pedidos AS p
JOIN Clientes AS c ON p.id_cliente = c.id_cliente
GROUP BY c.nome
ORDER BY total_gasto desc


SELECT 
	c.id_cliente,
	c.nome, 
	SUM(p.valor) AS total_gasto,
	RANK() OVER (ORDER BY SUM(p.valor) DESC) ranking
FROM 
	Clientes c
	INNER JOIN Pedidos p
		ON c.id_cliente = p.id_cliente
GROUP BY 
	c.id_cliente,
	c.nome


/* ATIVIDADE 10 - Número de pedidos por cliente, considerando apenas aqueles com mais de 1 pedido */

SELECT c.nome, SUM(it.quantidade) AS quant_total_pedidos
FROM ItensPedido AS it
JOIN Pedidos AS ped ON it.id_pedido = ped.id_pedido
JOIN Clientes AS c ON ped.id_cliente = c.id_cliente
WHERE it.quantidade > 1
GROUP BY c.nome

SELECT
	c.id_cliente,
	c.nome,
	COUNT(p.id_pedido) quantidade_pedidos
FROM
	Clientes c
	INNER JOIN Pedidos p
		ON c.id_cliente = p.id_cliente
GROUP BY
	c.id_cliente,
	c.nome
HAVING
	COUNT (p.id_pedido) > 1


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


WITH t AS (
SELECT 
	c.id_cliente,
	c.nome,
	p.id_pedido,
	p.data_pedido,
	LAG(p.data_pedido) OVER (PARTITION BY c.id_cliente ORDER BY p.data_pedido) AS data_pedido_anterior
FROM 
	Clientes c
	INNER JOIN Pedidos p
		ON c.id_cliente = p.id_cliente		
)
SELECT
	*,
	(JULIANDAY(data_pedido) - JULIANDAY(data_pedido_anterior)) dias_entre_pedidos
FROM t


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

WITH ValorSemDesconto AS (
	SELECT
	ip.id_pedido,
	SUM(p.preco * ip.quantidade) preco_sem_desconto
FROM
	ItensPedido ip
	INNER JOIN Produtos p
		ON ip.id_produto = p.id_produto
GROUP BY 
	ip.id_pedido
)
SELECT
c.id_cliente		ID_CLIENTE,
c.nome				NOME_CLIENTE,
c.cidade			CIDADE_CLIENTE,
p.id_pedido			ID_PEDIDO,
p.data_pedido		DATA_PEDIDO,
p.valor				VALOR_PEDIDO,
vsd.preco_sem_desconto	VALOR_PEDIDO_SEM_DESCONTO
	JULIANDAY(p.data_pedido) - JULIANDAY(
	LAG(p.data_pedido)
	OVER (PARTITION BY c.id_cliente ORDER BY p.data_pedido)
	) DIAS_DESDE_PEDIDO_ANTERIOR
FROM
	Clientes c
	INNER JOIN Pedidos p
		ON c.id_cliente = p.id_cliente
	LEFT JOIN ValorSemDesconto vsd