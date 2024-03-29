import rclpy
from rclpy.node import Node
from rclpy.clock import Clock
from rclpy.time import Time

from as2_msgs.msg import TrajectoryWaypointsWithID, PoseStampedWithID


class MinimalPublisher(Node):

    def __init__(self):
        super().__init__('minimal_publisher')
        self.publisher_ = self.create_publisher(TrajectoryWaypointsWithID, 'drone_1/path', 5)
        timer_period = 5  # seconds
        self.timer = self.create_timer(timer_period, self.timer_callback)
        self.i = 0

    def timer_callback(self):
        msg = TrajectoryWaypointsWithID()
        msg.header.frame_id = "earth"
        msg.header.stamp = self.get_clock().now().to_msg()
        msg.yaw_mode = TrajectoryWaypointsWithID.PATH_FACING

        pose = PoseStampedWithID()
        pose.header.frame_id = "earth"
        pose.header.stamp = self.get_clock().now().to_msg()
        pose.id = '0'
        pose.pose.position.x = 0.0
        pose.pose.position.y = 0.0
        pose.pose.position.z = 3.0
        msg.poses.append(pose)

        self.publisher_.publish(msg)
        self.get_logger().info('Publishing: "%s"' % msg)
        self.i += 1


def main(args=None):
    rclpy.init(args=args)

    minimal_publisher = MinimalPublisher()

    rclpy.spin(minimal_publisher)

    # Destroy the node explicitly
    # (optional - otherwise it will be done automatically
    # when the garbage collector destroys the node object)
    minimal_publisher.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()