# Database Guide

## MongoDB


### Start MongoDB Service
To start the service, execute this command:
``` bash
sudo service mongod start
```

To enter MongoDB shell terminal, execute this command:
``` bash
mongo --port 29000
```

### Load Script
In MongoDB shell, execute this command:
``` bash
load("path/to/script")
```
In our example, it is:
``` bash
load("/home/ybc/Project/Owlies_Server/database/mongodbTowerGirl.js")
```
Remember to replace my home directory path to the correct one.

If the command line returns "true", it means all the statements inside js file are executed successfully.

### Stop MongoDB Service
Run this command:
``` bash
sudo service mongod stop
```
