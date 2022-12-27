#!/usr/bin/env bash
# This bash script creates a new Laravel project using a docker image
source .devcontainer/.env

FOLDER_NAME=${PROJECT_NAME}_backend
BACKEND_PATH=${PWD}/${FOLDER_NAME}

function generateProject () {
    echo -e "\nSe va a generar un nuevo proyecto Laravel en $BACKEND_PATH\n"
    docker run --rm -v $BACKEND_PATH:/app composer create-project laravel/laravel .
    sudo chown -R $USER:$USER $FOLDER_NAME

    echo -e "\n✔️  Proyecto Laravel creado en $BACKEND_PATH\n"
}

if [ -d "$BACKEND_PATH" ];
then
    echo -e "\n❌ Advertencia: Ya existe un directorio llamado $FOLDER_NAME.\n No se generará el proyecto.\n"
else
	generateProject
fi


