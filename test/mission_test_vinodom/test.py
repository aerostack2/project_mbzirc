#!/bin/python3

import rclpy
import sys
import numpy as np
from time import sleep
import threading
from python_interface.drone_interface import DroneInterface
from as2_msgs.msg import TrajectoryWaypoints

n_uavs = 1
offset = 0


def drone_run(drone_interface, n_uav):

    takeoff_height = 6.0
    height = 10.0
    speed = 2.0

    print(f"Start mission {n_uav}")
    drone_interface.offboard()
    drone_interface.arm()
    print(f"Take Off {n_uav}")
    drone_interface.takeoff(takeoff_height, speed=0.5)
    print(f"Take Off {n_uav} done")

    goto_list = [
        [0.0, 50.0, height],
        # [-1475.0, 100.0, height],

        # [-1452.0, 0.0, 10.0],
        # [-1452.0, 0.0, 6.0],
        # [-1350.0, 0.0, 10.0],

        # [-1380.0, 20.0, height],
        # [-1470.0, 2.0, height],
        # [-1475.0, 2.0, height],
    ]

    for wp in goto_list:
        print(f"Go to {n_uav}: [{wp[0]},{wp[1]},{wp[2]}]")
        drone_interface.go_to_point(
            [wp[0], wp[1], wp[2]], speed=speed, ignore_yaw=False)
        print(f"Go to {n_uav} done")
        sleep(1.0)

    # sleep(1.0)
    # print(f"Land {n_uav}")
    # drone_interface.land(speed=0.5)
    # print(f"Land {n_uav} done")

    print("Clean exit")


if __name__ == '__main__':
    rclpy.init()
    # load robot namespace
    if len(sys.argv) < 2:
        print("Usage: python3 mission.py <robot_name>")
        namespace = "quadrotor_1"
    else:
        namespace = sys.argv[1]

    # create drone interface
    print("Creating drone interface for namespace: " + namespace)
    robot = DroneInterface(namespace)

    drone_run(robot, 0)

    # n_uavs.shutdown()
    rclpy.shutdown()
    exit(0)
