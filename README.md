# Desafio: Intuitive Care

## Realização dos testes de nivelamento - 2025.1
```
Tecnologias e plataformas a serem utilizadas:
	* Java
	* Python
	* SQL
	* Vue.js
	* Postman
```

### Testes a serem realizados:

**1. Teste de Web Scraping:** 
Será utilizado a linguagem Python ou Java. 
```
1.1. acesso ao site fornecido;
1.2. download dos Anexos I e II em PDF;
1.3. compactação dos arquivos.
```

**2. Teste de Transformação de Dados:**
Será utilizado a linguagem Python ou Java.
```
2.1. extrair os dados do Anexo I do teste anterior;
2.2. salvar os dados em um arquivo .csv;
2.3. compactar os arquivos .csv para "Teste_GustavoMalta.zip";
2.4. substituir as abreviações das colunas OD e AMB pelas descrições completas., conforme rodapé do arquivo.
```
**3. Teste de Banco de Dados:**
Será utilizado SQL.

* Preparação:
```
3.1. download dos arquivos dos últimos 2 anos do site fornecido;
3.2. download dos dados cadastrais no formato do site fornecido;
```

* Código:
```
3.3. criar queries para estruturar as tabelas dos arquivos.csv;
3.4. elaborar queries para importar o conteúdo dos arquivos;
3.5. query analítica para responder as seguintes perguntas:
	3.5.a. Quais 10 operadoras com maiores despesas em "EVENTOS/SINISTROS CONHECIDOS OU AVISADOS DE ASSITÊNCIA A SAÚDE MEDICO HOSPITALAR" no útimo trimestre?
	3.5.b. Quais as 10 operadoras com maiores despesas nessa categoria no último ano?
```


**4. Teste de API:**
Será utilizado o Vue.js para criação de uma interface web e conexão com um servidor Python.

* Preparação:
```
4.1. utilizar o csv do item 3.2.;
```

* Código:
```
4.2. criar um servidor com uma rota que realize uma busca textual na lista de cadastros de operadoras e retorne os registros mais relevantes;
4.3. elaborar uma coleção no Postman demonstrando os resultados.
```