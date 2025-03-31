import pandas as pd
from tabula.io import read_pdf

import os
os.environ["CRYPTOGRAPHY_OPENSSL_NO_LEGACY"] = "1"
import pdfplumber

# preparar seleção do arquivo
arquivo_diretorio = "../output/download"
arquivo_nome = "Anexo_I_Rol_2021RN_465.2021_RN627L.2024.pdf"
arquivo = arquivo_diretorio + "/" + arquivo_nome

# saida csv
output_diretorio = "../output/csv"
output_nome = "dados_normalizados.csv"
output = output_diretorio + "/" + output_nome

def ler_legenda(arquivo_legenda, chaves):
    legenda_dict = {}

    with pdfplumber.open(arquivo_legenda) as pdf:
        for page in pdf.pages:
            text = page.extract_text()
            if "Legenda:" in text:
                legenda_texto = text.split("Legenda:")[-1]
                linhas = legenda_texto.split("\n")

                for linha in linhas:
                    for chave in chaves:
                        if linha.startswith(chave + ":"):
                            legenda_dict[chave] = linha.split(":", 1)[1].strip()

    return legenda_dict

# remove quebra de linha e substitui as abreviações pelas legendas
def normalizar_tabela(df, legenda_abreviacoes):
    df.columns = [col.replace("\r", " ").replace("\n", " ") for col in df.columns]

    for col in df.columns:
        df[col] = df[col].astype(str).str.replace("\r", " ").str.replace("\n", " ")

        for chave, significado in legenda_abreviacoes.items():
            df[col] = df[col].replace(chave, significado)

    return df


# pegar as legendas
chaves_legenda = ["OD", "AMB"]
legenda = ler_legenda(arquivo, chaves_legenda)

# total de páginas
with pdfplumber.open(arquivo) as pdf:
    total_paginas = len(pdf.pages)
    print(total_paginas)

# preparar as leituras para não ficar escrevendo os cabeçalhos
primeira_pagina = True
pagina = 1

while pagina <= total_paginas:
    df_list = read_pdf(arquivo, pages=str(pagina), multiple_tables=True, lattice=True)

    if not df_list:
        pagina += 1
        continue

    df = df_list[0]
    print("normalizacao da pagina: ", pagina)

    df = normalizar_tabela(df, legenda)

    if not df.empty:
        df.to_csv(output, mode="a", index=False, encoding="utf-8", header=primeira_pagina)
        if primeira_pagina:
            primeira_pagina = False

    pagina += 1

print(f"Dados salvos em {output}!")