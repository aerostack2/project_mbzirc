# project_mbzirc

AS2 project for the MBZIRC22 Maritime Grand Challenge. It gathers all the needed launch scripts to run the simulation. This branch launch the simulation demo for 30/06/2022.

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

Launch ignition using a config file to setup the ignition environment. Details of how to configure the config file can be checked in [ignition-assets](https://github.com/aerostack2-developers/ignition_assets#config-file).

- Launch Ignition Gazebo simulator:
```
./launch_ignition.bash ./config/demo_mbzirc.json
```

Launch AS2 nodes, one instance for the USV and others for each drone.

- Launch AS2:
```
./mbzirc_demo.bash
```

- Launch AS2 detection nodes:
```
.YOLO_inference/detections_launch.bash
```

Publish each Vessel position (simulating the radar).

- Publish Vessel A position:
```
ros2 topic pub /usv/vessel_A/pose geometry_msgs/msg/PoseStamped "{header: {stamp: {sec: 0, nanosec: 0}, frame_id: ''}, pose: {position: {x: -1340.0, y: 300.0, z: 10.0}, orientation: {x: 0.0, y: 0.0, z: 0.0, w: 1.0}}}"
```

- Publish Vessel B position:
```
ros2 topic pub /usv/vessel_B/pose geometry_msgs/msg/PoseStamped "{header: {stamp: {sec: 0, nanosec: 0}, frame_id: ''}, pose: {position: {x: -1290.0, y: 85.0, z: 10.0}, orientation: {x: 0.0, y: 0.0, z: 0.0, w: 1.0}}}"
```

Start mission.

- Publish USV goal position:
```
ros2 topic pub --once /usv/mission/start as2_msgs/msg/MissionEvent "{header: {stamp: {sec: 0, nanosec: 0}, frame_id: ''}, data: '-1250;350;0'}" 
```

End mission.

- Stop AS2 nodes:
```
./stop
```