-- 3. Tabelas de Log Extras Usando Triggers
-- Vou criar mais três tabelas de log usando triggers para as tabelas Usuario, Endereco, e Curriculo.

-- a) Tabela de Log e Trigger para Usuario
CREATE TABLE LogUsuario (
    logId SERIAL PRIMARY KEY,
    sId INT,
    cEmail VARCHAR(200),
    cTelefone VARCHAR(17),
    cNome VARCHAR(80),
    cSobrenome VARCHAR(50),
    cCnpj VARCHAR(18),
    cCpf VARCHAR(14),
    cIdHash VARCHAR(40),
    cImgFireBase VARCHAR(300),
    idPlano INT,
    cLinkLinkedin VARCHAR(300),
    cEspecialidadeProfissional VARCHAR(300),
    dDataNascimento DATE,
    dDataCriacao DATE,
    cUsername VARCHAR(80),
    operacao VARCHAR(10),
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION LogUsuarioFunc() 
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO LogUsuario (sId, cEmail, cTelefone, cNome, cSobrenome, cCnpj, cCpf, cIdHash, cImgFireBase, idPlano, cLinkLinkedin, cEspecialidadeProfissional, dDataNascimento, dDataCriacao, cUsername, operacao)
        VALUES (NEW.sId, NEW.cEmail, NEW.cTelefone, NEW.cNome, NEW.cSobrenome, NEW.cCnpj, NEW.cCpf, NEW.cIdHash, NEW.cImgFireBase, NEW.idPlano, NEW.cLinkLinkedin, NEW.cEspecialidadeProfissional, NEW.dDataNascimento, NEW.dDataCriacao, NEW.cUsername 'INSERT');
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO LogUsuario (sId, cEmail, cTelefone, cNome, cSobrenome, cCnpj, cCpf, cIdHash, cImgFireBase, idPlano, cLinkLinkedin, cEspecialidadeProfissional, dDataNascimento, dDataCriacao, cUsername, operacao)
        VALUES (NEW.sId, NEW.cEmail, NEW.cTelefone, NEW.cNome, NEW.cSobrenome, NEW.cCnpj, NEW.cCpf, NEW.cIdHash, NEW.cImgFireBase, NEW.idPlano, NEW.cLinkLinkedin, NEW.cEspecialidadeProfissional, NEW.dDataNascimento, NEW.dDataCriacao, NEW.cUsername 'UPDATE');
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO LogUsuario (sId, cEmail, cTelefone, cNome, cSobrenome, cCnpj, cCpf, cIdHash, cImgFireBase, idPlano, cLinkLinkedin, cEspecialidadeProfissional, dDataNascimento, dDataCriacao, cUsername, operacao)
        VALUES (OLD.sId, OLD.cEmail, OLD.cTelefone, OLD.cNome, OLD.cSobrenome, OLD.cCnpj, OLD.cCpf, OLD.cIdHash, OLD.cImgFireBase, OLD.idPlano, OLD.cLinkLinkedin, OLD.cEspecialidadeProfissional, OLD.dDataNascimento, OLD.dDataCriacao, OLD.cUsername 'DELETE');
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER LogUsuarioTrigger
AFTER INSERT OR UPDATE OR DELETE ON Usuario
FOR EACH ROW EXECUTE FUNCTION LogUsuarioFunc();

-- b) Tabela de Log e Trigger para ItemPedido:

CREATE TABLE LogItemPedido (
    logId SERIAL PRIMARY KEY,
    sId INT,
    iQuantidade INT,
    fValor FLOAT,
    idPedido INT,
	idProduto INT,
	operacao VARCHAR(10),
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION LogItemPedidoFunc() 
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO LogItemPedido (sId, iQuantidade, fValor, idPedido, idProduto, operacao)
        VALUES (NEW.sId, NEW.iQuantidade, NEW.fValor, NEW.idPedido, NEW.idProduto, 'INSERT');
    ELSIF (TG_OP = 'UPDATE') THEN	
        INSERT INTO LogItemPedido (sId, iQuantidade, fValor, idPedido, idProduto, operacao)
        VALUES (NEW.sId, NEW.iQuantidade, NEW.fValor, NEW.idPedido, NEW.idProduto, 'UPDATE');
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO LogItemPedido (sId, iQuantidade, fValor, idPedido, idProduto, operacao)
        VALUES (OLD.sId, OLD.iQuantidade, OLD.fValor, OLD.idPedido, OLD.idProduto, 'DELETE');
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER LogItemPedidoTrigger
AFTER INSERT OR UPDATE OR DELETE ON ItemPedido
FOR EACH ROW EXECUTE FUNCTION LogItemPedidoFunc();

-- c) Tabela de Log e Trigger para Endereco

CREATE TABLE LogEndereco (
    logId SERIAL PRIMARY KEY,
    sId INT,
    cCep VARCHAR(10),
    cBairro VARCHAR(60),
    cPais VARCHAR(60),
    iNumero INT,
    cRua VARCHAR(60),
    idUsuario INT,
    operacao VARCHAR(10),
    cEstado VARCHAR(50),
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION LogEnderecoFunc() 
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO LogEndereco (sId, cCep, cBairro, cPais, iNumero, cRua, idUsuario, operacao, cEstado)
        VALUES (NEW.sId, NEW.cCep, NEW.cBairro, NEW.cPais, NEW.iNumero, NEW.cRua, NEW.idUsuario, 'INSERT', NEW.cEstado);
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO LogEndereco (sId, cCep, cBairro, cPais, iNumero, cRua, idUsuario, operacao, cEstado)
        VALUES (NEW.sId, NEW.cCep, NEW.cBairro, NEW.cPais, NEW.iNumero, NEW.cRua, NEW.idUsuario, 'UPDATE', NEW.cEstado);
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO LogEndereco (sId, cCep, cBairro, cPais, iNumero, cRua, idUsuario, operacao, cEstado)
        VALUES (OLD.sId, OLD.cCep, OLD.cBairro, OLD.cPais, OLD.iNumero, OLD.cRua, OLD.idUsuario, 'DELETE', OLD.cEstado);
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER LogEnderecoTrigger
AFTER INSERT OR UPDATE OR DELETE ON Endereco
FOR EACH ROW EXECUTE FUNCTION LogEnderecoFunc();
