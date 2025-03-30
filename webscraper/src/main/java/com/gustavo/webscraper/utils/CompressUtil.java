package com.gustavo.webscraper.utils;

import com.gustavo.webscraper.ConfigLoader;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class CompressUtil {
    private static final String ZIP_FOLDER = ConfigLoader.getProperty("webscraper.zipFolder");

    static {
        try {
            Files.createDirectories(Path.of(ZIP_FOLDER));
        } catch (IOException e) {
            // diretório já existe
        }
    }

    public static void compactarArquivos(String pastaOrigem) {
        String nomeArquivoZip = "Teste_Gustavo.zip";
        File arquivoZip = new File(ZIP_FOLDER, nomeArquivoZip);

        try (ZipOutputStream zipOut = new ZipOutputStream(new FileOutputStream(arquivoZip))) {
            File pasta = new File(pastaOrigem);
            File[] arquivos = pasta.listFiles();

            if (arquivos != null) {
                for (File arquivo : arquivos) {
                    if (arquivo.isFile()) {
                        adicionarArquivoAoZip(arquivo, zipOut);
                    }
                }
            }
            LoggerUtil.info("CompressUtil", "compactarArquivos", "Arquivos compactados com sucesso em: " + arquivoZip.getAbsolutePath());
        } catch (IOException e) {
            LoggerUtil.error("CompressUtil", "compactarArquivos", "Erro ao compactar os arquivos: " + e.getMessage());
        }
    }

    private static void adicionarArquivoAoZip(File arquivo, ZipOutputStream zipOut) throws IOException {
        zipOut.putNextEntry(new ZipEntry(arquivo.getName()));
        try (FileInputStream fis = new FileInputStream(arquivo)) {
            byte[] buffer = new byte[1024];
            int bytesLidos;
            while ((bytesLidos = fis.read(buffer)) != -1) {
                zipOut.write(buffer, 0, bytesLidos);
            }
        } catch (IOException e) {
            LoggerUtil.error("CompressUtil", "adicionarArquivoAoZip", e.getMessage());
        }
        zipOut.closeEntry();
    }
}
