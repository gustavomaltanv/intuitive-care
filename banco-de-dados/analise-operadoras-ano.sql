SELECT o.razao_social, SUM(dc.vl_saldo_final) AS total_despesa
FROM demonstracoes_contabeis dc
JOIN operadoras o ON dc.reg_ans = o.registro_operadora
JOIN descritivos d ON dc.descritivo_id = d.id
JOIN trimestre_contabil t ON dc.trimestre_id = t.id
WHERE d.descricao LIKE '%ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR%'
AND EXTRACT(YEAR FROM t.data_inicio) = 2024
GROUP BY o.razao_social
ORDER BY total_despesa DESC
LIMIT 10;