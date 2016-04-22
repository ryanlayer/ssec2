#!/bin/bash

source $HOME/.ssec2

echo '#!/bin/bash
ERR()
{
    set +e

    LOG_TEST=`declare -f LOG | wc -l`

    if [ "$LOG_TEST" -ne "0" ]
    then
        LOG
    fi
    
    shutdown -h now
}

trap ERR EXIT

'
echo "
cd $AMI_WORKING_DIR

touch .running

SSEC2_F()
{
"

cat $1

echo "}

SSEC2_F ${@:2}"
