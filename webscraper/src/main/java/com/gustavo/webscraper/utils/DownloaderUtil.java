package com.gustavo.webscraper.utils;

import com.gustavo.webscraper.ConfigLoader;

import java.io.*;
import java.net.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public class DownloaderUtil {
    private static final String DOWNLOAD_FOLDER = ConfigLoader.getProperty("webscraper.downloadFolder");

    static {
        try {
            Files.createDirectories(Path.of(DOWNLOAD_FOLDER));
        } catch (IOException e) {
            // diretório já existe
        }
    }

    public static void baixarArquivos(List<String> linksParaDownloads) {
        for (String link : linksParaDownloads) {
            try {
                URL url = new URL(link);
                String nomeArquivo = new File(url.getPath()).getName();
                File pasta = new File(DOWNLOAD_FOLDER);
                File destino = new File(pasta, nomeArquivo);

                HttpURLConnection conexao = (HttpURLConnection) url.openConnection();
                conexao.setRequestMethod("GET");
                conexao.setConnectTimeout(5000);
                conexao.setReadTimeout(5000);

                if (conexao.getResponseCode() == HttpURLConnection.HTTP_OK) {
                    try (InputStream inputStream = conexao.getInputStream();
                         FileOutputStream fileOutputStream = new FileOutputStream(destino)) {

                        byte[] buffer = new byte[4096];
                        int bytesRead;
                        while ((bytesRead = inputStream.read(buffer)) != -1) {
                            fileOutputStream.write(buffer, 0, bytesRead);
                        }
                        LoggerUtil.info("DownloaderUtil", "baixarArquivos", "Download concluído: " + nomeArquivo);
                    }
                } else {
                    LoggerUtil.error("DownloaderUtil", "baixarArquivos", "Erro ao fazer download do link: " + link);
                }

                conexao.disconnect();
            } catch (IOException e) {
                LoggerUtil.error("DownloaderUtil", "baixarArquivos", "Erro ao tentar baixar o arquivo de " + link + ": " + e.getMessage());
            }
        }
    }
}
