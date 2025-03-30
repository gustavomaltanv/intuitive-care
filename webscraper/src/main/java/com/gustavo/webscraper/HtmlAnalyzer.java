package com.gustavo.webscraper;

import com.gustavo.webscraper.utils.LoggerUtil;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

public class HtmlAnalyzer {

    public static List<String> obterLinksDosArquivos(String url, List<String> arquivos) {
        List<String> pdfLinks = new ArrayList<>();
        String className = HtmlAnalyzer.class.getSimpleName();
        String methodName = "obterLinksDosArquivos";

        LoggerUtil.info(className, methodName, "Iniciando extração de links da URL: " + url);
        try {

            Document doc = Jsoup.connect(url).get();
            Elements links = doc.select("a[href]");
            LoggerUtil.info(className, methodName, "Total de links encontrados na página: " + links.size());

            for (Element link : links) {
                String linkText = link.text().trim();

                for (String arquivo : arquivos) {
                    String nomeArquivo = arquivo.substring(0, arquivo.lastIndexOf(".")); // Obtém o nome sem extensão

                    String regex = "^" + Pattern.quote(nomeArquivo) + "\\.?$";

                    if (linkText.matches(regex)) {
                        pdfLinks.add(link.attr("href"));
                        LoggerUtil.info(className, methodName, "Arquivo correspondente encontrado: " + link.attr("href"));
                        break; // já validou o link
                    }
                }
            }
        } catch (IOException e) {
            LoggerUtil.error(className, methodName, "Erro ao acessar a URL: " + e.getMessage());
        }

        LoggerUtil.info(className, methodName, "Total de arquivos extraídos: " + pdfLinks.size());
        return pdfLinks;
    }
}
