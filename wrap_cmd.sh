#!/bin/bash

NAME=$1
SCRIPT=$2

source $HOME/.ssec2

echo "#!/bin/bash
ERR()
{
    set +e

    AWS_ACCESS_KEY_ID=$DATA_STORE_KEY_ID \
    AWS_SECRET_ACCESS_KEY=$DATA_STORE_ACCESS_KEY \
    aws s3 cp --region us-west-1 \
    $NAME.\$EC2_INSTANCE_ID.out s3://$DATA_BUCKET

    AWS_ACCESS_KEY_ID=$DATA_STORE_KEY_ID \
    AWS_SECRET_ACCESS_KEY=$DATA_STORE_ACCESS_KEY \
    aws s3 cp --region us-west-1 \
    $NAME.\$EC2_INSTANCE_ID.err s3://$DATA_BUCKET


    shutdown -h now
}

trap ERR EXIT
"

echo '
EC2_INSTANCE_ID="`wget -q -O - http://instance-data/latest/meta-data/instance-id || die \"wget instance-id has failed: $?\"`"
'

echo "
cd $AMI_WORKING_DIR

touch .running

SSEC2_F()
{
"

cat $SCRIPT

echo "}

SSEC2_F ${@:3} > $NAME.\$EC2_INSTANCE_ID.out 2> $NAME.\$EC2_INSTANCE_ID.err"

