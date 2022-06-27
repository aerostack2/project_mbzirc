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
./launch_ignition.bash ./config/coast.json
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

## Launch instructions (MBZIRC)
```bash
ros2 launch mbzirc_ros competition_local.launch.py ign_args:="-v 4 -r simple_demo.sdf"
```

```bash
ros2 launch mbzirc_ign spawn.launch.py sim_mode:=sim bridge_competition_topics:=False name:=drone_sim_0 world:=simple_demo model:=mbzirc_quadrotor type:=uav x:=1 y:=2 z:=1.05 R:=0 P:=0 Y:=0 slot0:=mbzirc_hd_camera slot1:=mbzirc_rgbd_camera
```

**NOTE:** Drone is not moving since MBZIRC quadrotor and hexrotor do not have odometry plugin. The lack of odometry makes the controller to not send actuator commands to the platform.

## AS2 Node Graph

![as2-node-graph](docs/as2v010_2.png)
