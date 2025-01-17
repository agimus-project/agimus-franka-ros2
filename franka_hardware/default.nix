{
  lib,
  stdenv,
  cmake,
  python3Packages,
  rosPackages,
  franka-msgs,
}:
stdenv.mkDerivation {
  pname = "franka-hardware";
  version = "0.1.15";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./include
      ./src
      ./test
      ./CMakeLists.txt
      ./franka_hardware.xml
      ./package.xml
    ];
  };

  nativeBuildInputs = [
    cmake
    rosPackages.humble.rclcpp
    rosPackages.humble.pluginlib
    rosPackages.humble.hardware-interface
    rosPackages.humble.ament-cmake
    rosPackages.humble.ament-cmake-clang-format
    rosPackages.humble.ament-cmake-copyright
    rosPackages.humble.ament-cmake-cppcheck
    rosPackages.humble.ament-cmake-flake8
    rosPackages.humble.ament-cmake-lint_cmake
    rosPackages.humble.ament-cmake-pep257
    rosPackages.humble.ament-cmake-xmllint
    rosPackages.humble.ament-cmake-gmock
    rosPackages.humble.ament-cmake-clang_tidy
  ];

  propagatedBuildInputs = [
    franka-msgs
    rosPackages.humble.rclcpp
    rosPackages.humble.hardware-interface
    rosPackages.humble.pluginlib
  ];

  doCheck = true;

  meta = {
    description = "Package with launch files and run-time configurations for using Franka Robotics research robots with ros2_control.";
    homepage = "https://github.com/agimus-project/franka_ros2";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.linux;
  };
}