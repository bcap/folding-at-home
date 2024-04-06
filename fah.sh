#!/bin/bash

set -e

APP_DIR=${APP_DIR:-/app}
FAH_DIR=${FAH_DIR:-/fah}
CONFIG=${APP_DIR}/config.xml

function replace_var() {
    var="$1"
    if [ -z "${!var}" ]; then
        echo "Error: env var $var is not set" >&2
        return 1
    fi
    sed "s/{${var}}/${!var}/g" $CONFIG > $CONFIG.tmp && mv $CONFIG.tmp $CONFIG
}

cp ${APP_DIR}/config-template.xml $CONFIG

replace_var "FAH_USER"
replace_var "FAH_TEAM"
replace_var "FAH_PASSKEY"
replace_var "FAH_COMMAND_PASSWORD"

${APP_DIR}/FAHClient --config=$CONFIG --chdir $FAH_DIR
