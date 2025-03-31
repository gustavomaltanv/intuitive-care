import os
import logging
import configparser


class LoggerUtil:
    def __init__(self, config_path='config/config.ini'):
        self.config = configparser.ConfigParser()
        self.config.read(config_path)

        log_folder = self.config.get('LOGGING', 'log_folder')
        log_nome = self.config.get('LOGGING', 'log_nome')
        os.makedirs(log_folder, exist_ok=True)
        log_filename = f"{log_folder}/{log_nome}"

        self.logger = logging.getLogger('pdf_processor')

        if not self.logger.handlers:
            self.logger.setLevel(getattr(logging, self.config.get('LOGGING', 'level')))

            log_format = self.config.get('LOGGING', 'format')

            file_handler = logging.FileHandler(log_filename)
            file_handler.setFormatter(logging.Formatter(log_format))

            console_handler = logging.StreamHandler()
            console_handler.setFormatter(logging.Formatter(log_format))

            self.logger.addHandler(file_handler)
            self.logger.addHandler(console_handler)

    def get_logger(self):
        return self.logger