{
  lib,
  stdenv,
  cmake,
  python3Packages,
  rosPackages,
  libfranka,
  franka-msgs
}:
stdenv.mkDerivation {
  pname = "franka-gripper";
  version = "0.1.15";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./config
      ./franka_gripper
      ./include
      ./launch
      ./scripts
      ./src
      ./CMakeLists.txt
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
  ];

  propagatedBuildInputs = [
    libfranka
    franka-msgs
    rosPackages.humble.control-msgs
    rosPackages.humble.rclcpp
    rosPackages.humble.rclcpp-action
    rosPackages.humble.rclcpp-components
    rosPackages.humble.rclpy    
    rosPackages.humble.sensor-msgs
    rosPackages.humble.std-srvs
  ];

  doCheck = false;

  meta = {
    description = "This package implements the franka gripper of type Franka Hand for the use in ROS2.";
    homepage = "https://github.com/agimus-project/franka_ros2";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.linux;
  };
}