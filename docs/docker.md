# How to setup Postgres database in Docker for ce-api

## Installation of Docker
1. Get **Docker Desktop** from [official website](https://www.docker.com/products/docker-desktop)
2. Run the Docker Desktop .exe (you will need admin rights on your PC)
3. Restart PC to enable Hyper-V (if the virtualization isn't allowed, you need to change this in the BIOS of your PC)
4. Add your user (not the admin account) to the docker-users group   
    a. Run lusrmgr.msc  
    b. Open Group and find docker-users  
    c. Right-click to open the settings window and add your user 

## Run Postgres and pgAdmin4 in a container
1. Create a new folder (e.g. ce-database)
2. Create a [docker-compose.yml](../docker/docker-compose.yml) and [.env](../docker/.env)
3. Run docker-compose up (you will need access to the airbus network) and allow Docker Desktop to share the ./data folder  
    a. If you don't have access to the airbus network, remove the *docker.artifactory.2b82.aws.cloud.airbus.corp/* at the image tag in the docker-compose.yml

## Setup the database with pgAdmin
1. Open pgAdmin in your browser: http://localhost:3306
2. Login using the email/password set in the .env file (e.g. pgadmin/admin)
3. Add your local Postgres container by right clicking Servers -> Create -> Server...   
    a. General -> Name: Your choice (e.g. Postgres 12)  
    b. Connection -> Hostname: postgres  
    c. Connection -> Username: postgres  
    d. Connection -> Password: admin
4. After you saved your server settings, restore the database dump by right clicking postgres -> Restore...  
    a. Open your windows explorer and copy the two dumps (dump_db.backup, dump_data_coreelec-schema.backup) into the folder ./data/storage/pgadmin  
    b. In pgAdmin: General -> Filename -> /dump_db.backup

## Use the local postgres container as your database in ce-api-*
1. Create a .env file in the docker directory of the application
```yaml
# Test
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=capital
PGDATA=/data/postgres

PGADMIN_DEFAULT_EMAIL=admin@airbus.com
PGADMIN_DEFAULT_PASSWORD=admin

POSTGRES_PORT=5432
PGADMIN_PORT=3306

## For Flyway container
FLYWAY_LOCATIONS=filesystem:/tmp/database/server, filesystem:/tmp/database/local
FLYWAY_URL=jdbc:postgresql://postgres_capital:5432/capital
FLYWAY_USER=postgres
FLYWAY_PASSWORD=postgres
```
2. Now you can run *npm run start:dev* and your local database will be used

## How to run psql
1. docker exec -it postgres_container bash
2. psql -U postgres -d postgres
