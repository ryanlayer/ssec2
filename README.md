
## Dependencies

### Software
https://aws.amazon.com/cli/

https://stedolan.github.io/jq/

### AWS
You will need:
* an [s3 bucket](http://docs.aws.amazon.com/AmazonS3/latest/gsg/CreatingABucket.html)
* an [ec2 key pair](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
* a [security group](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html) with a rule that AT LEAST allows in ssh (I allow only ssh in and all out)

## Setup

Set the following values in `$HOME/.ssec2`

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
LOG_FILE=$HOME/.ssec2_history
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

Launch an instance that runs a script, in this case `prime.sh`:

```
source $HOME/.ssec2

$ ssec2 launch \
    -n find_primes_to_1000 \
    prime.sh \
    1000
```

`-n ` is the name given to this run, which is required

`prime.sh` is the script that will run (as root in `$AMI_WORKING_DIR`)

The rest of the options are passed directly to `prime.sh` as command line
arguments which `prime.sh` is ready to accept.

Every instance launched with a script will also retain the output from STDERR
and STDOUT and store them to
`s3://$DATA_BUCKET/find_primes_to_1000.instance_id.err` and
`s3://$DATA_BUCKET/find_primes_to_1000.instance_id.out`.

If the instance was named `i-2394b13`, then you should be able to get the
results by

```
$ aws s3 cp s3://find_primes_to_1000.i-2394b13.out .
$ cat find_primes_to_1000.i-2394b13.out 2 3 5 7 11 13 17 19 23 29 31 37 41 43
47 53 59 61 67 71 73 79 83 89 97 101 103 107 109 113 127 131 137 139 149 151
157 163 167 173 179 181 191 193 197 199 211 223 227 229 233 239 241 251 257 263
269 271 277 281 283 293 307 311 313 317 331 337 347 349 353 359 367 373 379 383
389 397 401 409 419 421 431 433 439 443 449 457 461 463 467 479 487 491 499 503
509 521 523 541 547 557 563 569 571 577 587 593 599 601 607 613 617 619 631 641
643 647 653 659 661 673 677 683 691 701 709 719 727 733 739 743 751 757 761 769
773 787 797 809 811 821 823 827 829 839 853 857 859 863 877 881 883 887 907 911
919 929 937 941 947 953 967 971 977 983 991 997
```
