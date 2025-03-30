package com.gustavo.webscraper;

import com.gustavo.webscraper.utils.*;
import java.util.Arrays;
import java.util.List;

public class WebScraper {
    public static void main(String[] args) {
        String className = WebScraper.class.getSimpleName();
        String methodName = "webScraping";
        LoggerUtil.info(className, methodName, "Serviço iniciado");

        String url = ConfigLoader.getProperty("webscraper.url");
        List<String> arquivos = Arrays.asList(ConfigLoader.getProperty("webscraper.arquivos").split(","));
        List<String> pdfLinks = HtmlAnalyzer.obterLinksDosArquivos(url, arquivos);
        DownloaderUtil.baixarArquivos(pdfLinks);
        CompressUtil.compactarArquivos(ConfigLoader.getProperty("webscraper.downloadFolder"));

    }
}
