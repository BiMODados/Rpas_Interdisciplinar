CREATE TABLE Produto 
( 
  sId SERIAL PRIMARY KEY,  
  cNome VARCHAR(80) NOT NULL,  
  fValor FLOAT CHECK (fValor >= 0) NOT NULL,  
  cEstado VARCHAR(20) DEFAULT 'Não informado' CHECK (cEstado IN ('Novo', 'Usado', 'Seminovo', 'Não informado')),  
  cDescricao VARCHAR(400) NOT NULL, 
  dDataCriacao DATE DEFAULT CURRENT_DATE, 
  idUsuario INT NOT NULL,  
  idCategoriaProduto INT NOT NULL
); 

CREATE TABLE Item 
( 
  sId SERIAL PRIMARY KEY,  
  fValor FLOAT CHECK (fValor >= 0) NOT NULL,  
  iQuantidade INT CHECK (iQuantidade > 0) NOT NULL,
  idPedido INT NOT NULL
); 

CREATE TABLE Pedido 
( 
  sId SERIAL PRIMARY KEY,  
  dData DATE DEFAULT CURRENT_DATE,    
  fValorTotal FLOAT CHECK (fValorTotal >= 0) NOT NULL,  
  cStatus VARCHAR(30) DEFAULT 'pendente' CHECK (cStatus IN ('Pagamento pendente', 'Pago', 'Cancelado', 'Em andamento', 'Entregue', 'Erro')),  
  cTipoPagamento VARCHAR(8) CHECK (cTipoPagamento IN ('Debito', 'Credito', 'Pix', 'Dinheiro', 'Boleto')),
  idUsuario INT NOT NULL 
); 

CREATE TABLE Endereco 
( 
  sId SERIAL PRIMARY KEY,  
  cCep VARCHAR(10) NOT NULL ,  
  cBairro VARCHAR(50) NOT NULL,   
  iNumero INT CHECK (iNumero > 0) NOT NULL,  
  cEstado VARCHAR(30) NOT NULL,  
  cRua VARCHAR(150) NOT NULL,  
  idUsuario INT NOT NULL
); 

CREATE TABLE Usuario 
( 
  sId SERIAL PRIMARY KEY,  
  cEmail VARCHAR(200) NOT NULL CHECK (cEmail LIKE '%@%'),  
  cTelefone VARCHAR(17) NOT NULL,  
  dDataNascimento DATE NOT NULL CHECK (dDataNascimento <= CURRENT_DATE),  
  cNome VARCHAR(80) NOT NULL,  
  cSenha VARCHAR(80) NOT NULL CHECK (LENGTH(cSenha) > 8),  
  cCnpj VARCHAR(14) CHECK (LENGTH(cCnpj) = 14),  
  cCpf VARCHAR(11) CHECK (LENGTH(cCpf) = 11),  
  cSobrenome VARCHAR(50) NOT NULL,  
  dDataCriacao DATE DEFAULT CURRENT_DATE, 
  idPlano INT NOT NULL, 
  UNIQUE (cCnpj, cCpf)
); 

CREATE TABLE Midia 
( 
  sId SERIAL PRIMARY KEY,  
  idProduto INT NOT NULL, 
  cUrlFoto VARCHAR(1000) NOT NULL CHECK (cUrlFoto LIKE 'http%')  
); 

-- TABELAS ADMINISTRATIVAS
CREATE TABLE Administrador
( 
  sId SERIAL PRIMARY KEY, 
  cNome VARCHAR(30) NOT NULL CHECK (LENGTH(cNome) > 0), 
  cEmail VARCHAR(200) NOT NULL CHECK (cEmail LIKE '%@%'), 
  cSenha VARCHAR(16) NOT NULL CHECK (LENGTH(cSenha) >= 8)  
); 

CREATE TABLE Curso 
( 
  sId SERIAL PRIMARY KEY,  
  cDescricao VARCHAR(500) NOT NULL,
  cDuracao VARCHAR(10) NOT NULL,
  cCertificacao VARCHAR(300), 
  cNome VARCHAR(80) NOT NULL,  
  fValor FLOAT NOT NULL CHECK (fValor >= 0),  
  bStatus BOOLEAN NOT NULL DEFAULT TRUE,  
  iNumeroInscricao INT NOT NULL,
  idCategoriaCurso INT NOT NULL,   
  UNIQUE (iNumeroInscricao)
); 

