{
  lib,
  stdenv,
  cmake,
  python3Packages,
  rosPackages,
  franka-description,
  franka-gripper,
  franka-hardware
}:
stdenv.mkDerivation {
  pname = "franka-fr3-moveit-config";
  version = "0.1.15";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./config
      ./launch
      ./rviz
      ./srdf
      ./test
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
    franka-description
    franka-gripper
    franka-hardware
    rosPackages.humble.joint-state-publisher
    rosPackages.humble.robot-state-publisher
    rosPackages.humble.joint-state-broadcaster
    rosPackages.humble.controller-manager
    rosPackages.humble.moveit-ros-move-group
    rosPackages.humble.moveit-kinematics
    rosPackages.humble.moveit-planners-ompl
    rosPackages.humble.moveit-ros-visualization
    rosPackages.humble.rviz2
    rosPackages.humble.xacro
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