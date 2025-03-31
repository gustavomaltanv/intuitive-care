package com.gustavo.webscraper;

import com.gustavo.webscraper.utils.LoggerUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.MockedStatic;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Properties;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ConfigLoaderTest {

    private Properties mockProperties;

    @BeforeEach
    void setUp() {
        mockProperties = new Properties();
        mockProperties.setProperty("webscraper.teste", "teste");
    }

    @Test
    void testGetPropertyExistingKey() {
        try (MockedStatic<ConfigLoader> mockedConfigLoader = mockStatic(ConfigLoader.class)) {
            mockedConfigLoader.when(() -> ConfigLoader.getProperty("webscraper.teste"))
                    .thenReturn(mockProperties.getProperty("webscraper.teste"));

            String result = ConfigLoader.getProperty("webscraper.teste");
            assertEquals("teste", result);
        }
    }

    @Test
    void testGetPropertyNonExistingKey() {
        try (MockedStatic<LoggerUtil> mockedLogger = mockStatic(LoggerUtil.class)) {
            assertNull(ConfigLoader.getProperty("webscraper.inexistente"));
            mockedLogger.verify(() -> LoggerUtil.warn("ConfigLoader", "getProperty", "Chave inexistente: webscraper.inexistente"), times(1));
        }
    }
}
