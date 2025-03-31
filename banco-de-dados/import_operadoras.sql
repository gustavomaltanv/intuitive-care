CREATE DATABASE intuitive_care;

\c intuitive_care;

-- Uso de indice como PK para melhor performance
CREATE TABLE ic_operadoras (
    id SERIAL PRIMARY KEY,
    REGISTRO_OPERADORA VARCHAR(6) NOT NULL UNIQUE,
    CNPJ VARCHAR(14) NOT NULL,
    Razao_Social VARCHAR(140),
    Nome_Fantasia VARCHAR(140),
    Modalidade VARCHAR(2),
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

COPY ic_operadoras(REGISTRO_OPERADORA, CNPJ, Razao_Social, Nome_Fantasia, Modalidade, Logradouro,
                     Numero, Complemento, Bairro, Cidade, UF, CEP, DDD, Telefone, Fax,
                     Endereco_eletronico, Representante, Cargo_Representante,
                     Regiao_de_Comercializacao, Data_Registro_ANS)
FROM '/caminho/Relatorio_cadop.csv'
DELIMITER ','
CSV HEADER
ENCODING 'UTF8';

select * from ic_operadoras;