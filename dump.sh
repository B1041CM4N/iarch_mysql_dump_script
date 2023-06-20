#!/bin/bash

## Definimos la opción help (Para mostrar el órden necesario de los argumentos)
function help() {
    echo "Uso: ./dump.sh [OPCIONES] [DB_USER] [DB_PASS] [DB_NAME] [DB_HOST] [DB_PORT]"
    echo "Script para la generación de un dump en una base de datos MySQL (usando compresión bzip2)."
    echo ""
    echo "Opciones:"
    echo "-h, --help    Mostrar ayuda sobre el uso del script y salir"
    echo ""
    echo "Ejemplos:"
    echo "./dump.sh -h"
    echo "./dump.sh --help"
    echo "./dump.sh DB_USER DB_PASS DB_NAME DB_HOST DB_PORT"
    echo "Por ejemplo: ./dump.sh root t00r1234 mi_base_de_datos localhost 3306"
}

## Detectar opciones (En este caso es solo la opción -h o --help)
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
      -h|--help)
        help
        exit 0
        ;;
      *)
        echo "La opción $key que ingresaste no existe, prueba con ./dump.sh -h o ./dump.sh --help."
        exit 1
        ;;
    esac
    shift
done

## Corroborar que el comando bzip2 este instalado
if command -v bzip2 > /dev/null 2>&1; then
  echo "### Inicializando script! ###"
else
  echo "Ha ocurrido un problema, por favor corrobora tu instalación de bzip2 y vuelve a intentar nuevamente."
  exit 1
fi

## Corroborar que el comando mysqldump este instalado
if command -v mysqldump > /dev/null 2>&1; then
  echo "### Preparando MySQL Dump ###"
else
  echo "Ha ocurrido un problema, por favor corrobora tu instalación de mysqldump y vuelve a intentar nuevamente."
  exit 1
fi

########## Asignamos los valores por defecto ##########
FILENAME="dump.bz2"
DUMPPATH="$(which mysqldump)"

## Corroborar que los argumentos no estén vacíos
if [ -n "$DB_USER" ] || [ -n "$DB_PASS" ] || [ -n "$DB_NAME" ] || [ -n "$DB_HOST" ] || [ -n "$DB_PORT" ]; then
  
  ## Mensaje de inicio de ejecución del script (Para corroborar que pasó las validaciones anteriores)
  echo "***~~~- Espere por favor -~~~***"
  
  ## Borrar archivos con extensión *.bz2 anteriores
  command rm ./*.bz2
  sleep 1;

  ## Generando el archivo dump
  $DUMPPATH -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME | bzip2 > $FILENAME

  ## Corroborar que la creación del archivo haya sido exitosa (-s para corroborar que contenga información)
  if [ -s $? ]; then
    echo "###~- El archivo de dump ha sido creado satisfactoriamente, puedes buscarlo por el nombre: $FILENAME -~###"
  else
    echo "###~- Ocurrió un problema en la operación de backup de la base de datos, corrobora los datos de conexión y permisos por favor. -~###"
    exit 1
  fi
else
  echo "###~- Alguna de las variables de entorno está vacía, por favor corrobora los valores y asignaciones de las variables. -~###"
  exit 1
fi