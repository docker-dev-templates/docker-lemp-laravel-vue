# Herramienta de desarrollo de pilas LEMP utilizando Docker

Este repositorio representa una rica plantilla para desplegar entornos de desarrollo utilizando dockers. Donde construimos una arquitectura separada de proyectos backend y frontend, con todos los servicios asociados a ellos listos para ejecutarse. Esto es muy conveniente, por ejemplo, en entornos de aplicación donde el backend sirve una API y el frontend la consume. 

 Estamos utilizando ``Docker Compose`` con los servicios ``NGINX``, ``Node``, ``PHP-FPM``, ``MariaDB`` y ``phpMyAdmin``. Se está utilizando ``Laravel`` para el backend y ``Vue + Vite`` para el frontend. Cada servicio y fuente de aplicación está en contenedores utilizando dockers.

> **Nota:** Inicialmente este repositorio está pensado para ser usado como contenedores de desarrollo, una nueva forma de usar contenedores Dockers con entornos de desarrollo instalados dentro de ellos, y no en tu sistema principal, en un contexto de infraestructura de servicios muy similar al existente en entornos de producción.

## 1. Prerequisitos de instalación
Este proyecto ha sido creado principalmente para Unix (Linux/MacOS). Quizás podría funcionar en Windows si usas [WSL (Windows Subsystem for Linux)](https://learn.microsoft.com/en-us/training/modules/get-started-with-windows-subsystem-for-linux/2-enable-and-install)

**Requisitos:**
* [WSL 2](https://learn.microsoft.com/en-us/windows/wsl/install)<font size="2"> (Usuarios de Windows)</font>
* [Git](https://git-scm.com/downloads)
* [Docker](https://docs.docker.com/engine/installation/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* [Visutal Studio Code](https://https://code.visualstudio.com)<font size="2"> (Puedes usar cualquier IDE que te permita trabajar dentro de contenedores)</font>

Comprueba si tienes instalado `docker-compose` escribiendo el siguiente comando: 

```sh
which docker-compose
```

Check Docker Compose compatibility :

* [Compose file version 3 reference](https://docs.docker.com/compose/compose-file/)

## 2. Resumen de servicios Docker
* [Nginx](https://hub.docker.com/_/nginx/)
* [MariaDB](https://hub.docker.com/_/mariadb)
* [PHPMyAdmin](https://hub.docker.com/r/phpmyadmin/phpmyadmin/)
* [Node-envsubst](https://hub.docker.com/repository/docker/jraicr/node-envsubst)
* [PHP](https://hub.docker.com/repository/docker/jraicr/php-xdebug-composer)

Estos servicios utilizan los siguientes puertos.

|  Servidor  | Puerto |
|------------|--------|
| MariaDB    |  3306  |
| PHPMyAdmin |  8080  |
| Nginx      |  8000  |


|       Servicio       |            URL                 |         Observaciones                                     |
|----------------------|--------------------------------|-----------------------------------------------------------|
| Frontend (Vue+Vite)  | http://localhost:8000          | Aplicación Frontend                                       |
| Backend (Laravel)    | http://localhost:8000/api/     | Ruta API del Backend servido desde Artisan. (Desarrollo)  |           
| Backend (Laravel)    | http://localhost:8001          | Backend servido desde FPM. (Producción)                   |
| phpMyAdmin           | http://localhost:8080          |                                                           |

- Nginx se está utilizando para hacer proxy inverso para enrutar los servicios de backend, frontend y phpMyAdmin.
- El backend está configurado para servirse en el entorno de desarrollo tanto desde Artisan como desde FPM. Esto es para comprobar que funciona todo correctamente y poder realizar pruebas en el entorno de desarrollo. En la ruta ```.devcontainer/backend/docker-entrypoint.sh``` puedes configurar como servir la aplicación durante el desarrollo.

## 3. ¿Cómo usar este repositorio?
Aquí tienes algunas pautas resumidas para usar este repositorio, tanto para empezar un nuevo proyecto así como incluir tus proyectos Laravel y Vue en esta arquitectura.

### 3.1. Clona el repositorio
```sh
git clone https://github.com/jraicr/docker-lemp-laravel-vue.git myProject
```

Después de clonar puedes cambiar o eliminar el origen remoto de este repositorio y configurar el tuyo propio para el proyecto. Cómo usar git está más allá del alcance de este documento.

**Links relacionados**
 - [Administrar repositorios remotos](https://docs.github.com/es/get-started/getting-started-with-git/managing-remote-repositories)
 - [Agregar código hospedado localmente a GitHub](https://docs.github.com/es/get-started/importing-your-projects-to-github/importing-source-code-to-github/adding-locally-hosted-code-to-github)


### 3.2. Configura las variables de entorno
- En primer lugar debes agregar a tu archivo .bashrc o .zshrc las siguientes variables de entorno.

Abre .bashrc o .zshrc con un editor de texto como nano:
```sh
cd ~
nano .bashrc
```

Escribe las siguientes lineas al final del fichero:

```sh
export UID="$UID"
export USERNAME="$USER"
export PWD="$PWD"
```

- Debes configurar la variable```PROJECT_NAME``` en  ```.devcontainer/.env```

- Copia ```.devcontainer/mariadb/.mariadb.example.env``` a ```.devcontainer/mariadb/.mariadb.env```
  - Cambia los datos de conexión a la base de datos del usuario root y del usuario dev en el archivo ```.mariadb.env```

- Copia ```.devcontainer/backend/.backend.example.env``` a ```.devcontainer/backend/.backend.env```
  - Configura las variables de entorno de Laravel ([más información](https://laravel.com/docs/9.x/configuration))

- Puedes cambiar la variable ```NGINX_HOST``` en ```.webserver.env```, está configurado por defecto con ```localhost```. Si necesitas cambiar la configuración de ```NGINX```puedes hacerlo en el archivo ```.devcontainer/webserver/config/nginx/conf.d/default.conf.template.nginx```.

:information_source: **Ver [configuración](#4-configuración)** para más detalles.

### 3.3. Genera nuevos proyectos Laravel y Vue
Para generar un nuevo proyecto de Laravel usa el comando:
```sh
./.generate_first_time_backend.sh
```
 
Para generar un nuevo proyecto de Vue usa el comando:
```sh
./.generate_first_time_frontend.sh
``` 

:information_source: **Ver [proyectos frontend y backend](#6-proyectos-frontend-y-backend)** para más detalles.

### 3.4. Despliega los contenedores de desarrollo
- **Compose up**: Comando para levantar los contenedores.
```sh
docker compose -f ".devcontainer/docker-compose.yml" up -d --build 
```

- **Compose down**: Comando para detener y eliminar los contenedores.
```sh
docker compose -f ".devcontainer/docker-compose.yml" down  
```

Si estás utilizando **VS Code** como IDE principal, puedes abrir la carpeta del proyecto y hacer clic con el botón derecho del mouse en el archivo ```docker-compose``` para gestionarlo. Esto requiere tener instalado [Docker VSCode extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker). Después de levantar los contenedores deberías ser capaz de conectarte a los servicios web en tu navegador web.

Para empezar a trabajar dentro de un contenedor desde ``VS Code`` necesitarás la extensión [Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) **(si estás en windows necesitarás WSL 2)** puedes pulsar F1 y escribir ```Attach to running container``` y selecciona el contenedor frontend o backend para empezar a trabajar dentro de él. También puedes hacerlo desde la vista Dockers en VS Code y haciendo click derecho sobre el contenedor en el que te interese trabajar y seleccionar ```Attach Visual Studio Code```.

:information_source: **Ver [desarrollando dentro de un contenedor](https://code.visualstudio.com/docs/devcontainers/containers)** para más detalles.

## 4. Configuración
En las siguientes secciones veremos más en profundidad las configuraciones de la arquitectura. 

Antes de todo necesitamos asegurarnos de que tengamos disponibles algunas variables de entorno en nuestro propio ordenador. Para ello sigue los siguientes pasos.

1. Abre .bashrc o .zshrc con un editor de texto como nano:
```sh
cd ~
nano .bashrc
```

2. Escribe las siguientes lineas al final del fichero:

```sh
export UID="$UID"
export USERNAME="$USER"
export PWD="$PWD"
```

### 4.1. Variables de entorno de Docker Compose

Las variables de entorno para el fichero docker-compose se encuentran en ```.devcontainer/.env``` aquí se pueden configurar los puertos de los servicios. Se recomienda dejarlos como están y solo cambiar el nombre del proyecto en este archivo. En caso de querer cambiar algún puerto se recomienda configurar únicamente los puertos externos donde se va a conectar a los servicios.

```properties
PROJECT_NAME=ProjectName # ✏️ Escribe aquí el nombre del proyecto
COMPOSE_PROJECT_NAME=${PROJECT_NAME}_devcontainer

### NGINX Webserver ###
# Puerto para conectarse a los servicios Frontend y Backend enrutados por nginx 
FRONTEND_BACKEND_EXTERNAL_PORT=8000  # (http://localhost:8000)
BACKEND_FPM_EXTERNAL_PORT=8001       # Backend servido con FPM (http://localhost:8001)

### MariaDB ###
# Puerto para conectar al servidor de la base de datos
MARIADB_EXTERNAL_PORT=3306

### PHP MY ADMIN ###
# Puerto para conectar a phpMyAdmin 
PHPMYADMIN_EXTERNAL_PORT=8080       # (http://localhost:8080)

# 🟡 No toque esta configuración a menos que sepa lo que está haciendo. 🟡 #
### Backend ###
# Puerto utilizado por el contenedor backend para la red interna de contenedores
BACKEND_EXPOSE_PORT=8080 
BACKEND_FPM_EXPOSE_PORT=9001

### Frontend ###
# Puerto utilizado por el contenedor frontend para la red interna de contenedores
FRONTEND_EXPOSE_PORT=8080 
NODE_DEVELOPMENT=development
```

> **Nota:** Asegúrate de cambiar el **nombre del proyecto** en el archivo ```.devcontainer/.env```. Muchos parámetros de docker se construyen a partir de esta variable de entorno. Además, el código fuente de los proyectos Laravel y Vue se ubicarán en carpetas con los nombres: ```projectName_backend``` y ```projectName_frontend```.

### 4.2. Variables de entorno en el contenedor del servidor web (NGINX)

El archivo se encuentra en ```.devcontainer/webserver/.webserver.env``` la variable más importante a tener en cuenta es ``NGINX_HOST`` está configurada con localhost por defecto.


```properties
NGINX_HOST=localhost # ✏️ Puedes editar esto (ej.: NGINX_HOST=rai.ddns.net)
FRONTEND_CONNECTION_PORT=${FRONTEND_EXPOSE_PORT}
BACKEND_CONNECTION_PORT=${BACKEND_EXPOSE_PORT}
```

### 4.3. Variables de entorno en el contenedor de base de datos (MariaDB)
Copia  ```.devcontainer/mariadb/.mariadb.example.env``` a ```.devcontainer/mariadb/.mariadb.env```

```properties
### Variables de entorno para el contenedor Docker MariaDB ###
# Más información: https://mariadb.com/kb/en/mariadb-docker-environment-variables/

MARIADB_CONNECTION=mysql
MARIADB_HOST=${PROJECT_NAME}_mariadb
MARIADB_ROOT_USER=root
MARIADB_ROOT_PASSWORD=qwerty # ✏️ CHANGE THIS PASSWORD
MARIADB_USER=dev
MARIADB_PASSWORD=dev # ✏️ CHANGE THIS PASSWORD
MARIADB_ROOT_HOST=172.0.0.0/255.0.0.0
MARIADB_DATABASE=${PROJECT_NAME}_bd
```
Aquí puedes cambiar las contraseñas de root y de usuario. Por defecto ```MARIADB_USER``` está configurado como ```dev``` pero puedes cambiarlo por el nombre de usuario que quieras.

La base de datos se creará utilizando ```PROJECT_NAME```, a partir de las variables de entorno de docker compose.

### 4.4. Variables de entorno en el contenedor backend (Laravel)
Copia ```.devcontainer/backend/.backend.example.env``` a ```.devcontainer/backend/.backend.env```

Las variables de entorno en este contenedor se utilizará para la configuración de Laravel, ignorando el archivo original ```.env``` ubicado en la carpeta del proyecto.

> **Nota:** Debes asegurarte de que los datos de conexión a la base de datos se corresponden con los datos ubicados en las variables de entorno del contenedor MariaDB en el fichero ```.devcontainer/mariadb/.mariadb.env```

- [Más información sobre la configuración de Laravel](https://laravel.com/docs/9.x/configuration)

### 4.5. Variables de entorno en el contenedor frontend (Vue + Vite)
Por el momento no es necesario prestar atención a la configuración en esta sección, ya que se utiliza para transmitir algunos datos que ya se encuentran en el archivo de variables de entorno de ```docker compose```. 

### 4.6. Sobre las variables de entorno
Con el tiempo refactorizaré los archivos de variables de entorno para evitar tener que configurar más de uno, evitar errores y poder propagar esta configuración correctamente a todos los servicios.

### 4.7. Configuración de NGINX
El archivo de configuración se encuentra en ```.devcontainer/webserver/config/etc/nginx/conf.d/default.conf.template.nginx ```. Si necesitas cambiar cualquier cosa de su configuración lo puedes hacer desde aquí.

### 4.8. Configuración de PHP
Puedes encontrar los archivos de configuración de php en el directorio ```.devcontainer/backend/config/etc/php/conf.d``` En esta ruta puedes configurar el archivo php.ini, así como el puerto al que conecta XDebug, entre otras opciones. 

Los archivos de configuración de la ruta ```.devcontainer/backend/config/etc/php-fpm.d/``` corresponden al servicio [FPM](https://www.stackscale.com/es/blog/php-fpm-php-webs-alto-trafico/) de PHP. 

Eres libre de añadir más archivos de configuración a PHP montando un nuevo volumen - dentro del contenedor de backend - en el archivo  ```docker-compose.yml```. Puede ver los actuales a modo de ejemplo:

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

El archivo ```.devcontainer/backend/docker-entrypoint.sh``` se ejecuta nada más levantar el contenedor de backend. Por defecto la aplicación de Laravel se sirve mediante Artisan y FPM al mismo tiempo, posteriomente se enrutan ambos con nginx. Puedes editar el archivo para decidir como servir la aplicación durante el desarrollo.

Recuerda que en entornos de producción lo deseable es servir la aplicación de Laravel con FPM u otras opciones como Laravel Octane con Swoole.

### 5. Algunas consideraciones sobre la base de datos y phpMyAdmin 
Sólo se puede acceder al usuario ```root``` de la base de datos si conectamos desde una red que pertenezca a la de nuestro network de contenedores. 

Según las pruebas que he hecho está bien configurado, por lo que no necesitas preocuparte por esto aunque estés usando WSL 2 en Windows. Vas a ser capaz de acceder desde Windows utilizando tu cliente de ```mariaDB```  o usando ```phpMyAdmin``` desde el navegador.

```phpMyAdmin``` es útil para gestionar nuestra base de datos a través del navegador web. Por defecto sólo se puede acceder desde localhost. Esto está configurado en el [archivo de configuración de NGINX](#46-configuración-de-nginx).

Cada vez que se levante el contenedor de ```mariaDB``` se ejecutará automaticamente el archivo ```.devcontainer/mariadb/config/db/docker-entrypoint-initdb.d/db_init.sql```. De momento se utiliza en el punto de partida para crear tablas de configuración de phpMyAdmin y asignar privilegios sobre ellas al usuario configurado en la variable ```MARIADB_USER``` del archivo de variables de entorno de la base de datos ```.mariadb.env```. Si crees que estas tablas deberían crearse en otro momento o contexto, eres libre de editarlo si sabes lo que estás haciendo.

> **Note:** Se recomienda encarecidamente no desplegar phpMyAdmin en entornos de producción. Debería sernos sólo de utilidad para trabajar sólo dentro de entornos de desarrollo.

Con el tiempo iré añadiendo a este proyecto otras opciones de docker compose, más adecuadas para el despliegue en entornos de producción. Siéntete libre de adaptar compose para entornos de producción pero ten en cuenta las advertencias de seguridad, como evitar despliegues de phpMyAdmin.

## 6. Proyectos frontend y backend
Las imágenes utilizadas en los contenedores frontend y backend sirven para trabajar con Laravel y Vue + Vite, aunque los servicios de ambos proyectos coexisten en el mismo servidor proxy nginx, son proyectos que deberían estar en repositorios completamente diferentes. 

Antes de componer los contenedores es importante tener listas las carpetas con ambos proyectos, ya que los contenedores frontend y backend se montarán estas carpetas como volúmenes.

### 6.1. Generación de proyectos por primera vez
Puede generar nuevos proyectos Laravel y Vue utilizando los scripts bash ```.generate_first_time_backend.sh``` y ```.generate_first_time_frontend.sh```. Se utilizan imágenes de Docker para generar los proyectos, gracias a esto no necesitarás tener ninguna dependencia asociada a ellos en tu sistema.

- Para generar un **nuevo proyecto de Laravel** usa el comando:

```sh
./.generate_first_time_backend.sh
```
 
- Para generar un **nuevo proyecto de Vue + Vite** usa el comando:

```
./.generate_first_time_frontend.sh
```

Es importante tener en cuenta que el fichero de configuración de vite en ```.devcontainer/config/vite.config.template.js``` está montado en el contenedor frontend usando volúmenes. Cuando el contenedor frontend arranca, copia el archivo a ```${PROJECT_NAME}_frontend/vite.config.js``` usando ```envsubst``` para convertir las variables de entorno a los datos a los que apuntan. Así que si vas a cambiarlo debes reiniciar el contenedor para que surtan efecto.

Cómo trabajar con Laravel o Vue está fuera del alcance de este documento.

### 6.2. Incluir proyectos Laravel y Vue ya existentes
Puedes añadir tus proyectos creando submódulos de git que apunten a ellos. Recuerda que los nombres de las carpetas deben ser ```${PROJECT_NAME}_backend``` y ```${PROJECT_NAME}_frontend```. Como se ha indicado anteriormente, ```PROJECT_NAME``` puede configurarse en ```./devcontainer/.env```.

Escribe estos comandos para crear submódulos git desde la raíz del proyecto:

```sh
git submodule add https://github.com/user/frontAPP ProjectName_frontend
git submodule add https://github.com/user/backAPI ProjectName_backend
```

## 7. Contribuir a este repositorio
Siéntete libre de contribuir a este proyecto con cualquier cambio. Haz un fork del repositorio y clónalo en tu ordenador, haz los cambios que creas oportunos y crea un [pull request](https://www.freecodecamp.org/espanol/news/como-hacer-tu-primer-pull-request-en-github/).