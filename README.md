# project_mbzirc

## Launch instructions 

Launch assets for MBZIRC22 project.

- Launch Ignition gazebo simulator:
```
./launch_ignition.bash
```
Launch ignition script uses a config file to setup the ignition environment. Details of how to configure the config file can be checked in [ignition-assets](https://github.com/aerostack2-developers/ignition_assets#config-file).


- Launch AS2:
```
./main_launcher.bash <number-of-as2-instances:=1>
```
Each instance represents a drone.


- Stop AS2 nodes:
```
./stop
```

## AS2 Node Graph

![as2-node-graph](docs/as2v010_2.png)