CREATE TABLE Plano
( 
  sId SERIAL PRIMARY KEY, 
  cNome VARCHAR(6) NOT NULL, 
  cDescricao VARCHAR(500) NOT NULL,  
  fValor FLOAT NOT NULL CHECK (fValor >= 0)
); 

CREATE TABLE CategoriaProduto 
( 
  sId SERIAL PRIMARY KEY,  
  cNome VARCHAR(50) NOT NULL CHECK (LENGTH(cNome) > 0)
); 

CREATE TABLE CategoriaCurso 
( 
  sId SERIAL PRIMARY KEY,  
  cNome VARCHAR(30) NOT NULL CHECK (LENGTH(cNome) > 0)
);

CREATE TABLE MidiaCurso
(
  sId SERIAL PRIMARY KEY,  
  idCurso INT NOT NULL,  
  cUrlFoto VARCHAR(1000) NOT NULL CHECK (cUrlFoto LIKE 'http%')  
);

-- Relações de chave estrangeira (FK)
ALTER TABLE Usuario ADD FOREIGN KEY (idPlano) REFERENCES Plano (sId);
ALTER TABLE Pedido ADD FOREIGN KEY (idUsuario) REFERENCES Usuario (sId);
ALTER TABLE Endereco ADD FOREIGN KEY (idUsuario) REFERENCES Usuario (sId);
ALTER TABLE Curso ADD FOREIGN KEY (idCategoriaCurso) REFERENCES CategoriaCurso (sId);
ALTER TABLE Item ADD FOREIGN KEY (idPedido) REFERENCES Pedido (sId);
ALTER TABLE Midia ADD FOREIGN KEY (idProduto) REFERENCES Produto (sId);
ALTER TABLE Produto ADD FOREIGN KEY (idUsuario) REFERENCES Usuario (sId);
ALTER TABLE Produto ADD FOREIGN KEY (idCategoriaProduto) REFERENCES CategoriaProduto (sId);
ALTER TABLE MidiaCurso ADD FOREIGN KEY (idCurso) REFERENCES Curso (sId);


--ALTERAÇAO NAS TABELAS QUE FORAM PEDIDAS PELO SEGUNDO ANO
	
-- ADICIONANDO CAMPOS NA TABELA CATEGORIACURSO
ALTER TABLE CategoriaCurso
	ADD Transaction_made boolean DEFAULT FALSE;
ALTER TABLE CategoriaCurso
	ADD bIsUpdated boolean DEFAULT FALSE;
ALTER TABLE CategoriaCurso
	ADD bIsinactive boolean DEFAULT FALSE;

-- ADICIONANDO CAMPOS NA TABELA CATEGORIAPRODUTO
ALTER TABLE CategoriaProduto
	ADD Transaction_made boolean DEFAULT FALSE;
ALTER TABLE CategoriaProduto
	ADD bIsUpdated boolean DEFAULT FALSE;
ALTER TABLE CategoriaProduto
	ADD bIsInactive boolean DEFAULT FALSE;

-- ADICIONANDO CAMPOS NA TABELA CURSO
ALTER TABLE Curso
	ADD Transaction_made boolean DEFAULT FALSE;
ALTER TABLE Curso
	ADD bIsUpdated boolean DEFAULT FALSE;
ALTER TABLE Curso
	ADD bIsInactive boolean DEFAULT FALSE;

-- ADICIONANDO CAMPOS NA TABELA PLANO
ALTER TABLE Plano
	ADD Transaction_made boolean DEFAULT FALSE;
ALTER TABLE Plano
	ADD bIsUpdated boolean DEFAULT FALSE;
ALTER TABLE Plano
	ADD bIsInactive boolean DEFAULT FALSE;

-- ADICIONANDO CAMPOS NA TABELA MIDIACURSO
ALTER TABLE MidiaCurso
	ADD Transaction_made boolean DEFAULT FALSE;
ALTER TABLE MidiaCurso
	ADD bIsUpdated boolean DEFAULT FALSE;
ALTER TABLE MidiaCurso
	ADD bIsInactive boolean DEFAULT FALSE;

