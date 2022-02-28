# Video of Setup

This video walks you through setting up Control Tower and connecting to the EC2 tunnel

https://vimeo.com/657617542/3c3816c052


# Control Tower Setup

This script sets up two profiles for the AWS CLI tools.

Copy `controltower.sh` onto your desktop and run the following commands:

```
cp controltower.sh /usr/local/bin/controltower;
chmod +x /usr/local/bin/controltower;
```

### Running the Script

```
controltower
```


# RDS SSH Tunnel Setup

Copy `rds.sh` onto your desktop and run the following commands:

```
cp rds.sh /usr/local/bin/rds;
chmod +x /usr/local/bin/rds;
```

### Running the Script

```
rds <aws profile: profile name> <RDS Cluster Name>
```

For example:

```
rds brandon brandon-prod
```
