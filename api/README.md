# API

Para rodar a aplicação Python localmente:

```bash
cd servidor/
pip install -r requirements.txt
uvicorn app.main:app --reload
```

Para rodar a aplicação Vue.js localmente:
```bash
cd front/
npm install
npm run dev
```

## FastAPI
A aplicação python foi desenvolvida com FastAPI, posusi os seguintes endpoints:

```python
/ # verificar se está ativo
/registros/busca/?termo= # busca por termo globalmente
/registros/busca/campo/?campo=&termo= # busca por termo específico
/registros/cabecalho/ # obter cabeçalhos
```

[Coleção do Postman](./ServidorFastAPI.postman_collection.json)

## Front
Desenvolvido com Vue.js + TailwindCSS.
<br>Requisições ao servidor FastAPI.