{
  lib,
  stdenv,
  cmake,
  eigen,
  python3Packages,
  rosPackages,
  franka-msgs,
  franka-semantic-components
}:
stdenv.mkDerivation {
  pname = "franka-example-controllers";
  version = "0.1.15";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./include
      ./src
      ./test
      ./CMakeLists.txt
      ./franka_example_controllers.xml
      ./package.xml
    ];
  };

  nativeBuildInputs = [
    cmake
    eigen
    rosPackages.humble.ament-cmake
    rosPackages.humble.ament-cmake-clang-format
    rosPackages.humble.ament-cmake-copyright
    rosPackages.humble.ament-cmake-cppcheck
    rosPackages.humble.ament-cmake-flake8
    rosPackages.humble.ament-cmake-gmock
    rosPackages.humble.ament-cmake-lint-cmake
    rosPackages.humble.ament-cmake-pep257
    rosPackages.humble.ament-cmake-xmllint
    rosPackages.humble.controller-manager
    rosPackages.humble.ros2-control-test-assets
  ];

  propagatedBuildInputs = [
    franka-msgs
    franka-semantic-components
    rosPackages.humble.controller-interface
    rosPackages.humble.hardware-interface
    rosPackages.humble.moveit-core
    rosPackages.humble.moveit-msgs
    rosPackages.humble.pluginlib
    rosPackages.humble.rclcpp
    rosPackages.humble.rclcpp-lifecycle
  ];

  doCheck = false;

  meta = {
    description = "franka_example_controllers provides example code for controllingFranka Robotics research robots with ros2_control.";
    homepage = "https://github.com/agimus-project/franka_ros2";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.linux;
  };
}