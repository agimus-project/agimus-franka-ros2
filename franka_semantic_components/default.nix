{
  lib,
  stdenv,
  cmake,
  eigen,
  python3Packages,
  rosPackages,
  franka-msgs,
  franka-hardware,
  libfranka
}:
stdenv.mkDerivation {
  pname = "franka-semantic-components";
  version = "0.1.0";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./include
      ./src
      ./test
      ./CMakeLists.txt
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
    rosPackages.humble.ament-cmake-lint-cmake
    rosPackages.humble.ament-cmake-pep257
    rosPackages.humble.ament-cmake-xmllint
    rosPackages.humble.ament-cmake-gmock
    rosPackages.humble.ament-cmake-clang-tidy
  ];

  propagatedBuildInputs = [
    franka-hardware
    franka-msgs
    libfranka
    rosPackages.humble.controller-interface
    rosPackages.humble.geometry-msgs
    rosPackages.humble.hardware-interface
    rosPackages.humble.rclcpp
    rosPackages.humble.sensor-msgs
    rosPackages.humble.urdf
  ];

  # Issues with the location of the configuration files. Notably .clang-format that the unit-test look at ../.clang-format
  doCheck = false;

  meta = {
    description = "franka_semantic_components provides semantic components for using Franka Robotics research robots with ros2_control.";
    homepage = "https://github.com/agimus-project/franka_ros2";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.linux;
  };
}