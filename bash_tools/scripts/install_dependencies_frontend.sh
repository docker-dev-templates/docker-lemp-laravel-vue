#!/usr/bin/env bash
# If you created a git submodule or your frontend folder contains a recently 
# cloned repo, this helper will install dependencies for Vue + Vite packages, based in npm package.json file.

currentDir=${PWD##*/}
rightWorkingDir=0

if [ "$currentDir" != "scripts" ] && [ -d ".devcontainer" ]; then
    rightWorkingDir=1
fi

if [ $rightWorkingDir -eq 0 ] && [ "$currentDir" == "scripts" ]; then
    echo "Changing working directory..."
    cd ../../
fi

if [ $rightWorkingDir -eq 0 ] && [ "$currentDir" != "scripts" ]; then
    echo "Error, the script will not be executed: You are not in the correct directory to run this script."
    exit
fi


source .devcontainer/.env

FOLDER_NAME=${PROJECT_NAME}_frontend
FRONTEND_PATH=${PWD}/${FOLDER_NAME}

function installDependencies() {
    docker run --rm -v $FRONTEND_PATH:/app node:current-alpine sh -c "cd /app && npm install --loglevel verbose"
    sudo chown -R $USER:$USER $FRONTEND_PATH/node_modules
}

if [ -d "$FRONTEND_PATH" ];
then
    installDependencies
else
	echo -e "\n❌ Advertencia: No existe un directorio llamado $FOLDER_NAME.\n No se instalarán las dependencias de NPM.\n"
fi