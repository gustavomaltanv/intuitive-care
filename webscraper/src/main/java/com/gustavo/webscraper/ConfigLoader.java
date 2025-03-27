package com.gustavo.webscraper;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class ConfigLoader {
    private Properties properties;

    public ConfigLoader() {
        try (InputStream in = getClass().getClassLoader().getResourceAsStream("/config.properties")) {
            if (in == null) {
                throw new IOException("teste");
            }
            properties.load(in);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public String getProperty(String key) {
        return properties.getProperty(key);
    }
}
