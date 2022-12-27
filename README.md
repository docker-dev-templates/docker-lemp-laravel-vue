# Docker LEMP stack development tool

This repository represents a rich template for deploying development environments using dockers. Where we build a separated architecture of backend and frontend projects, with all the services associated to them ready to run. This is very convenient, for example, in application environments where the backend serves an API and the frontend consumes it. 

 We are using ```Docker Compose``` with ```NGINX```, ```Node```, ```PHP-FPM```, ```MariaDB``` and ```phpMyAdmin``` services. ```Laravel``` is being used for the backend side and ```Vue + Vite``` for the frontend. Each service and application source is containerized using dockers.

> **Note:** Initially this repository is intended to be used as development containers, a new way of using Dockers containers with development environments installed inside them, and not in your main system, in a service infrastructure context very similar to the existing one in productions environments.

## Translations of this readme
- [Spanish Readme](README.spanish.md)

## 1. Install prerequisites
This project has been mainly created for Unix (Linux/MacOS). Perhaps it could work on Windows if you use [WSL (Windows Subsystem for Linux)](https://learn.microsoft.com/en-us/training/modules/get-started-with-windows-subsystem-for-linux/2-enable-and-install)

All requisites should be available for your distribution. The most important are :

* [WSL 2](https://learn.microsoft.com/en-us/windows/wsl/install)<font size="2"> (Windows users)</font>
* [Git](https://git-scm.com/downloads)
* [Docker](https://docs.docker.com/engine/installation/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* [Visutal Studio Code](https://https://code.visualstudio.com)<font size="2"> (You can use whatever IDE allows you to work inside containers)</font>

Check if `docker-compose` is already installed by entering the following command: 

```sh
which docker-compose
```

Check Docker Compose compatibility :

* [Compose file version 3 reference](https://docs.docker.com/compose/compose-file/)

## 2. Docker services overview
* [Nginx](https://hub.docker.com/_/nginx/)
* [MariaDB](https://hub.docker.com/_/mariadb)
* [PHPMyAdmin](https://hub.docker.com/r/phpmyadmin/phpmyadmin/)
* [Node-envsubst](https://hub.docker.com/repository/docker/jraicr/node-envsubst)
* [PHP](https://hub.docker.com/repository/docker/jraicr/php-xdebug-composer)

This services use the following ports.

|   Server   | Port |
|------------|------|
| MariaDB    | 3306 |
| PHPMyAdmin | 8080 |
| Nginx      | 8000 |



|       Service       |            URL                  |              Observations                     |
|---------------------|-------------------------------- |------------------------------------------------
| Frontend (Vue+Vite) | http://localhost:8000           |                                               | 
| Backend (Laravel)   | http://localhost:8000/api/      | Backend API Route served from Artisan. (Dev)  |         
| Backend (Laravel)   | http://localhost:8001/api/      | Backend served from FPM. (Production)         |
| phpMyAdmin          | http://localhost:8080           |                                               |      

- Nginx is being used to do reverse proxy to route backend, frontend and phpMyAdmin services.
- The URL http://localhost:8000/api/ returns a 404 by default if nothing is requested from the API.
- The backend is configured to be served in the development environment from both Artisan and FPM. This is to check that everything works correctly and to be able to test in the development environment. In the ```.devcontainer/backend/docker-entrypoint.sh``` path you can configure how to serve the application during development.

## 3. How to use this repository?
Here are some summary guidelines for using this repository to start a new project or include your Laravel and Vue projects in this architecture.

### 3.1. Clone the repository
```sh
git clone https://github.com/jraicr/docker-lemp-laravel-vue.git myProject
```

After cloning you can change or remove the remote origin from this repository and set up your own for the project. How to use git is beyond the scope of this document.

**Related links**
 - [Managing remote repositories](https://docs.github.com/en/get-started/getting-started-with-git/managing-remote-repositories)
 - [Adding locally hosted code to GitHub](https://docs.github.com/en/get-started/importing-your-projects-to-github/importing-source-code-to-github/adding-locally-hosted-code-to-github)


### 3.2. Configure environment variables
First you must add to your .bashrc or .zshrc file the following variable exports:

  - Open .bashrc or .zshrc with a text editor like nano:

```sh
cd ~
nano .bashrc
```

  - Write the following lines at the end of the file:

```sh
export UID="$UID"
export USERNAME="$USER"
export PWD="$PWD"
```
- You must configure ```PROJECT_NAME``` variable in  ```.devcontainer/.env```

- Copy ```.devcontainer/mariadb/.mariadb.example.env``` to ```.devcontainer/mariadb/.mariadb.env```
  - Change database connection root and user passwords in ```.mariadb.env``` file.

- Copy ```.devcontainer/backend/.backend.example.env``` to ```.devcontainer/backend/.backend.env```
  - Configure Laravel environment variables ([more info](https://laravel.com/docs/9.x/configuration))

- You can change ```NGINX_HOST``` variable in ```.webserver.env```, it is set to ```localhost``` by default. If you need to change NGINX configuration you are able to do it from the file ```.devcontainer/webserver/config/nginx/conf.d/default.conf.template.nginx```

:information_source: **See [configuration](#4-configuration)** for more details.

### 3.3. Generate new Laravel and Vue projects
To generate a new Laravel project uses the command:
```sh
./.generate_first_time_backend.sh
```
 
To generate the Vue+Vite project uses the command:
```sh
./.generate_first_time_frontend.sh
``` 

:information_source: **See [frontend & backend projects](#5-frontend--backend-projects)** for more details.

### 3.4. Deploy containers for development
- **Compose up** command:
```sh
docker compose -f ".devcontainer/docker-compose.yml" up -d --build 
```

- **Compose down** command:
```sh
docker compose -f ".devcontainer/docker-compose.yml" down  
```

If you are using **VS Code** as your main IDE, alternatively you can open the project folder and do a right click on docker-compose file in order to manage it. This require to have installed [Docker VSCode extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker). After composing up the containers you should be able to connect to web services in your web browser.

To start working inside a container from ```VS Code``` you will need [Remote Development extension pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) **(if you are in windows you will need WSL 2)** you can press F1 and type ```Attach to running container``` then select the frontend or backend container to start working inside it. You can also do it from the Dockers view in VS Code and doing a right click on the container you are interested to work in and select ```Attach Visual Studio Code```.

:information_source: **See [developing inside a container](https://code.visualstudio.com/docs/devcontainers/containers)** for more details.

## 4. Configuration
In the following sections we will discuss the architecture configurations in more depth. 

First of all we need to make sure that we have some environment variables available on our own computer. To do this follow the steps below.

1. Open .bashrc or .zshrc with a text editor like nano:
```sh
cd ~
nano .bashrc
```

2. Write the following lines at the end of the file:

```sh
export UID="$UID"
export USERNAME="$USER"
export PWD="$PWD"
```

### 4.1. Environment variables in Docker Compose

The env variables for the docker-compose file are found in  ```.devcontainer/.env``` here you can configure the ports of the services. It is recommended to leave them as they are and only change the project name in this file. In case you want to change any port you are recommended to only set the external ports where you are going to connect to the services.

```properties
PROJECT_NAME=ProjectName # ✏️ Writes here your project name

### NGINX Webserver ###
# Port to connect to Frontend and Backend services routed by nginx (http://localhost:8000)
FRONTEND_BACKEND_EXTERNAL_PORT=8000 

### MariaDB ###
# Port to connect to the database server
MARIADB_EXTERNAL_PORT=3306

### PHP MY ADMIN ###
# Port to connect to phpMyAdmin (http://localhost:8080)
PHPMYADMIN_EXTERNAL_PORT=8080

### Backend ###
# Port used by the backend container for internal docker network
BACKEND_EXPOSE_PORT=8080 

### Frontend ###
# Port used by the frontend container for internal docker network
FRONTEND_EXPOSE_PORT=8080 
NODE_DEVELOPMENT=development
```

> **Note:** Be sure to change the **name of the project** in the ```.devcontainer/.env``` file. Many docker parameters are built from this name. Also, the source code of laravel and vue projects will be located in named folders: ```projectName_backend``` and ```projectName_frontend```

### 4.2. Environment variables in webserver container (NGINX)

Located in ```.devcontainer/webserver/.webserver.env``` the most important variable to take into account is ```NGINX_HOST``` it is set to localhost by default.

```properties
#!/usr/bin/env bash
NGINX_HOST=localhost # ✏️ You can edit this (e.g.: NGINX_HOST=rai.ddns.net)
FRONTEND_CONNECTION_PORT=${FRONTEND_EXPOSE_PORT}
BACKEND_CONNECTION_PORT=${BACKEND_EXPOSE_PORT}
```

### 4.3. Environment variables in database container (MariaDB)
You must copy ```.devcontainer/mariadb/.mariadb.example.env``` to ```.devcontainer/mariadb/.mariadb.env```

```properties
### Environment Variables for MariaDB Docker Container ###
# More info: https://mariadb.com/kb/en/mariadb-docker-environment-variables/

MARIADB_CONNECTION=mysql
MARIADB_HOST=${PROJECT_NAME}_mariadb
MARIADB_ROOT_USER=root
MARIADB_ROOT_PASSWORD=qwerty # ✏️ CHANGE THIS PASSWORD
MARIADB_USER=dev
MARIADB_PASSWORD=dev # ✏️ CHANGE THIS PASSWORD
MARIADB_ROOT_HOST=172.0.0.0/255.0.0.0
MARIADB_DATABASE=${PROJECT_NAME}_bd
```
Here you can change the root and user passwords. By default ```MARIADB_USER``` is set to ```dev``` but you can change it for whatever username you want.

The database will be created using ```PROJECT_NAME``` from the docker compose environment variables.

### 4.4. Environment variables in backend container (Laravel)
You must copy ```.devcontainer/backend/.backend.example.env``` to ```.devcontainer/backend/.backend.env```

The env variables in this containers will be used for Laravel configuration, ignoring the original ```.env``` file located in the source code folder.

> **Note:** You must be sure that the database connection data corresponds to the data located in the environment server of MariaDB container in the file ```.devcontainer/mariadb/.mariadb.env```

- [More information about Laravel environment configuration](https://laravel.com/docs/9.x/configuration)

### 4.5. Environment variables in frontend container (Vue + Vite)
For the moment being it is not needed to pay any attention for configuration in this section, since it is used to transmit some data already located in the ```docker compose``` environment variables.

### 4.6. Some notes about environment variables
Over time I will refactor the environment variable files to avoid having to configure more than one, avoid mistakes and to be able to propagate this configuration properly to all services.

### 4.7. Nginx configuration
The configuration file is located in ```.devcontainer/webserver/config/etc/nginx/conf.d/default.conf.template.nginx ```. If you need to change some NGINX configuration you can do it here. 

### 4.8. PHP configuration
You can find the php configuration files in the directory ```.devcontainer/backend/config/etc/php/conf.d``` In this path you can configure the php.ini file, as well as the port to which XDebug connects, among other options. 

The configuration files in the path ```.devcontainer/backend/config/etc/php-fpm.d/``` are for PHP's [FPM](https://www.stackscale.com/blog/php-fpm-high-traffic-websites/) service. 

You are free to add more configuration files to PHP by mounting a new volume - inside the backend container - in the ```docker-compose.yml``` file. You can see the current ones as an example:

```yaml
 backend:
  (...)
  volumes:
      - ../${PROJECT_NAME}_backend:/app # Laravel Project
      - ./backend/config/etc/php/conf.d/php.ini-development.ini:/usr/local/etc/php/php.ini # PHP Config
      - ./backend/config/etc/php-fpm.d/www.conf:/usr/local/etc/php-fpm.d/www.conf # PHP-FPM Config
      - ./backend/config/etc/php-fpm.d/zz-docker.conf:/usr/local/etc/php-fpm.d/zz-docker.conf # PHP-FPM Config
      - ./backend/config/etc/php/conf.d/xdebug.ini:/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini # PHP XDebug Config
      - ./backend/config/etc/php/conf.d/opcache.ini:/usr/local/etc/php/conf.d/opcache.ini # PHP OPcache config
      - ./backend/docker-entrypoint.sh:/docker-entrypoint.sh # Backend Docker entrypoint script
  (...)    
``` 

The ```.devcontainer/backend/docker-entrypoint.sh``` file is executed as soon as the backend container is raised. By default the Laravel application is served using Artisan and FPM at the same time, later both are routed with nginx. You can edit the file to decide how to serve the application during development.

Remember that in production environments it is desirable to serve the Laravel application with FPM or other options such as Laravel Octane with Swoole.

### 5. Some considerations about database and phpMyAdmin 
The user ```root``` from the database can only be accessed from the same networks that belong to the docker network. It is well configured so you dont need to worry even if you are running WSL 2 on Windows, you will be able to access it from your Windows host using your favourite ```mariaDB client``` or using ```phpMyAdmin```.

```phpMyAdmin``` is useful to manage our database through the web browser. By default you can access it only from localhost.

Each time the ```mariaDB container``` is up it will be executing automatically the file in ```.devcontainer/mariadb/config/db/docker-entrypoint-initdb.d/db_init.sql```. For the moment it is used in the starting point to create phpMyAdmin configuration tables and to assign privileges to them to the user configured in the variable ```MARIADB_USER``` from the mariaDB environment variables container file ```.mariadb.env```. If you think this tables should be created in another moment or context, you are free to edit this if you know what you are doing.

> **Note:** It is strongly recommended to not deploy phpMyAdmin in production environments. It is useful to work only inside development environments.

Over time I will be adding to this project other docker compose options, more suitable for deployment in production environments. Feel free to adapt compose for production environments but be aware of security warnings, such as avoiding phpMyAdmin deployments.

## 6. Frontend & Backend Projects
The images used in frontend and backend containers are used to work with Laravel and Vue + Vite, although the services of both projects coexist on the same nginx proxy server, they are projects that should be in completely different repositories. 

Before composing up the containers it is important to have ready the folders with both projects, since frontend and backend containers will be mounting this folders as volumes.

### 6.1 First time project generation
You can generate new Laravel and Vue projects using the bash scripts ```.generate_first_time_backend.sh``` and ```.generate_first_time_frontend.sh```. They are using docker images to generate the full projects.

- To generate a **new Laravel project** uses the command:

```sh
./.generate_first_time_backend.sh
```
 
- To generate a **new Vue+Vite project** uses the command:

```sh
./.generate_first_time_frontend.sh
``` 

It is important to take into account that vite config file in ```.devcontainer/config/vite.config.template.js``` is mounted in the frontend container using volumes. When frontend container starts, it copy the file to ```projectName_frontend/vite.config.js``` using ```envsubst``` to converts environment variables to the data they are pointing. So if you are going to change it you must restart the container for them to take effect.

How to work with Laravel or Vue is out of scope of this document.

### 6.2 Including existing projects
You can add your projects creating git submodules that points to them. Remember that folders name must be ```${PROJECT_NAME}_backend``` and ```${PROJECT_NAME}_frontend```. As said before, ```PROJECT_NAME``` can be set in ```./devcontainer/.env```.

Write this commands to create git submodules from the project root

```sh
git submodule add https://github.com/user/frontAPP ProjectName_frontend
git submodule add https://github.com/user/backAPI ProjectName_backend
```

## 7. Contributing to this repository
Feel free to contribute to this project with any changes. Make a fork of the repository and clone it on your computer, make changes as you see fit and create a [pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request).