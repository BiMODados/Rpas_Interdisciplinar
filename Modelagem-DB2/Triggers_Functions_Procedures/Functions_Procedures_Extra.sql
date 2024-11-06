--Função para verificar o total gasto por usuario
CREATE FUNCTION total_gasto_por_usuario(usuario_id INT)
RETURNS FLOAT AS $$
DECLARE
  total FLOAT;
BEGIN
  SELECT SUM(fValorTotal) INTO total
  FROM Pedido
  WHERE idUsuario = usuario_id;

  RETURN COALESCE(total, 0);
END;
$$ LANGUAGE plpgsql;

--Função contagem de produtos anuncioados por um usuário
CREATE FUNCTION contar_produtos_por_usuario(usuario_id INT)
RETURNS INT AS $$
DECLARE
  total_produtos INT;
BEGIN
  SELECT COUNT(*)
  INTO total_produtos
  FROM Produto
  WHERE idUsuario = usuario_id;

  RETURN COALESCE(total_produtos, 0);
END;
$$ LANGUAGE plpgsql;


--Procedure que inativa um plano especifico
CREATE PROCEDURE inativar_plano(plano_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE Plano 
  SET bIsinactive = TRUE 
  WHERE sid = plano_id;
  
  RAISE NOTICE 'Plano com ID % foi inativado.', plano_id;
END;
$$;

--Procedure que atualiza o status de um pedido
CREATE PROCEDURE atualizar_status_pedido(pedido_id INT, novo_status VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
  IF novo_status NOT IN ('Pagamento pendente', 'Pago', 'Cancelado', 'Em andamento', 'Entregue', 'Erro') THEN
    RAISE EXCEPTION 'Status inválido. Use um status permitido.';
  END IF;
  
  UPDATE Pedido 
  SET cStatus = novo_status 
  WHERE sId = pedido_id;
  
  RAISE NOTICE 'Status do pedido com ID % atualizado para %.', pedido_id, novo_status;
END;
$$;
