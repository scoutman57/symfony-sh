symfony-sh
==========

Several Bash scripts to be used with Symfony 2.1

symfony-git.sh
---------------

This script installs Symfony 2.1 with git support and favorite compatible bundles.

In order to use this script follow this steps:

- Copy this script in the path where symfony is going to be installed
- Open the script and define/modify the following parameters:

```
# Path where this script is going to run and where symfony/ folder will be installed
root_path="/var/www/github/symfony-sh" 

# Symfony 2.1 without vendors download link 
symfony_url="http://symfony.com/download?v=Symfony_Standard_2.1.0.tgz"

# Webserver user, usually www-data (other usual users: daemon, apache, anonymous)
webserver_user="daemon"

# OS where this script will run. Options: macosx or linux 
# It is used for the cache/ logs/ permission strategy
server="macosx"
```

- Give permission to the script and execute it.

```
chmod 755 symfony-git.sh
./symfony-git.sh
```