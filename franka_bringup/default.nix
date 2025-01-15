{
  lib,
  stdenv,
  cmake,
  fmt,
  python3Packages,
  rosPackages,
  franka_description,
  franka_hardware,
  franka_robot_state_broadcaster
}:
stdenv.mkDerivation {
  pname = "linear-feedback-controller";
  version = "1.0.2";

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
    rosPackages.humble.ament-cmake
    rosPackages.humble.ament-lint-auto
    rosPackages.humble.ament-lint-common
  ];

  propagatedBuildInputs = [
    franka_description
    franka_hardware
    franka_robot_state_broadcaster
    rosPackages.humble.joint-state-publisher
    rosPackages.humble.joint-state-broadcaster
    rosPackages.humble.robot-state-publisher
    rosPackages.humble.controller-manager
    rosPackages.humble.rviz2
    rosPackages.humble.xacro
  ];

  doCheck = true;

  meta = {
    description = "Package with launch files and run-time configurations for using Franka Robotics research robots with ros2_control.";
    homepage = "https://github.com/agimus-project/franka_ros2";
    license = lib.licenses.apache2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.linux;
  };
}