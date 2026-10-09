Fork of https://github.com/frankarobotics/franka_ros2 for franka robots no longer supported by franka


# Setup

## ROS native (Humble or Jazzy)

```bash
mkdir agimus-franka-ws
cd agimus-franka-ws
wget https://raw.githubusercontent.com/agimus-project/agimus-franka-ros2/main/agimus-franka-ws.repos
vcs import --input agimus-franka-ws.repos
source /opt/ros/jazzy/setup.bash
rosdep install --from-paths src --ignore-src -y
source /opt/ros/jazzy/setup.bash
colcon build
source ./install/setup.bash
```

## Container


```bash
docker build -t agimus-franka .
docker run --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -it agimus-franka
```


# Test the build

```bash
colcon test
```

# Run a sample ROS2 application

To verify that your setup works correctly without a robot, you can run the following command to use dummy hardware:

```bash
ros2 launch agimus_demo_03_mpc_dummy_traj bringup.launch.py use_gazebo:=true use_rviz:=true
```

Then, the same motion on the **real robot**:
```bash
ros2 launch agimus_demo_03_mpc_dummy_traj bringup.launch.py robot_ip:=<robot-ip> use_rviz:=true
```

# Troubleshooting
#### `libfranka: UDP receive: Timeout error`

If you encounter a UDP receive timeout error while communicating with the robot, avoid using Docker Desktop. It may not provide the necessary real-time capabilities required for reliable communication with the robot. Instead, using Docker Engine is sufficient for this purpose.

A real-time kernel is essential to ensure proper communication and to prevent timeout issues. For guidance on setting up a real-time kernel, please refer to the [Franka installation documentation](https://agimus-project.github.io/docs/installation_linux.html#setting-up-the-real-time-kernel).

# Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](https://github.com/agimus-project/agimus_franka_ros2/blob/humble/CONTRIBUTING.md) for more details on how to contribute to this project.

## License

All packages of agimus_franka_ros2 are licensed under the Apache 2.0 license.

## Contact

For questions or support, please open an issue on the [GitHub Issues](https://github.com/agimus-project/agimus_franka_ros2/issues) page.

See the [Franka Control Interface (FCI) documentation](https://agimus-project.github.io/docs) for more information.


[def]: #docker-container-installation
