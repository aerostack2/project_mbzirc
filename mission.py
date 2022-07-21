#!/bin/python3

import rclpy,sys
import numpy as np
from time import sleep
import threading
from python_interface.drone_interface import DroneInterface

if __name__ == '__main__':

    rclpy.init()
    # load robot namespace
    if len(sys.argv) < 2:
        print("Usage: python3 mission.py <robot_name>")
        sys.exit(1)
    namespace = sys.argv[1]

    # create drone interface
    print ("Creating drone interface for namespace: " + namespace)
    robot = DroneInterface(namespace)

    robot.offboard()
    robot.arm()
    print("Taking off")
    robot.takeoff(height=7, speed=2.0)
    position_goal = np.array([-1500, 15, 5.0])
    print("Going to position: " + str(position_goal))
    robot.go_to(position_goal[0], position_goal[1], position_goal[2],speed=2.0)
    print("Landing")
    robot.land(0.2)
    
    print("Mission complete")

    robot.shutdown()
    rclpy.shutdown()

    exit(0)
