import pandas as pd
from pathlib import Path

CSV_PATH = Path("data/Relatorio_cadop.csv")
print(CSV_PATH)

def carregar_dados():
    if not CSV_PATH.exists():
        raise FileNotFoundError("Arquivo CSV não encontrado!")

    return pd.read_csv(CSV_PATH, sep=";", dtype=str).fillna("")

df = carregar_dados()

def obter_cabecalho():
    return df.columns.tolist()

def buscar_registros(termo: str = None, offset: int = 0, limit: int = 20):
    if not termo:
        resultado = df.iloc[offset : offset + limit]
    else:
        resultado = df[df.apply(lambda row: row.astype(str).str.contains(termo, case=False, na=False).any(), axis=1)]

    return resultado.iloc[offset : offset + limit].to_dict(orient="records")


def buscar_por_campo(campo: str, termo: str, offset: int = 0, limit: int = 20):
    if campo not in df.columns:
        raise ValueError(f"Campo '{campo}' não encontrado no CSV!")

    resultado = df[df[campo].astype(str).str.contains(termo, case=False, na=False)]
    return resultado.iloc[offset : offset + limit].to_dict(orient="records")
