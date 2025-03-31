\c db_intuitive_care;

-- Remover tabela existente para recriação
DROP TABLE IF EXISTS ic_demonstracoes_contabeis;
DROP TABLE IF EXISTS demonstracoes_contabeis;
DROP TABLE IF EXISTS descritivos;
DROP TABLE IF EXISTS trimestre_contabil;


-- tabela para inserção
CREATE TABLE ic_demonstracoes_contabeis (
    id SERIAL PRIMARY KEY,
    data DATE,
    reg_ans VARCHAR(6),
    cd_conta_contabil NUMERIC(9),
    descricao VARCHAR(150),
    vl_saldo_inicial VARCHAR(15),
    vl_saldo_final VARCHAR(15)
);

-- trimestres contábeis
CREATE TABLE trimestre_contabil (
    id SERIAL PRIMARY KEY,
    trimestre VARCHAR(10) NOT NULL,
    data_inicio DATE NOT NULL
);

INSERT INTO trimestre_contabil (trimestre, data_inicio)
VALUES 	('1T2023', '2023-01-01'), 
	('2T2023', '2023-04-01'), 
	('3T2023', '2023-07-01'), 
	('4T2023', '2023-10-01'),
	('1T2024', '2024-01-01'), 
	('2T2024', '2024-04-01'), 
	('3T2024', '2024-07-01'), 
	('4T2024', '2024-10-01');

-- descritivos
CREATE TABLE descritivos (
    id SERIAL PRIMARY KEY,
    descricao VARCHAR(150) NOT NULL UNIQUE
);

-- demonstrações contábeis
CREATE TABLE demonstracoes_contabeis (
    id SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    reg_ans VARCHAR(6) NOT NULL,
    cd_conta_contabil NUMERIC(9),
    descritivo_id INTEGER REFERENCES descritivos(id),
    vl_saldo_inicial NUMERIC(15,2),
    vl_saldo_final NUMERIC(15,2),
    trimestre_id INTEGER REFERENCES trimestre_contabil(id)
);

-- carregar os csv
COPY ic_demonstracoes_contabeis(data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final)
FROM '/tmp/Projects/intuitive-care/banco-de-dados/dados/demonstracoes-contabeis/1T2023.csv'
DELIMITER ';'
CSV HEADER
ENCODING 'UTF8';

COPY ic_demonstracoes_contabeis(data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final)
FROM '/tmp/Projects/intuitive-care/banco-de-dados/dados/demonstracoes-contabeis/2T2023.csv'
DELIMITER ';'
CSV HEADER
ENCODING 'UTF8';

COPY ic_demonstracoes_contabeis(data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final)
FROM '/tmp/Projects/intuitive-care/banco-de-dados/dados/demonstracoes-contabeis/3T2023.csv'
DELIMITER ';'
CSV HEADER
ENCODING 'UTF8';

COPY ic_demonstracoes_contabeis(data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final)
FROM '/tmp/Projects/intuitive-care/banco-de-dados/dados/demonstracoes-contabeis/4T2023.csv'
DELIMITER ';'
CSV HEADER
ENCODING 'UTF8';

COPY ic_demonstracoes_contabeis(data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final)
FROM '/tmp/Projects/intuitive-care/banco-de-dados/dados/demonstracoes-contabeis/1T2024.csv'
DELIMITER ';'
CSV HEADER
ENCODING 'UTF8';

COPY ic_demonstracoes_contabeis(data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final)
FROM '/tmp/Projects/intuitive-care/banco-de-dados/dados/demonstracoes-contabeis/2T2024.csv'
DELIMITER ';'
CSV HEADER
ENCODING 'UTF8';

COPY ic_demonstracoes_contabeis(data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final)
FROM '/tmp/Projects/intuitive-care/banco-de-dados/dados/demonstracoes-contabeis/3T2024.csv'
DELIMITER ';'
CSV HEADER
ENCODING 'UTF8';

COPY ic_demonstracoes_contabeis(data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final)
FROM '/tmp/Projects/intuitive-care/banco-de-dados/dados/demonstracoes-contabeis/4T2024.csv'
DELIMITER ';'
CSV HEADER
ENCODING 'UTF8';

-- normalização
UPDATE ic_demonstracoes_contabeis
SET vl_saldo_inicial = TO_NUMBER(REPLACE(vl_saldo_inicial, ',', '.'), '99999999999.99'),
    vl_saldo_final = TO_NUMBER(REPLACE(vl_saldo_final, ',', '.'), '99999999999.99');

INSERT INTO descritivos (descricao)
SELECT DISTINCT descricao
FROM ic_demonstracoes_contabeis;

INSERT INTO demonstracoes_contabeis (data, reg_ans, cd_conta_contabil, descritivo_id, vl_saldo_inicial, vl_saldo_final, trimestre_id)
SELECT 
    ic.data, 
    ic.reg_ans, 
    ic.cd_conta_contabil, 
    d.id, 
    ic.vl_saldo_inicial::NUMERIC(15,2),  -- Conversão explícita para NUMERIC
    ic.vl_saldo_final::NUMERIC(15,2),   -- Conversão explícita para NUMERIC
    t.id
FROM ic_demonstracoes_contabeis ic
JOIN descritivos d ON ic.descricao = d.descricao
JOIN trimestre_contabil t ON ic.data >= t.data_inicio AND ic.data < (t.data_inicio + INTERVAL '3 months');


DROP TABLE ic_demonstracoes_contabeis;

