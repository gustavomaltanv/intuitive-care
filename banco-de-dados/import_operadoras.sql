CREATE DATABASE db_intuitive_care
WITH ENCODING 'UTF8'
LC_COLLATE 'pt_BR.UTF-8'
LC_CTYPE 'pt_BR.UTF-8'
TEMPLATE template0;

\c db_intuitive_care;

-- Realizando a primeira criação da tabela, import dos dados para posterior normalização
CREATE TABLE IF NOT EXISTS ic_operadoras (
    id SERIAL PRIMARY KEY,
    REGISTRO_OPERADORA VARCHAR(6) NOT NULL UNIQUE,
    CNPJ VARCHAR(14) NOT NULL,
    Razao_Social VARCHAR(140),
    Nome_Fantasia VARCHAR(140),
    Modalidade VARCHAR(40),
    Logradouro VARCHAR(40),
    Numero VARCHAR(20),
    Complemento VARCHAR(40),
    Bairro VARCHAR(30),
    Cidade VARCHAR(30),
    UF VARCHAR(2),
    CEP VARCHAR(8),
    DDD VARCHAR(4),
    Telefone VARCHAR(20),
    Fax VARCHAR(20),
    Endereco_eletronico VARCHAR(255),
    Representante VARCHAR(50),
    Cargo_Representante VARCHAR(40),
    Regiao_de_Comercializacao NUMERIC(1),
    Data_Registro_ANS DATE
);

-- Indice adicional
CREATE INDEX idx_ic_operadoras_registro ON ic_operadoras(REGISTRO_OPERADORA);

COMMENT ON COLUMN ic_operadoras.REGISTRO_OPERADORA IS 'Registro de operadora de plano privado de assistência à saúde concedido pela ANS à pessoa jurídica para operação no setor de saúde suplementar';
COMMENT ON COLUMN ic_operadoras.CNPJ IS 'CNPJ da Operadora';
COMMENT ON COLUMN ic_operadoras.Razao_Social IS 'Razão Social da Operadora';
COMMENT ON COLUMN ic_operadoras.Nome_Fantasia IS 'Nome Fantasia da Operadora';
COMMENT ON COLUMN ic_operadoras.Modalidade IS 'Classificação das operadoras de planos privados de assistência à saúde de acordo com seu estatuto jurídico';
COMMENT ON COLUMN ic_operadoras.Logradouro IS 'Endereço da Sede da Operadora';
COMMENT ON COLUMN ic_operadoras.Numero IS 'Número do Endereço da Sede da Operadora';
COMMENT ON COLUMN ic_operadoras.Complemento IS 'Complemento do Endereço da Sede da Operadora';
COMMENT ON COLUMN ic_operadoras.Bairro IS 'Bairro do Endereço da Sede da Operadora';
COMMENT ON COLUMN ic_operadoras.Cidade IS 'Cidade do Endereço da Sede da Operadora';
COMMENT ON COLUMN ic_operadoras.UF IS 'Estado do Endereço da Sede da Operadora';
COMMENT ON COLUMN ic_operadoras.CEP IS 'CEP do Endereço da Sede da Operadora';
COMMENT ON COLUMN ic_operadoras.DDD IS 'Código de DDD da Operadora';
COMMENT ON COLUMN ic_operadoras.Telefone IS 'Numero de Telefone da Operadora';
COMMENT ON COLUMN ic_operadoras.Fax IS 'Numero de Fax da Operadora';
COMMENT ON COLUMN ic_operadoras.Endereco_eletronico IS 'e-mail da Operadora';
COMMENT ON COLUMN ic_operadoras.Representante IS 'Representante Legal da Operadora';
COMMENT ON COLUMN ic_operadoras.Cargo_Representante IS 'Cargo do Representante Legal da Operadora';
COMMENT ON COLUMN ic_operadoras.Regiao_de_Comercializacao IS 'Área onde a operadora de plano privado de assistência à saúde comercializa ou disponibiliza seu plano de saúde, nos termos do Anexo I da Resolução Normativa nº 209/2009, da ANS';
COMMENT ON COLUMN ic_operadoras.Data_Registro_ANS IS 'Data do Registro da Operadora na ANS (formato AAAA-MM-DD)';


-- Criando a normalização da tabela
CREATE TABLE regiao_comercializacao (
    id SERIAL PRIMARY KEY,
    descricao VARCHAR(100)
);

