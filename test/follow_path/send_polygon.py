import rclpy
from rclpy.node import Node

from geometry_msgs.msg import PolygonStamped, Point32


class MinimalPublisher(Node):

    def __init__(self):
        super().__init__('minimal_publisher')
        self.publisher_ = self.create_publisher(PolygonStamped, 'drone_1/polygon', 5)
        timer_period = 5  # seconds
        self.timer = self.create_timer(timer_period, self.timer_callback)
        self.i = 0

    def timer_callback(self):
        msg = PolygonStamped()

        point =  Point32()
        point.x = 1.0
        point.y = 2.0
        point.z = 3.0
        msg.polygon.points.append(point)

        point =  Point32()
        point.x = 4.0
        point.y = 5.0
        point.z = 6.0
        msg.polygon.points.append(point)

        point =  Point32()
        point.x = 7.0
        point.y = 8.0
        point.z = 9.0
        msg.polygon.points.append(point)

        self.publisher_.publish(msg)
        self.get_logger().info('Publishing: "%s"' % msg.polygon.points)
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