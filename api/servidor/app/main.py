from fastapi import FastAPI, Query, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from app.services import carregar_dados, buscar_registros, buscar_por_campo, obter_cabecalho

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def home():
    return {"message": "API está ativa!"}


@app.get("/registros/")
async def listar_registros(offset: int = 0, limit: int = 50):
    registros = buscar_registros(offset=offset, limit=limit)
    return {"total": len(registros), "registros": registros}

@app.get("/registros/busca/")
async def buscar_registros_api(termo: str = Query(..., description="Termo para busca"), offset: int = 0, limit: int = 50):
    registros = buscar_registros(termo=termo, offset=offset, limit=limit)
    return {"total": len(registros), "registros": registros}

@app.get("/registros/cabecalho/")
async def cabecalho():
    return {"colunas": obter_cabecalho()}

@app.get("/registros/busca/campo/")
async def buscar_por_campo_api(
    campo: str = Query(..., description="Nome da coluna para busca"),
    termo: str = Query(..., description="Termo para busca"),
    offset: int = 0,
    limit: int = 50
):
    registros = buscar_por_campo(campo, termo, offset, limit)
    return {"total": len(registros), "registros": registros}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000, reload=True)
