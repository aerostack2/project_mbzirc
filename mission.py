#!/bin/python3

import rclpy,sys
import numpy as np
from time import sleep
import threading
from python_interface.drone_interface import DroneInterface

n_uavs = 0
def create_circle(radius, centre, n_uav):
    circle = []
    for i in range(n_uav):
        circle.append(np.array([radius*np.cos(2*np.pi*i/n_uav) + centre[0], radius*np.sin(2*np.pi*i/n_uav) + centre [1], centre[2]]))
    return circle

def drone_run(drone_interface, n_uav ):
    drone_interface.offboard()
    drone_interface.arm()
    drone_interface.takeoff(3, 2)
    sleep(1)
    circle_1 = create_circle(10 , [0,0,3], n_uavs)
    pose = circle_1[n_uav]
    pose[2] += 2*(n_uav/n_uavs)
    drone_interface.go_to(pose[0], pose[1], pose[2], 2.0)
    sleep(2)
    circle_2 = create_circle(5, [0,0,2], n_uavs)
    if n_uav-1 < 0 :
        drone_interface.go_to(circle_2[n_uavs-1][0], circle_2[n_uavs-1][1], circle_2[n_uavs-1][2], 2.0)
    else:
        drone_interface.go_to(circle_2[n_uav-1][0], circle_2[n_uav-1][1], circle_2[n_uav-1][2], 2.0)
    sleep(2)

    drone_interface.land(0.2)


if __name__ == '__main__':

    rclpy.init()
    # load n_uavs from the first argument
    n_uavs = int(sys.argv[1])
    if n_uavs < 1:
        print("n_uavs must be at least 1")
        sys.exit(1)
    # load the offset from the second argument
    functions = []
    uavs = []
    import os
    drone_id = os.getenv('AEROSTACK2_SIMULATION_DRONE_ID')
    if drone_id is None:
        drone_id = "drone0"

    drone_id = drone_id[:-1]
    for i in range(n_uavs):
        uavs.append(DroneInterface(f"{drone_id}{i}"))
        f = threading.Thread(target=drone_run, args=(uavs[i], i))
        functions.append(f)

    for f in functions:
        f.start()

    for f in functions:
        f.join()

    for uav in uavs:
        uav.shutdown()

    rclpy.shutdown()

    exit(0)
