## SMALL OBJECT

Drone configuration can be modified in `quadrotor.yaml`.

Launch simulation:
```
.\small_object_launch.bash
```

Objects are attached until the vessel is identified, for testing porpouses you can detach with:
```
ign service -s /world/simple_demo/remove --reqtype ignition.msgs.Entity --reptype ignition.msgs.Boolean --timeout 300 --req 'name: "box1kg" type: MODEL'
```

Enable suction:
```
ros2 topic pub --once /quadrotor_1/gripper/suction_on std_msgs/msg/Bool 'data: True'
```

Takeoff:
```
ros2 topic pub --once /quadrotor_1/cmd_vel geometry_msgs/msg/Twist '{linear: {x: 0.0, y: 0.0, z: 5}, angular: {x: 0.0, y: 0.0, z: 0.0}}'
```

## LARGE OBJECT

Launch simulation:
```
.\large_object_launch.bash
```

Finger gripper:
```
ros2 topic pub --once /hexrotor_1/gripper/joint/finger_left/cmd_pos std_msgs/msg/Float64 'data: 0.5'
ros2 topic pub --once /hexrotor_1/gripper/joint/finger_right/cmd_pos std_msgs/msg/Float64 'data: 0.5'
```