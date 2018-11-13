Oracle Enterprise Edition 11g Release 2
============================

Oracle Enterprise Edition 11g Release 2 on Oracle Linux

This is a clone from https://github.com/MaksymBilenko/docker-oracle-ee-11g that has had some small changes.

### Building
You will need to download the following Oracle files to the oracle-11g-ee-base directory.  You can get them from Oracle from https://www.oracle.com/technetwork/database/enterprise-edition/downloads/112010-linx8664soft-100572.html after accepting their license.
```bash
linux.x64_11gR2_database_1of2.zip
linux.x64_11gR2_database_1of2.zip
```
In projet root directory
```bash
docker build oracle-11g-ee-base -t howarddeiner/oracle-11g-ee-base
docker build . -t howarddeiner/oracle-11g-ee
````

### Installation

```bash
docker pull howarddeiner/oracle-11g-ee
```
Run with 8080 and 1521 ports opened.  Watch the logs to see when the database is initialized.  The first time through, this will take a few minutes.
```bash
docker run -d -p 8080:8080 -p 1521:1521 --name oracle-11g-ee-test howarddeiner/oracle-11g-ee 
docker logs -f oracle-11g-ee-test
```
The console output from above...
```bash
Preparing oracle installer.
Running root scripts.
Changing permissions of /u01/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /u01/app/oraInventory to dba.
The execution of the script is complete.
Check /u01/app/oracle/product/11.2.0/EE/install/root_25e6cce03000_2018-11-13_16-15-06.log for the output of root script
ls: cannot access /u01/app/oracle/oradata: No such file or directory
Database not initialized. Initializing database.
Starting tnslsnr
Running initialization by dbca
/bin/cat: /proc/sys/net/core/wmem_default: No such file or directory
/bin/cat: /proc/sys/net/core/wmem_default: No such file or directory
/bin/cat: /proc/sys/net/core/wmem_default: No such file or directory
Copying database files
1% complete
3% complete
37% complete
Creating and starting Oracle instance
40% complete
45% complete
50% complete
55% complete
56% complete
60% complete
62% complete
Completing Database Creation
66% complete
70% complete
73% complete
85% complete
96% complete
100% complete
Look at the log file "/u01/app/oracle/cfgtoollogs/dbca/EE/EE.log" for further details.
Starting web management console

PL/SQL procedure successfully completed.

Starting import from '/docker-entrypoint-initdb.d':
found file /docker-entrypoint-initdb.d//docker-entrypoint-initdb.d/*
[IMPORT] /entrypoint.sh: ignoring /docker-entrypoint-initdb.d/*

Import finished

Database ready to use. Enjoy! ;)
```
Run with data on host and reuse it:
```bash
docker run -d -p 8080:8080 -p 1521:1521 -v /my/oracle/data:/u01/app/oracle howarddeiner/oracle-11g-ee
```
Run with Custom DBCA_TOTAL_MEMORY (in Mb):
```bash
docker run -d -p 8080:8080 -p 1521:1521 -v /my/oracle/data:/u01/app/oracle -e DBCA_TOTAL_MEMORY=1024 howarddeiner/oracle-11g-ee
```
Connect database with following setting:
```bash
    hostname: localhost
    port: 1521
    sid: EE
    service name: EE.oracle.docker
    username: system
    password: oracle
```
To connect using sqlplus:
```bash
sqlplus system/oracle@//localhost:1521/EE.oracle.docker
```
Password for SYS & SYSTEM:
```
    oracle
```
Connect to Oracle Enterprise Management console with following settings:
```bash
    http://localhost:8080/em
    user: sys
    password: oracle
    connect as sysdba: true
```
By Default web management console is enabled. To disable add env variable:
```bash
    docker run -d -e WEB_CONSOLE=false -p 1521:1521 -v /my/oracle/data:/u01/app/oracle howarddeiner/oracle-11g-ee
    #You can Enable/Disable it on any time
```
Start with additional init scripts or dumps:
```bash
docker run -d -p 1521:1521 -v /my/oracle/data:/u01/app/oracle -v /my/oracle/init/SCRIPTSorSQL:docker-entrypoint-initdb.d howarddeiner/oracle-11g-ee
```
By default Import from `docker-entrypoint-initdb.d` enabled only if you are initializing database(1st run). If you need to run import at any case - add `-e IMPORT_FROM_VOLUME=true`
**In case of using DMP imports dump file should be named like ${IMPORT_SCHEME_NAME}.dmp**
**User credentials for imports are  ${IMPORT_SCHEME_NAME}/${IMPORT_SCHEME_NAME}**

If you have an issue with database init like DBCA operation failed, please reffer to this [issue](https://github.com/MaksymBilenko/docker-oracle-11g/issues/16)



**TODO LIST (from original project)**
* Web management console HTTPS port
* Add functionality to run custom scripts on startup, for example User creation
* Add Parameter that would setup processes amount for database (Currently by default processes=300)
* Spike with clustering support
* Spike with DB migration from 11g


