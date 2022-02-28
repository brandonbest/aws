# SSH into Fargate

fargate.sh allows you to SSH into a fargate instance.

Copy `fargate.sh` onto your desktop and run the following commands:

```
cp fargate.sh /usr/local/bin/fargate;
chmod +x /usr/local/bin/fargate;
```

### Running the Script

Before you run the script, make sure you have control tower setup (https://github.com/brandonbest/aws-cli). You may need to run this command first to connect to control tower:

```
controltower
```

Then SSH into an Fargate instance:

```
fargate <service webapp|contacts> <cluster apps-prod|apps-beta|apps-stage> <profile>
```

### Help

You can always lookup information about this script using:

```
fargate -h
```
