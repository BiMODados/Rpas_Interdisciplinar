-- Procedures para Transações
-- Criei três procedures: uma para inserir um novo pedido, outra para atualizar o preço de um produto, e uma terceira para deletar um usuário e seus dados relacionados.

-- a) Inserir um Novo Pedido

CREATE OR REPLACE PROCEDURE InserirPedido(
    IN p_idUsuario INT,
    IN p_fValorTotal FLOAT,
    IN p_cStatus VARCHAR(30),
    IN p_cTipoPagamento VARCHAR(8)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Pedido (idUsuario, fValorTotal, cTipoPagamento, cStatus)
    VALUES (p_idUsuario, p_fValorTotal, p_cTipoPagamento, p_cStatus);
END;
$$;

-- b) Atualizar Preço de um Produto

CREATE OR REPLACE PROCEDURE AtualizarPrecoProduto(
    IN p_idProduto INT,
    IN p_novoValor FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Produto
    SET fValor = p_novoValor
    WHERE sId = p_idProduto;
END;
$$;

-- c) Deletar um Usuário e seus Dados Relacionados

CREATE OR REPLACE PROCEDURE DeletarUsuario(
    IN p_idUsuario INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Endereco WHERE idUsuario = p_idUsuario;
    DELETE FROM Pedido WHERE idUsuario = p_idUsuario;
    DELETE FROM Produto WHERE idUsuario = p_idUsuario
    DELETE FROM Usuario WHERE sId = p_idUsuario;
END;
$$;

-- 2. Triggers para Criar Tabelas de Log
-- Criei três Triggers: uma para a tabela Produto, Pedido e Curso, todas logam nas respectivas tabelas os eventos de INSERT, DELETE e UPDATE

-- a) Tabela de Log e Trigger para Produto

CREATE TABLE LogProduto (
    logId SERIAL PRIMARY KEY,
    sId INT,
    cNome VARCHAR(80),
    fValor FLOAT,
    cDescricao VARCHAR(400),
    dDataCriacao DATE,
    cImgFireBase VARCHAR(300),
    cUserName VARCHAR(50),
    cEstado VARCHAR(20),
    idUsuario INT,
    idCategoria INT,
    operacao VARCHAR(10),
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION LogProdutoFunc() 
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO LogProduto (sId, cNome, fValor, cDescricao, dDataCriacao, cImgFireBase, cUserName, cEstado, idUsuario, idCategoria, operacao)
        VALUES (NEW.sId, NEW.cNome, NEW.fValor, NEW.cDescricao, NEW.dDataCriacao, NEW.cImgFireBase, NEW.cUserName, NEW.cEstado, NEW.idUsuario, NEW.idCategoria, 'INSERT');
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO LogProduto (sId, cNome, fValor, cDescricao, dDataCriacao, cImgFireBase, cUserName, cEstado, idUsuario, idCategoria, operacao)
        VALUES (NEW.sId, NEW.cNome, NEW.fValor, NEW.cDescricao, NEW.dDataCriacao, NEW.cImgFireBase, NEW.cUserName, NEW.cEstado, NEW.idUsuario, NEW.idCategoria, 'UPDATE');
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO LogProduto (sId, cNome, fValor, cDescricao, dDataCriacao, cImgFireBase, cUserName, cEstado, idUsuario, idCategoria, operacao)
        VALUES (OLD.sId, OLD.cNome, OLD.fValor, OLD.cDescricao, OLD.dDataCriacao, OLD.cImgFireBase, OLD.cUserName, OLD.cEstado, OLD.idUsuario, OLD.idCategoria, 'DELETE');
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER LogProdutoTrigger
AFTER INSERT OR UPDATE OR DELETE ON Produto
FOR EACH ROW EXECUTE FUNCTION LogProdutoFunc();

-- b) Tabela de Log e Trigger para Pedido

CREATE TABLE LogPedido (
    logId SERIAL PRIMARY KEY,
    sId INT,
    dData DATE,
    fValorTotal FLOAT,
    cStatus VARCHAR(30),
    idUsuario INT,
    operacao VARCHAR(10),
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION LogPedidoFunc() 
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO LogPedido (sId, dData, fValorTotal, cStatus, idUsuario, operacao)
        VALUES (NEW.sId, NEW.dData, NEW.fValorTotal, NEW.cStatus, NEW.idUsuario, 'INSERT');
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO LogPedido (sId, dData, fValorTotal, cStatus, idUsuario, operacao)
        VALUES (NEW.sId, NEW.dData, NEW.fValorTotal, NEW.cStatus, NEW.idUsuario, 'UPDATE');
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO LogPedido (sId, dData, fValorTotal, cStatus, idUsuario, operacao)
        VALUES (OLD.sId, OLD.dData, OLD.fValorTotal, OLD.cStatus, OLD.idUsuario, 'DELETE');
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER LogPedidoTrigger
AFTER INSERT OR UPDATE OR DELETE ON Pedido
FOR EACH ROW EXECUTE FUNCTION LogPedidoFunc();

-- c) Tabela de Log e Trigger para Curso

CREATE TABLE LogCurso (
    logId SERIAL PRIMARY KEY,
    sId INT,
    cDescricao VARCHAR(300),
    cDuracao VARCHAR(10),
    cCertificacao VARCHAR(300),
    cNome VARCHAR(80),
    fValor FLOAT,
    idCategoria varchar(40),
    iNumeroInscricao INT,
    bIsInactive BOOL DEFAULT FALSE,
    operacao VARCHAR(10),
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION LogCursoFunc() 
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO LogCurso (sId, cDescricao, cDuracao, cCertificacao, cNome, fValor, idCategoria, iNumeroInscricao, bIsInactive, operacao)
        VALUES (NEW.sId, NEW.cDescricao, NEW.cDuracao, NEW.cCertificacao, NEW.cNome, NEW.fValor, NEW.idCategoria, NEW.iNumeroInscricao, NEW.bIsInactive, 'INSERT');
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO LogCurso (sId, cDescricao, cDuracao, cCertificacao, cNome, fValor, idCategoria, iNumeroInscricao, bIsInactive, operacao)
        VALUES (NEW.sId, NEW.cDescricao, NEW.cDuracao, NEW.cCertificacao, NEW.cNome, NEW.fValor, NEW.idCategoria, NEW.iNumeroInscricao, NEW.bIsInactive, 'UPDATE');
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO LogCurso (sId, cDescricao, cDuracao, cCertificacao, cNome, fValor, idCategoria, iNumeroInscricao, bIsInactive, operacao)
        VALUES (OLD.sId, OLD.cDescricao, OLD.cDuracao, OLD.cCertificacao, OLD.cNome, OLD.fValor, OLD.idCategoria, OLD.iNumeroInscricao, OLD.bIsInactive, 'DELETE');
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER LogCursoTrigger
AFTER INSERT OR UPDATE OR DELETE ON Curso
FOR EACH ROW EXECUTE FUNCTION LogCursoFunc();