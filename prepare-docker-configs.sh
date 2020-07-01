#!/bin/bash
templateConfig=/ska/config/config-docker.ini
config=/ska/config/config.ini

templateApacheConfig=config/apache-vhost.conf
apacheConfig=/etc/apache2/sites-available/000-default.conf

function replaceEnvVars() {
    awk '{while(match($0,"[$]{[^}]*}")) {var=substr($0,RSTART+2,RLENGTH -3);gsub("[$]{"var"}",ENVIRON[var])}}1' $1 > $2
}

replaceEnvVars $templateConfig $config
echo "config.ini diff"
colordiff $templateConfig $config

replaceEnvVars $templateApacheConfig $apacheConfig
echo "Apache vhost diff"
colordiff $templateApacheConfig $apacheConfig

# Required to execute the CMD docker-php-entrypoint attached to the current process so that exit signals are correctly forwarded
exec "$@"