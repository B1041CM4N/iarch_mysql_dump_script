CREATE USER 'adm1n'@'localhost' IDENTIFIED BY 't00r';

GRANT PROCESS ON *.* TO 'adm1n'@'localhost;'

GRANT SELECT, LOCK TABLES ON *.* TO 'adm1n'@'localhost';

GRANT ALL PRIVILEGES ON my_database.* TO 'adm1n'@'localhost';

FLUSH PRIVILEGES;
