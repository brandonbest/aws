# Parameter Store Helpers

fargate.sh allows you to SSH into a fargate instance.

Copy `fargate.sh` onto your desktop and run the following commands:

```
cp ssm-get.sh /usr/local/bin/ssm-get;
cp ssm-put.sh /usr/local/bin/ssm-put;
chmod +x /usr/local/bin/ssm-get;
chmod +x /usr/local/bin/ssm-put;
```

### Preparing to Run the Script

Before you run the script, make sure you have control tower setup (https://github.com/brandonbest/aws-cli). You may need to run this command first to connect to control tower:

```
controltower
```

### Help

You can always lookup information about this script using:

```
ssm-get -h
ssm-put -h
```
