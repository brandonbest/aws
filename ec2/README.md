# SSH into ECS

ecs.sh allows you to SSH into an EC2 instance.

Copy `ecs.sh` onto your desktop and run the following commands:

```
cp ecs.sh /usr/local/bin/ecs;
chmod +x /usr/local/bin/ecs;
```

### Running the Script

Before you run the script, make sure you have control tower setup (https://github.com/brandonbest/aws). You may need to run this command first to connect to control tower:

```
controltower
```

Then SSH into an ECS instance:

```
ecs <service brandonbest> <cluster prod> <profile brandon>
```


### Help

You can always lookup information about this script using:

```
ecs -h
```
