HOST_NAME=$1
USER_NAME=$2
KEY_ID=$3
ACCESS_KEY=$4
REGION=$5
BUCKET=$6

echo $HOST_NAME
echo $USER_NAME

cause_an_error

date > test.sh.log
echo "test run" >> test.sh.log

AWS_ACCESS_KEY_ID=$KEY_ID \
AWS_SECRET_ACCESS_KEY=$ACCESS_KEY \
aws s3 cp --region $REGION \
test.sh.log s3://$BUCKET


