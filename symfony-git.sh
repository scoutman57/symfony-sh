#-------------------------------------------------------
# Create and store a Symfony 2.1 Project in git using sh
#-------------------------------------------------------
#!/bin/sh

# Please modify this vars to match your desired configuration
symfony_url="http://symfony.com/download?v=Symfony_Standard_2.1.0.tgz"
webserver_user="daemon" #www-data, apache, anonymous
server="macosx" # macosx, linux

#----------------------------------------------------------------------
# Requirements 
#----------------------------------------------------------------------

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

# You need root access (sudo) to set permissions for cache and logs folder

# You need to comply with symfony requirements. Check this:

# http://symfony.com/doc/current/reference/requirements.html

#---------------------------------------------------------
# Please don't modify anything  below unless you know what
# you are doing....
#---------------------------------------------------------
set -e

Colors() {
    Escape="\033";

    BlackF="${Escape}[30m";   RedF="${Escape}[31m";   GreenF="${Escape}[32m";
    YellowF="${Escape}[33m";  BlueF="${Escape}[34m";    Purplef="${Escape}[35m";
    CyanF="${Escape}[36m";    WhiteF="${Escape}[37m";

    BlackB="${Escape}[40m";     RedB="${Escape}[41m";     GreenB="${Escape}[42m";
    YellowB="${Escape}[43m";    BlueB="${Escape}[44m";    PurpleB="${Escape}[45m";
    CyanB="${Escape}[46m";      WhiteB="${Escape}[47m";

    BoldOn="${Escape}[1m";      BoldOff="${Escape}[22m";
    ItalicsOn="${Escape}[3m";   ItalicsOff="${Escape}[23m";
    UnderlineOn="${Escape}[4m";     UnderlineOff="${Escape}[24m";
    BlinkOn="${Escape}[5m";   BlinkOff="${Escape}[25m";
    InvertOn="${Escape}[7m";  InvertOff="${Escape}[27m";

    Reset="${Escape}[0m";
}
Colors;

echo -e ${GreenF}"Downloading" $symfony_url${Reset};
wget  -q --output-document=symfony.tar.gz $symfony_url 

echo -e ${GreenF}"Uncompressing symfony file"${Reset};
tar zxf symfony.tar.gz

echo -e ${GreenF}"Renaming Symfony folder"${Reset};
mv Symfony symfony

echo -e ${GreenF}"Deleting compressed file"${Reset};
rm -rf symfony.tar.gz

echo -e ${GreenF}"Entering symfony/ folder"${Reset};
cd symfony/

echo -e ${GreenF}"Creating .gitignore file"${Reset};
touch .gitignore
echo "/web/bundles/
/app/bootstrap*
/app/cache/*
/app/logs/*
/vendor/
/app/config/parameters.yml" >> .gitignore

echo -e ${GreenF}"Copy parameters.yml to parameters.yml.dist"${Reset};
cp app/config/parameters.yml app/config/parameters.yml.dist

echo -e ${GreenF}"Git init and first commit"${Reset};
git init -q
git add .
git commit -q -m "Initial commit"

echo -e ${GreenF}"Installing composer"${Reset};
curl -s http://getcomposer.org/installer | php

echo -e ${GreenF}"Setting cache and log permissions. This command is run with sudo so a password is required."${Reset};
rm -rf app/cache/*
rm -rf app/logs/*
if [ $server = "macosx" ]
then
    sudo chmod +a "$webserver_user allow delete,write,append,file_inherit,directory_inherit" app/cache app/logs
    sudo chmod +a "`whoami` allow delete,write,append,file_inherit,directory_inherit" app/cache app/logs
elif [ $server = "linux" ]
then
    sudo setfacl -R -m u:$webserver_user:rwx -m u:`whoami`:rwx app/cache app/logs
    sudo setfacl -dR -m u:$webserver_user:rwx -m u:`whoami`:rwx app/cache app/logs
else
    echo -e ${RedF}"Server specified not supported. Exiting"${Reset};
    exit 1
fi

echo -e ${GreenF}"Creating vendor folder and installing all Symfony 2.1 dependencies"${Reset};
php composer.phar install

echo -e ${GreenF}"Installing FOSUser bundle ==> https://github.com/FriendsOfSymfony/FOSUserBundle/"${Reset};
php composer.phar require  friendsofsymfony/user-bundle:*

echo -e ${GreenF}"Second commit to add php.phar and update composer files"${Reset};
git add .
git commit -q -m "Second commit to add php.phar and update composer files"

echo -e ${GreenF}"Reporting installed components"${Reset};
php composer.phar show --installed

echo -e ${GreenF}"Installation Finished!"${Reset};
echo -e ${GreenF}"---------------------------------------------------------"${Reset};

echo -e ${GreenF}"Please Create an alias.localhost (replace alias for another name that suits your needs) in /etc/hosts"${Reset};
echo -e ${GreenF}"Then, create a virtual host in Apache to access your local installation from browser"${Reset};
echo -e ${GreenF}"This is a vhost sample (please change to suite your SPECIFIC paths and names):"${Reset};
echo "
<VirtualHost *:80>
    DocumentRoot "/path-where-you-put-this-script/symfony/web"
    ServerName alias.localhost
    DirectoryIndex app.php
    <Directory "/path-where-you-put-this-script/symfony/web">
        Options Indexes FollowSymlinks
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
    ErrorLog "path-to-error.-log/error_log"
    CustomLog "path-to-access-log/access_log" common
</VirtualHost>
"
echo -e ${GreenF}"Don't forget to run app/check.php inside Symfony folder for aditional requirements"${Reset};
echo -e ${GreenF}"If you think your php installation has all requirements, go with your browser to http://alias.localhost/app_dev.php to see the Acme Demo"${Reset};

