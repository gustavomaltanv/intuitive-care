package com.gustavo.webscraper;

import com.gustavo.webscraper.utils.LoggerUtil;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class ConfigLoader {
    private static final Properties properties = new Properties();

    static {
        try (InputStream input = ConfigLoader.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (input == null) {
                LoggerUtil.error("ConfigLoader", "static", "Arquivo config.properties não encontrado");
                throw new IOException("Arquivo config.properties não encontrado");
            }
            properties.load(input);
            LoggerUtil.info("ConfigLoader", "static", "ConfigLoader iniciado");
        } catch (IOException e) {
            LoggerUtil.error("ConfigLoader", "static", "Erro ao iniciar ConfigLoader: " + e.getMessage());
        }
    }

    public static String getProperty(String key) {
        String value = properties.getProperty(key);
        if (value == null) {
            LoggerUtil.warn("ConfigLoader", "getProperty", "Chave inexistente: " + key);
        } else {
            LoggerUtil.info("ConfigLoader", "getProperty", "Propriedade lida: " + key + " = " + value);
        }
        return value;
    }
}