CREATE TABLE operadoras (
    id SERIAL PRIMARY KEY,
    registro_operadora VARCHAR(6) NOT NULL UNIQUE,
    cnpj VARCHAR(14) NOT NULL,
    razao_social VARCHAR(140),
    nome_fantasia VARCHAR(140),
    modalidade VARCHAR(40),
    data_registro_ans DATE,
    regiao_comercializacao_id INTEGER REFERENCES regiao_comercializacao(id)
);


CREATE TABLE enderecos (
    id SERIAL PRIMARY KEY,
    operadora_id INTEGER REFERENCES operadoras(id) ON DELETE CASCADE,
    logradouro VARCHAR(40),
    numero VARCHAR(20),
    complemento VARCHAR(40),
    bairro VARCHAR(30),
    cidade VARCHAR(30),
    uf VARCHAR(2),
    cep VARCHAR(8),
    ddd VARCHAR(4),
    telefone VARCHAR(20),
    fax VARCHAR(20)
);

CREATE TABLE representantes (
    id SERIAL PRIMARY KEY,
    operadora_id INTEGER REFERENCES operadoras(id) ON DELETE CASCADE,
    nome VARCHAR(50),
    cargo VARCHAR(40)
);


CREATE TABLE contatos (
    id SERIAL PRIMARY KEY,
    operadora_id INTEGER REFERENCES operadoras(id) ON DELETE CASCADE,
    tipo_contato VARCHAR(20),
    contato VARCHAR(255)
);

-- Import do CSV
COPY ic_operadoras(REGISTRO_OPERADORA, CNPJ, Razao_Social, Nome_Fantasia, Modalidade, Logradouro,
                     Numero, Complemento, Bairro, Cidade, UF, CEP, DDD, Telefone, Fax,
                     Endereco_eletronico, Representante, Cargo_Representante,
                     Regiao_de_Comercializacao, Data_Registro_ANS)
FROM '/tmp/Projects/intuitive-care/banco-de-dados/dados/operadoras/Relatorio_cadop.csv'
DELIMITER ';'
CSV HEADER
ENCODING 'UTF8';

-- insert nas tabelas normalizadas

INSERT INTO operadoras (registro_operadora, cnpj, razao_social, nome_fantasia, modalidade, data_registro_ans)
SELECT REGISTRO_OPERADORA, CNPJ, Razao_Social, Nome_Fantasia, Modalidade, Data_Registro_ANS
FROM ic_operadoras;

INSERT INTO enderecos (operadora_id, logradouro, numero, complemento, bairro, cidade, uf, cep, ddd, telefone, fax)
SELECT o.id, i.Logradouro, i.Numero, i.Complemento, i.Bairro, i.Cidade, i.UF, i.CEP, i.DDD, i.Telefone, i.Fax
FROM ic_operadoras i
JOIN operadoras o ON i.REGISTRO_OPERADORA = o.registro_operadora;

INSERT INTO representantes (operadora_id, nome, cargo)
SELECT o.id, i.Representante, i.Cargo_Representante
FROM ic_operadoras i
JOIN operadoras o ON i.REGISTRO_OPERADORA = o.registro_operadora;

INSERT INTO contatos (operadora_id, tipo_contato, contato)
SELECT o.id, 'e-mail', i.Endereco_eletronico
FROM ic_operadoras i
JOIN operadoras o ON i.REGISTRO_OPERADORA = o.registro_operadora;


INSERT INTO regiao_comercializacao (descricao)
SELECT DISTINCT CASE
                    WHEN Regiao_de_Comercializacao = 6 THEN 'Região 6'
                    WHEN Regiao_de_Comercializacao = 4 THEN 'Região 4'
                    WHEN Regiao_de_Comercializacao = 1 THEN 'Região 1'
                    WHEN Regiao_de_Comercializacao = 5 THEN 'Região 5'
                    WHEN Regiao_de_Comercializacao = 2 THEN 'Região 2'
                    WHEN Regiao_de_Comercializacao = 3 THEN 'Região 3'
                    ELSE 'Outros'
                 END AS descricao
FROM ic_operadoras;

UPDATE operadoras o
SET regiao_comercializacao_id = r.id
FROM regiao_comercializacao r
JOIN ic_operadoras i ON i.Regiao_de_Comercializacao = r.id
WHERE o.registro_operadora = i.REGISTRO_OPERADORA;

-- drop da tabela nao normalizada
DROP TABLE ic_operadoras;
