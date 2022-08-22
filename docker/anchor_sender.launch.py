
import os

from ament_index_python.packages import get_package_share_directory

from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument
from launch.actions import IncludeLaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.substitutions import EnvironmentVariable, LaunchConfiguration


def generate_launch_description():
    drone_id = DeclareLaunchArgument('drone_id', default_value=[EnvironmentVariable('AEROSTACK2_SIMULATION_DRONE_ID'), 'drone_sim'])
    controller_config = DeclareLaunchArgument('controller_config', default_value='robot_config/controller_manager.yaml')
    takeoff_config = DeclareLaunchArgument('takeoff_config', default_value='robot_config/takeoff.yaml')

    init_x = DeclareLaunchArgument('init_x', default_value='0.0')
    init_y = DeclareLaunchArgument('init_y', default_value='0.0')
    init_z = DeclareLaunchArgument('init_z', default_value='0.0')
    
    bt_tree = DeclareLaunchArgument('tree', default_value='')

    camera_topic = DeclareLaunchArgument('camera_topic', default_value='stream/compressed_image')
    report_topic = DeclareLaunchArgument('report_topic', default_value='report')

    platform = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([os.path.join(
            get_package_share_directory('ignition_platform'), 'launch'),
            '/ignition_platform_launch.py']),
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

    vinodom = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([os.path.join(
            get_package_share_directory('vinodom'), 'launch'),
            '/vinodom_launch.py']),
        launch_arguments={
            'namespace': LaunchConfiguration('drone_id'),
            'use_sim_time': 'true',
            'base_frame': LaunchConfiguration('drone_id'),
            'show_matching': 'false',
            'init_x': LaunchConfiguration('init_x'),
            'init_y': LaunchConfiguration('init_y'),
            'init_z': LaunchConfiguration('init_z')
        }.items()
    )

    controller_manager = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([os.path.join(
            get_package_share_directory('controller_manager'), 'launch'),
            '/controller_manager_launch.py']),
        launch_arguments={
            'drone_id': LaunchConfiguration('drone_id'),
            'use_sim_time': 'true',
            'config': LaunchConfiguration('controller_config')
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
            'config_takeoff': LaunchConfiguration('takeoff_config')
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

    stream_sender = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([os.path.join(
            get_package_share_directory('mbzirc_sim_interface'), 'launch'),
            '/stream_sender_launch.py']),
        launch_arguments={
            'namespace': LaunchConfiguration('drone_id'),
            'use_sim_time': 'true',
            'compressed_image_topic': LaunchConfiguration('camera_topic'),
            'report_topic': LaunchConfiguration('report_topic')
        }.items()
    )

    # yolo_detector = IncludeLaunchDescription(
    #     PythonLaunchDescriptionSource([os.path.join(
    #         get_package_share_directory('yolo_object_detector'), 'launch'),
    #         '/yolo_object_detector_launch.py']),
    #     launch_arguments={
    #         'drone_id': LaunchConfiguration('drone_id'),
    #         'use_sim_time': 'true',
    #         'camera_topic': 'slot0/image_raw'
    #     }.items()
    # )

    # yolo_detector = IncludeLaunchDescription(
    #     PythonLaunchDescriptionSource([os.path.join(
    #         get_package_share_directory('mbzirc_sim_interface'), 'launch'),
    #         '/stream_compressor_launch.py']),
    #     launch_arguments={
    #         'namespace': LaunchConfiguration('drone_id'),
    #         'use_sim_time': 'true',
    #         'rgb_image_topic': 'slot0/image_raw',
    #         'detection_topic': 'detector_node/detections',
    #         'compressed_image_topic': '/drone_1/'+LaunchConfiguration('camera_topic'), # TODO: ojo, revisar si esto funciona
    #         'report_topic': '/drone_1/'+LaunchConfiguration('report_topic')
    #     }.items()
    # )

    return LaunchDescription([
        drone_id,
        controller_config,
        takeoff_config,
        init_x,
        init_y,
        init_z,
        bt_tree,
        camera_topic,
        report_topic,

        platform,
        state_estimator,
        vinodom,
        controller_manager,
        traj_generator,
        basic_behaviours,
        comms,
        planner,
        stream_sender
    ])
