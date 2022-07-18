#!/bin/python3

import rclpy,sys
import numpy as np
from time import sleep
import threading
from python_interface.drone_interface import DroneInterface

n_uavs = 0

if __name__ == '__main__':

    rclpy.init()

    usv = DroneInterface("usv")
    usv.offboard()
    usv.arm()
    usv.takeoff(0.24,0.24)
    usv.go_to([-1400,-16.0,1], 20.5)
    rclpy.shutdown()

    exit(0)
