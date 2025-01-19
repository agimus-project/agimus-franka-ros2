{
  lib,
  stdenv,
  cmake,
  python3Packages,
  rosPackages,
  franka-msgs,
  franka-semantic-components
}:
stdenv.mkDerivation {
  pname = "franka-robot-state-broadcaster";
  version = "0.1.15";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./include
      ./src
      ./test
      ./CMakeLists.txt
      ./franka_robot_state_broadcaster.xml
      ./package.xml
    ];
  };

  nativeBuildInputs = [
    cmake
    rosPackages.humble.ament-cmake
    rosPackages.humble.ament-cmake-clang-format
    rosPackages.humble.ament-cmake-copyright
    rosPackages.humble.ament-cmake-cppcheck
    rosPackages.humble.ament-cmake-flake8
    rosPackages.humble.ament-cmake-gmock
    rosPackages.humble.ament-cmake-lint-cmake
    rosPackages.humble.ament-cmake-pep257
    rosPackages.humble.ament-cmake-xmllint
    rosPackages.humble.hardware-interface
    rosPackages.humble.controller-manager
    rosPackages.humble.ros2-control-test-assets
  ];

  propagatedBuildInputs = [
    franka-msgs
    franka-semantic-components
    rosPackages.humble.backward-ros
    rosPackages.humble.builtin-interfaces
    rosPackages.humble.control-msgs
    rosPackages.humble.controller-interface
    rosPackages.humble.generate-parameter-library
    rosPackages.humble.hardware-interface
    rosPackages.humble.pluginlib
    rosPackages.humble.realtime-tools
    rosPackages.humble.rclcpp
    rosPackages.humble.rclcpp-lifecycle
    rosPackages.humble.rcutils
    rosPackages.humble.sensor-msgs
    rosPackages.humble.visualization-msgs
  ];

  doCheck = false;

  meta = {
    description = "Package with launch files and run-time configurations for using Franka Robotics research robots with ros2_control.";
    homepage = "https://github.com/agimus-project/franka_ros2";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.linux;
  };
}