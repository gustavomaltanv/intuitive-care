package com.gustavo.webscraper.utils;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.text.SimpleDateFormat;
import java.util.Date;

public class LoggerUtil {
    private static final String LOG_FOLDER = "../output/log";
    private static final String LOG_FILE = LOG_FOLDER + "/webscraping.log";
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");

    static {
        try {
            Files.createDirectories(Path.of(LOG_FOLDER));
            Files.createFile(Path.of(LOG_FILE));
        } catch (IOException e) {
            // arquivo já existe
        }
    }

    public static void log(String level, String className, String methodName, String message) {
        String timestamp = DATE_FORMAT.format(new Date());
        String logMessage = String.format("%s [%s.%s] [%s] %s%n", timestamp, className, methodName, level, message);

        try {
            Files.write(Path.of(LOG_FILE), logMessage.getBytes(), StandardOpenOption.APPEND);
        } catch (IOException e) {
            System.err.println("Erro ao escrever no log: " + e.getMessage());
        }
    }

    public static void info(String className, String methodName, String message) {
        log("INFO", className, methodName, message);
    }

    public static void warn(String className, String methodName, String message) {
        log("WARN", className, methodName, message);
    }

    public static void error(String className, String methodName, String message) {
        log("ERROR", className, methodName, message);
    }
}
