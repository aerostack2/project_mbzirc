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
    robot.takeoff(height=30, speed=3.0)
    
    print("Mission complete")

    robot.shutdown()
    rclpy.shutdown()

    exit(0)