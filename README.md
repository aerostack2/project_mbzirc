# project_mbzirc

AS2 project for the MBZIRC22 Maritime Grand Challenge. It gathers all the needed launch scripts to run the simulation.

## Installation

### Prerequisites

* AeroStack2 (Alpha release v0.1.0) [link](https://github.com/aerostack2-developers/aerostack2/wiki/Install-Aerostack2)
* MBZIRC official repository [link](https://github.com/osrf/mbzirc#installation-from-source)

### Sourcing

Sourcing setup bash files it is needed to find packages and enviroment variables. Include them in your `~/.bashrc` or run them before each execution. Three sources are needed:

```bash
source /opt/ros/${ROS_DISTRO}/setup.bash  # galactic
source ~/as2_ws/install/setup.bash
source ~/mbzirc_ws/install/setup.bash
```

## Launch instructions 

Launch assets for MBZIRC22 project.

- Launch Ignition Gazebo simulator:
```
./launch/launch_ignition.bash simple_demo ./config/one_drone.yaml
```
Launch ignition script uses a config file to setup the ignition environment. Details of how to configure the config file can be checked in [mbzirc wiki](https://github.com/osrf/mbzirc/wiki/UAV-and-USV-Payload-Configurations#configuring-a-group-of-vehicles-via-yaml).


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
