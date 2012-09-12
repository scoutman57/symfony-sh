symfony-sh
==========

Several Bash scripts to be used with Symfony 2.1

symfony-git.sh
---------------

This script installs Symfony 2.1.1 with git support and favorite compatible bundles.

In order to use this script follow this steps:

- Copy this script in the path where symfony is going to be installed
- The following console commands must be available:

```
# This script depends on the next console commands to run correctly:
# wget
# tar
# mv
# php 5.3+
# rm
# cd
# touch
# git
# curl
# chmod +a or setfacl
```

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

Basically this script automatically does all steps defined on the symfony documentation:

http://symfony.com/doc/current/book/installation.html

http://symfony.com/doc/current/cookbook/workflow/new_project_git.html

At the end, you will have a new Symfony installation ready to be used on a new project and save your changes on git.

This script installs the following compatible bundles: FOSUserBundle, DoctrineMigrationsBundle and DocrineFixturesBundle.

As soon as more mature and popular bundles begin to offer symfony 2.1 support and installation through Composer, they will be add it 
to this script.
