
import os

from ament_index_python.packages import get_package_share_directory

from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument
from launch.actions import IncludeLaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.substitutions import EnvironmentVariable, LaunchConfiguration


def generate_launch_description():
    drone_id = DeclareLaunchArgument('drone_id', default_value=[EnvironmentVariable('AEROSTACK2_SIMULATION_DRONE_ID'), 'drone_sim'])
    takeoff_config = DeclareLaunchArgument('takeoff_config', default_value='usv/takeoff.yaml')
    config_goto = DeclareLaunchArgument('config_goto', default_value='usv/goto.yaml')

    init_x = DeclareLaunchArgument('init_x', default_value='0.0')
    init_y = DeclareLaunchArgument('init_y', default_value='0.0')
    init_z = DeclareLaunchArgument('init_z', default_value='0.0')
    
    bt_tree = DeclareLaunchArgument('tree', default_value='')

    camera_topic = DeclareLaunchArgument('camera_topic', default_value='stream/compressed_image')
    report_topic = DeclareLaunchArgument('report_topic', default_value='report')

    platform = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([os.path.join(
            get_package_share_directory('usv_ign_platform'), 'launch'),
            '/usv_ign_platform.py']),
        launch_arguments={
            'drone_id': LaunchConfiguration('drone_id'),
            'use_sim_time': 'true'
        }.items()
    )

    state_estimator = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([os.path.join(
            get_package_share_directory('basic_state_estimator'), 'launch'),
            '/basic_state_estimator_launch.py']),
        launch_arguments={
            'drone_id': LaunchConfiguration('drone_id'),
            'use_sim_time': 'true',
            'ground_truth': 'false',
            'odom_only': 'true',
            'base_frame': '\"\"'
        }.items()
    )

    controller_manager = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([os.path.join(
            get_package_share_directory('controller_manager'), 'launch'),
            '/controller_manager_launch.py']),
        launch_arguments={
            'drone_id': LaunchConfiguration('drone_id'),
            'use_sim_time': 'true'
        }.items()
    )

    traj_generator = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([os.path.join(
            get_package_share_directory('trajectory_generator'), 'launch'),
            '/trajectory_generator_launch.py']),
        launch_arguments={
            'drone_id': LaunchConfiguration('drone_id'),
            'use_sim_time': 'true'
        }.items()
    )

    basic_behaviours = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([os.path.join(
            get_package_share_directory('as2_basic_behaviours'), 'launch'),
            '/all_basic_behaviours_launch.py']),
        launch_arguments={
            'drone_id': LaunchConfiguration('drone_id'),
            'use_sim_time': 'true',
            'config_takeoff': LaunchConfiguration('takeoff_config'),
            'config_goto': LaunchConfiguration('config_goto')
        }.items()
    )

    comms = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([os.path.join(
            get_package_share_directory('mbzirc_comms'), 'launch'),
            '/mbzirc_comms_launch.py']),
        launch_arguments={
            'robot_id': LaunchConfiguration('drone_id'),
            'use_sim_time': 'true',
            'n_drones': '10',
            'pose_topic': '/self_localization/pose',
            'tree_topic': '/tree',
            'camera_topic': LaunchConfiguration('camera_topic'),
            'loc_hist_topic': '/loc_hist',
            'report_topic': LaunchConfiguration('report_topic')
        }.items()
    )

    planner = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([os.path.join(
            get_package_share_directory('mbzirc_bt'), 'launch'),
            '/mbzirc_bt.launch.py']),
        launch_arguments={
            'drone_id': LaunchConfiguration('drone_id'),
            'use_sim_time': 'true',
            'tree':  LaunchConfiguration('tree'),
            'groot_logger': 'false',
            'server_timeout': '30000'
        }.items()
    )

    return LaunchDescription([
        drone_id,
        config_goto,
        takeoff_config,
        init_x,
        init_y,
        init_z,
        bt_tree,
        camera_topic,
        report_topic,

        platform,
        state_estimator,
        controller_manager,
        traj_generator,
        basic_behaviours,
        # comms,
        planner
    ])
