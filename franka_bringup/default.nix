{
  lib,
  stdenv,
  cmake,
  rosPackages,
  franka-description,
  franka-hardware,
  franka-robot-state-broadcaster
}:
stdenv.mkDerivation {
  pname = "franka-bringup";
  version = "0.1.15";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./config
      ./launch
      ./CMakeLists.txt
      ./package.xml
    ];
  };

  nativeBuildInputs = [
    cmake
    rosPackages.humble.ament-cmake
    rosPackages.humble.ament-lint-auto
    rosPackages.humble.ament-lint-common
  ];

  propagatedBuildInputs = [
    franka-description
    franka-hardware
    franka-robot-state-broadcaster
    rosPackages.humble.joint-state-publisher
    rosPackages.humble.joint-state-broadcaster
    rosPackages.humble.robot-state-publisher
    rosPackages.humble.controller-manager
    rosPackages.humble.rviz2
    rosPackages.humble.xacro
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