CREATE DATABASE testebimo;


-- Criação das tabelas normalizadas

CREATE TABLE Categoria 
(
  cId VARCHAR(30) PRIMARY KEY,
  cNome VARCHAR(50) NOT NULL CHECK (LENGTH(cNome) > 0),
  cTipo VARCHAR(20) CHECK (cTipo IN ('Produto', 'Curso')),
  bIsinactive BOOL DEFAULT FALSE
);

CREATE TABLE Plano (
    sid INT PRIMARY KEY,
    cNome VARCHAR(50) NOT NULL,
    cDescricao TEXT NOT NULL,
    fValor FLOAT NOT NULL,
    bIsinactive BOOL DEFAULT FALSE
);

CREATE TABLE Usuario 
( 
    cEmail VARCHAR(200) NOT NULL,  
    cTelefone VARCHAR(17) NOT NULL,  
    dDataNascimento DATE NOT NULL,  
    cNome VARCHAR(80) NOT NULL,  
    cCnpj VARCHAR(18),  
    cCpf VARCHAR(14),  
    sId SERIAL PRIMARY KEY,  
    cIdHash VARCHAR(40),
    cImgFireBase VARCHAR(300) DEFAULT 'Nao informado',
    idPlano INT,
    cSobrenome VARCHAR(50) NOT NULL,  
    cLinkLinkedin VARCHAR(300) DEFAULT 'Nao informado',
    cEspecialidadeProfissional VARCHAR(300) DEFAULT 'Nao informado',
    dDataCriacao DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (idPlano) REFERENCES Plano (sId),
    UNIQUE (cCnpj, cCpf)
);

CREATE TABLE Endereco 
( 
    cCep VARCHAR(10), 
    cBairro VARCHAR(50),  
    cPais VARCHAR(30) DEFAULT 'BR',  
    iNumero INT CHECK (iNumero > 0),  
    cRua VARCHAR(150) NOT NULL,  
    sId SERIAL PRIMARY KEY,  
    idUsuario INT,
    cEstado VARCHAR(30),
    FOREIGN KEY (idUsuario) REFERENCES Usuario (sId)
); 

CREATE TABLE Produto 
( 
    cNome VARCHAR(80) NOT NULL,  
    sId SERIAL PRIMARY KEY,  
    fValor FLOAT CHECK (fValor >= 0) NOT NULL,  
    cDescricao VARCHAR(400),  
    dDataCriacao DATE DEFAULT CURRENT_DATE,
    cImgFireBase VARCHAR(300) DEFAULT 'Nao informado',
    cUserName VARCHAR(50),
    cEstado VARCHAR(20) DEFAULT 'Não informado' CHECK (cEstado IN ('Novo', 'Usado', 'Seminovo', 'Não informado')),
    idUsuario INT NOT NULL,
    idCategoria VARCHAR(30) NOT NULL,
    FOREIGN KEY (idUsuario) REFERENCES Usuario (sId),
    FOREIGN KEY (idCategoria) REFERENCES Categoria (cId)
); 

CREATE TABLE Curso 
( 
    sId INT PRIMARY KEY,
    bStatus BOOL NOT NULL DEFAULT TRUE,
    cDescricao VARCHAR(300),
    cDuracao VARCHAR(10) NOT NULL,
    cCertificacao VARCHAR(300),
    cNome VARCHAR(80) NOT NULL,
    fValor FLOAT CHECK (fValor >= 0) NOT NULL,
    iNumeroInscricao INT NOT NULL,
    idCategoria VARCHAR(30) NOT NULL,
    cUrlFoto VARCHAR(500),
    bIsinactive BOOL DEFAULT FALSE,
    UNIQUE (iNumeroInscricao),
    FOREIGN KEY (idCategoria) REFERENCES Categoria (cId)
);

CREATE TABLE Pedido 
( 
    dData DATE DEFAULT CURRENT_DATE,
    sId SERIAL PRIMARY KEY,  
    fValorTotal FLOAT CHECK (fValorTotal >= 0) NOT NULL,  
    cStatus VARCHAR(30) DEFAULT 'pendente' CHECK (cStatus IN ('Pagamento pendente', 'Pago', 'Cancelado', 'Em andamento', 'Entregue', 'Erro')),  
    idUsuario INT NOT NULL,
    cTipoPagamento VARCHAR(8) CHECK (cTipoPagamento IN ('Debito','Credito','Pix','Dinheiro','Boleto')),
    FOREIGN KEY (idUsuario) REFERENCES Usuario (sId)
); 

CREATE TABLE ItemPedido
(
    sId SERIAL PRIMARY KEY,
    iQuantidade INT CHECK (iQuantidade > 0) NOT NULL,
    fValor FLOAT CHECK (fValor >= 0) NOT NULL,
    idPedido INT NOT NULL,
    idProduto INT NOT NULL,
    FOREIGN KEY (idPedido) REFERENCES Pedido (sId),
    FOREIGN KEY (idProduto) REFERENCES Produto (sId)
);

CREATE TABLE ia_tests (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    nome_empresa VARCHAR(100),
    uf CHAR(2) NOT NULL,
    porte_empresa VARCHAR(50) NOT NULL,
    capital_social INT,
    municipios VARCHAR(100),
    cnaes VARCHAR(100),
    natureza_juridica VARCHAR(50),
    ano_inicio_ativ INT,
    mes_inicio_ativ INT,
    dia_inicio_ativ INT,
    response TEXT
);
