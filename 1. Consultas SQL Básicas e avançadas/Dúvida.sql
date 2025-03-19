SELECT SUM(p.valor) total_gasto, p.id_cliente, c.id_cliente, c.nome
FROM Pedidos p, Clientes c
GROUP BY p.id_cliente

Nome de Ana se repete



SELECT SUM(p.valor) total_gasto, p.id_cliente, c.id_cliente, c.nome
FROM Pedidos p, Clientes c
GROUP BY c.id_cliente

O valor total de todas as compras repete