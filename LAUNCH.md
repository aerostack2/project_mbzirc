# HOW TO LAUNCH SIMULATION WITH MBZIRC OFFICIAL LAUNCHERS
### Sources:
```
source /opt/ros/galactic/setup.bash
source ~/mbzirc_ws/install/setup.bash
source ~/as2_ws/install/setup.bash
```

### Launch
First option:
```
ros2 launch mbzirc_ros competition_local.launch.py ign_args:="-v 4 -r coast.sdf"
ros2 launch mbzirc_ign spawn_config.launch.py world:=coast config_file:=config/mbzirc_demo_1.yaml
```

Second option:
```
ros2 launch mbzirc_ign competition.launch.py world:=coast config_file:=config/mbzirc_demo_1.yaml
```

```
ros2 launch mbzirc_ign competition.launch.py world:=simple_demo config_file:=config/test.yaml
```