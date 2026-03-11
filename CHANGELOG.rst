^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package agimus_franka_ros2
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
v1.0.0 (2025-01-22)
-------------------

Requires libfranka >= 0.15.0 and agimus_franka_description >= 0.3.0 requires ROS 2 Humble

* feat: agimus_franka_example_controllers - Add a Franka Hand controller example (gripper_example_controller)
* fix: reduced acceleration discontinuities by adding new robot_time state to agimus_franka_hardware
*      that allows to update controllers with same time that robot uses
* refactor: Improved Docker image for development with VSCode
* BREAKING_CHANGE: initial_joint_position state removed from agimus_franka_hardware. 
*                  rename/replace functions in agimus_franka_semantic_components as follows:
* -  initial_cartesian_pose, initial_elbow_state
* +  cartesian_pose_state,   elbow_state.
*
* - getInitialElbowConfiguration, getInitialOrientationAndTranslation, getInitialPoseMatrix
* + getCurrentElbowConfiguration, getCurrentOrientationAndTranslation, getCurrentPoseMatrix 
*


0.1.15 (2024-06-21)
------------------

Requires libfranka >= 0.13.2 and agimus_franka_description >= 0.3.0 requires ROS 2 Humble

* feat:  agimus_franka_gazebo_bringup: Released and supports joint position, velocity and effort commands
* feat:  agimus_franka_ign_ros2_control: ROS 2 hardware interface for gazebo controller. Modified to add gravity torques for Franka robots.
* fix: the joint-impedance-with-IK example to work without a gripper

0.1.14 (2024-05-13)
------------------

Requires libfranka >= 0.13.2, and agimus_franka_description >= 0.2.0 requires ROS 2 Humble

* BREAKING CHANGE: agimus_franka_description package
* BREAKING CHANGE: using the agimus_franka_description standalone package https://github.com/agimus_frankaemika/agimus_franka_description
* build:  install pinocchio dependency from ros-humble-pinocchio apt package
* feat: Added error recovery action to ROS 2 node
* fix: hard-coded panda robot references
* fix: agimus_franka_hardware prefixes the robot_state and robot model state interfaces with the read robot name from the urdf.

0.1.13 (2024-01-18)
------------------

Requires libfranka >= 0.13.2, requires ROS 2 Humble

* BREAKING CHANGE: update libfranka dependency in devcontainer to 0.13.3(requires system image 5.5.0)
* fix: devcontainer typo

0.1.12 (2024-01-12)
------------------

Requires libfranka >= 0.13.2, requires ROS 2 Humble

* feat: agimus_franka_semantic_component: Read robot state from urdf robot description.
* feat: agimus_franka_state_broadcaster: Publish visualizable topics seperately.

0.1.11 (2023-12-20)
------------------

Requires libfranka >= 0.13.2, requires ROS 2 Humble

* feat: agimus_franka_example_controllers: Add a joint impedance example using OrocosKDL(LMA-ik) through MoveIt service.
* feat: agimus_franka_hardware: Register initial joint positions and cartesian pose state interface without having running command interfaces.

0.1.10 (2023-12-04)
------------------

Requires libfranka >= 0.13.0, required ROS 2 Humble

* feat: Adapted the agimus_franka robot state broadcaster to use ROS 2 message types
* feat: Adapted the Cartesian velocity command interface to use Eigen types

0.1.9 (2023-12-04)
------------------

Requires libfranka >= 0.13.0, required ROS 2 Humble

* feat: agimus_franka_hardware: add state interfaces for initial position, cartesian pose and elbow.
* feat: agimus_franka_hardware: support cartesian pose interface.
* feat: agimus_franka_semantic_component: support cartesian pose interface.
* feat: agimus_franka_example_controllers: add cartesian pose example controller
* feat: agimus_franka_example_controllers: add cartesian elbow controller
* feat: agimus_franka_example_controllers: add cartesian orientation controller

0.1.8 (2023-11-16)
------------------

Requires libfranka >= 0.13.0, required ROS 2 Humble

* test: agimus_franka_hardware: add unit tests for robot class.
* fix:  joint_trajectory_controller: hotfix add joint patched old JTC back.

0.1.7 (2023-11-10)
------------------

Requires libfranka >= 0.12.1, required ROS 2 Humble

* feat: agimus_franka_hardware: joint position command interface supported
* feat: agimus_franka_hardware: controller initializer automatically acknowledges error, if arm is in reflex mode
* feat: agimus_franka_example_controllers: joint position example controller provided
* fix:  agimus_franka_example_controllers: fix second start bug with the example controllers

0.1.6 (2023-11-03)
------------------

Requires libfranka >= 0.12.1, required ROS 2 Humble

* feat: agimus_franka_hardware: support for cartesian velocity command interface
* feat: agimus_franka_semantic_component: implemented cartesian velocity interface
* feat: agimus_franka_example_controllers: implement cartesian velocity example controller
* feat: agimus_franka_example_controllers: implement elbow example controller

0.1.5 (2023-10-13)
------------------

Requires libfranka >= 0.12.1, required ROS 2 Humble

* feat: agimus_franka_hardware: support joint velocity command interface
* feat: agimus_franka_example_controllers: implement joint velocity example controller
* feat: agimus_franka_description: add velocity command interface to the control tag

0.1.4 (2023-09-26)
------------------

Requires libfranka >= 0.12.1, required ROS 2 Humble

* feat: agimus_franka_hardware: adapt to libfranka active control 0.12.1

0.1.3 (2023-08-24)
------------------

Requires libfranka >= 0.11.0, required ROS 2 Humble

* fix: agimus_franka_hardware: hotfix start controller when user claims the command interface

0.1.2 (2023-08-21)
------------------

Requires libfranka >= 0.11.0, required ROS 2 Humble

* feat: agimus_franka_hardware: implement non-realtime parameter services

0.1.1 (2023-08-21)
------------------

Requires libfranka >= 0.11.0, required ROS 2 Humble

* feat: agimus_franka_hardware: uses updated libfranka version providing the possibility to have the control loop on the ROS side

0.1.0 (2023-07-28)
------------------

Requires libfranka >= 0.10.0, required ROS 2 Humble

* feat: agimus_franka_bringup: agimus_franka_robot_state broadcaster added to agimus_franka.launch.py.
* feat: agimus_franka_example_controllers: model printing read only controller implemented
* feat: agimus_franka_robot_model: semantic component to access robot model parameters.
* feat: agimus_franka_msgs: agimus_franka robot state msg added
* feat: agimus_franka_robot_state: broadcaster publishes robot state.
* feat: joint_effort_trajectory_controller package that contains a version of the\
        joint_trajectory_controller that can use the torque interface. \
        [See this PR](https://github.com/ros-controls/ros2_controllers/pull/225)
* feat: agimus_franka_bringup package that contains various launch files to start controller examples or Moveit2.
* feat: agimus_franka_moveit_config package that contains a minimal moveit config to control the robot.
* feat: agimus_franka_example_controllers package that contains some example controllers to use.
* feat: agimus_franka_hardware package that contains a plugin to access the robot.
* feat: agimus_franka_msgs package that contains common message, service and action type definitions.
* feat: agimus_franka_description package that contains all meshes and xacro files.
* feat: agimus_franka_gripper package that offers action and service interfaces to use the Franka Hand gripper.
* fix:  agimus_franka_hardware Fix the mismatched joint state interface type logger error message.
* test: CI tests in Jenkins.
