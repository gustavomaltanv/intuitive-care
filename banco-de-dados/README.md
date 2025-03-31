# Banco de Dados

## Importação e Transformação de Dados

Os scripts SQL utilizam o comando `COPY` para importar os dados do arquivo CSV para o banco de dados.

**OBS: deve-se rodar o script import_operadoras.sql antes do import_demo_contabeis.sql**

Pelo psql:
```
  sudo -u postgres psql -f ./import_operadoras.sql
  sudo -u postgres psql -f ./import_demo_contabeis.sql 
```


### Observações Importantes:
- A importação **não é dinâmica**, ou seja, o caminho do arquivo deve ser ajustado manualmente antes da execução.
- Portanto, certifique-se de que o caminho especificado no comando `COPY` corresponde ao local real do arquivo no sistema.

### Como Ajustar o Caminho do Arquivo:
No trecho de código abaixo, altere `CAMINHO/COMPLETO/DO/ARQUIVO.csv` para o diretório correto onde o arquivo CSV está localizado:

```sql
COPY ...
FROM 'CAMINHO/COMPLETO/DO/ARQUIVO.csv'
...;
```

Caso tenha dúvidas ou precise ajustar permissões para importar arquivos, consulte a documentação oficial do PostgreSQL sobre `COPY` e `psql`.

---
Para mais detalhes sobre a estrutura do banco de dados e as tabelas envolvidas, consulte os demais arquivos do projeto.

## Análise
```
analise-operadoras-trimestre.sql
analise-operadoras-ano.sql
```

Conectado ao DB criado, basta rodar as consultas.

<br>Considera-se: 
* último ano sendo 2024.
* último trimestre sendo o último que possuimos de informação.