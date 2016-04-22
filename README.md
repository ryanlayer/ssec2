
## Dependencies

https://aws.amazon.com/cli/

https://stedolan.github.io/jq/


## Setup

Set the followin values in `$HOME/.ssec2`

```
DATA_STORE_KEY_ID=
DATA_STORE_ACCESS_KEY=
DATA_REGION=
DATA_BUCKET=
KEY_NAME=
KEY_PATH=
KEY_LOCATION=
AMI=
AMI_REGION=
AMI_USER_NAME=
AMI_WORKING_DIR=
SECURITY_GROUP=
LOG_FILE=
```

## Examples

### Get the current status

```
$ ssec2

us-east-1   Fri Apr 22 15:27:05 MDT 2016
Running        0
Pending        1
```

or

```
$ ssec2 connect

us-east-1   Fri Apr 22 15:27:30 MDT 2016
Running        1
Pending        0
```

The `-l` option gives per instance information, but is slow

```
$ ssec2 connect -l

ID          Launch Time               State           Type            CPU
i-a55be038  2016-04-22T21:26:38.000Z  running         t2.micro        3.915
```

### Launch an instance, get the info, connect, then terminate

Spin up a new instance 
```
$ ssec2 launch
```

Get the instance id
```
$ ssec2 connect -l

ID          Launch Time               State           Type            CPU
i-a55be038  2016-04-22T21:26:38.000Z  running         t2.micro        3.915
```

Connect to the instance
```
$ ssec2 connect -i i-a55be038
```

Terminate it
```
$ ssec2 connect -i i-a55be038 -t

$ ssec2 connect -l
ID          Launch Time               State           Type            CPU
i-a55be038  2016-04-22T21:26:38.000Z  shutting-down   t2.micro        .
```

### Have an instance run a script then terminate

Launch an instance that runs a srcipt, in this case `test.sh`:

```
source $HOME/.ssec2

$ ssec2 launch \
    -n test \
    test.sh \
    $HOSTNAME \
    $USER \
    $DATA_STORE_KEY_ID \
    $DATA_STORE_ACCESS_KEY \
    $DATA_REGION \
    $DATA_BUCKET
```

`-n test` is the name given to this run, which is required

`test.sh` is the script that will run (as root in `$AMI_WORKING_DIR`)

The rest of the options are passed directly to `test.sh` as command line
arguments which `test.sh` is ready to accept.

Every instance launched with a script will also retain the output from STDERR
and STDOUT and store thme to `s3://$DATA_BUCKET/test.instance_id.err` and
`s3://$DATA_BUCKET/test.instance_id.out`.
