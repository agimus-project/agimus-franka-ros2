{
  lib,
  stdenv,
  cmake,
  rosPackages
}:
stdenv.mkDerivation {
  pname = "joint-trajectory-controller";
  version = "3.3.0";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./doc
      ./include
      ./src
      ./test
      ./CMakeLists.txt
      ./joint_trajectory_plugin.xml
      ./package.xml
    ];
  };

  nativeBuildInputs = [
    cmake
    rosPackages.humble.ament-cmake
    rosPackages.humble.ament-cmake-gmock
    rosPackages.humble.ament-lint-auto
    rosPackages.humble.ament-lint-common
    rosPackages.humble.controller-manager
    rosPackages.humble.ros2-control-test-assets
  ];

  propagatedBuildInputs = [
    rosPackages.humble.angles
    rosPackages.humble.backward-ros
    rosPackages.humble.controller-interface
    rosPackages.humble.control-msgs
    rosPackages.humble.control-toolbox
    rosPackages.humble.generate-parameter-library
    rosPackages.humble.hardware-interface
    rosPackages.humble.joint-state-publisher
    rosPackages.humble.joint-state-broadcaster
    rosPackages.humble.pluginlib
    rosPackages.humble.robot-state-publisher
    rosPackages.humble.controller-manager
    rosPackages.humble.realtime-tools
    rosPackages.humble.rclcpp
    rosPackages.humble.rclcpp-lifecycle
    rosPackages.humble.rsl
    rosPackages.humble.rviz2
    rosPackages.humble.tl-expected
    rosPackages.humble.trajectory-msgs
  ];

  dontWrapQtApps = true;

  doCheck = false;

  meta = {
    description = "Package with launch files and run-time configurations for using Franka Robotics research robots with ros2_control.";
    homepage = "https://github.com/agimus-project/franka_ros2";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.linux;
  };
}