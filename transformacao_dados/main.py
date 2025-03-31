import os
import configparser
import zipfile
from tabula.io import read_pdf
from util.logger_util import LoggerUtil

os.environ["CRYPTOGRAPHY_OPENSSL_NO_LEGACY"] = "1"
import pdfplumber
import re

config = configparser.ConfigParser()
config.read('config/config.ini')

logger_util = LoggerUtil('config/config.ini')
logger = logger_util.get_logger()

arquivo_diretorio = config.get('INPUT', 'arquivo_diretorio')
arquivo_nome = config.get('INPUT', 'arquivo_nome')
arquivo = f"{arquivo_diretorio}/{arquivo_nome}"

output_diretorio = config.get('OUTPUT', 'output_diretorio')
output_nome = config.get('OUTPUT', 'output_nome')
output = f"{output_diretorio}/{output_nome}"

os.makedirs(arquivo_diretorio, exist_ok=True)
os.makedirs(output_diretorio, exist_ok=True)


def ler_legenda(arquivo_legenda, chaves):
    legenda_dict = {}
    logger.info(f"Extraindo legendas das chaves: {chaves}")

    with pdfplumber.open(arquivo_legenda) as pdf:
        for page in pdf.pages:
            text = page.extract_text()
            if not text:
                continue

            if "Legenda:" in text:
                legenda_texto = text.split("Legenda:")[-1]
                linhas = legenda_texto.split("\n")

                for i, linha in enumerate(linhas):
                    for chave in chaves:
                        padrao = rf"^{re.escape(chave)}:\s*(.+?)(?=\s*\w+:|$)"
                        match = re.search(padrao, linha)
                        if match:
                            legenda_dict[chave] = match.group(1).strip()
                            logger.debug(f"Legenda encontrada: {chave} = {legenda_dict[chave]}")

    logger.info(f"Legendas extraídas: {legenda_dict}")
    return legenda_dict


def normalizar_tabela(df, legenda_abreviacoes):
    logger.info("Iniciando normalização da tabela")
    df.columns = [col.replace("\r", " ").replace("\n", " ") for col in df.columns]
    logger.debug(f"Colunas normalizadas: {df.columns.tolist()}")

    for col in df.columns:
        df[col] = df[col].astype(str).str.replace("\r", " ").str.replace("\n", " ")

        for chave, significado in legenda_abreviacoes.items():
            df[col] = df[col].replace(chave, significado)
            logger.debug(f"Substituída abreviação '{chave}' por '{significado}' na coluna '{col}'")

    logger.info("Normalização da tabela concluída")
    return df


def main():
    logger.info(f"Iniciando processamento do arquivo: {arquivo}")

    os.makedirs(output_diretorio, exist_ok=True)

    chaves_legenda = ["OD", "AMB"]
    legenda = ler_legenda(arquivo, chaves_legenda)

    with pdfplumber.open(arquivo) as pdf:
        total_paginas = len(pdf.pages)
        logger.info(f"Total de páginas no PDF: {total_paginas}")

    primeira_pagina = True
    pagina = 1

    while pagina <= total_paginas:
        logger.info(f"Processando página {pagina} de {total_paginas}")

        try:
            df_list = read_pdf(arquivo, pages=str(pagina), multiple_tables=True, lattice=True)

            if not df_list:
                logger.warning(f"Nenhuma tabela encontrada na página {pagina}")
                pagina += 1
                continue

            df = df_list[0]
            logger.info(f"Iniciando normalização da página: {pagina}")

            df = normalizar_tabela(df, legenda)

            if not df.empty:
                df.to_csv(output, mode="a", index=False, encoding="utf-8", header=primeira_pagina)
                logger.info(f"Dados da página {pagina} salvos em {output}")

                if primeira_pagina:
                    primeira_pagina = False
                    logger.debug("Primeira página processada, próximas serão anexadas sem cabeçalho")
            else:
                logger.warning(f"DataFrame vazio após normalização na página {pagina}")

        except Exception as e:
            logger.error(f"Erro ao processar página {pagina}: {str(e)}")

        pagina += 1

    logger.info(f"Processamento concluído. Todos os dados foram salvos em {output}")

    if config.has_section('ZIP') and config.has_option('ZIP', 'zip_folder') and config.has_option('ZIP', 'zip_nome'):
        zip_folder = config.get('ZIP', 'zip_folder')
        zip_nome = config.get('ZIP', 'zip_nome')

        os.makedirs(zip_folder, exist_ok=True)
        zip_path = f"{zip_folder}/{zip_nome}"

        try:
            with zipfile.ZipFile(zip_path, 'w') as zipf:
                zipf.write(output, arcname=output_nome)
            logger.info(f"Arquivo ZIP criado em {zip_path}")
        except Exception as e:
            logger.error(f"Erro ao criar arquivo ZIP: {str(e)}")


if __name__ == "__main__":
    main()