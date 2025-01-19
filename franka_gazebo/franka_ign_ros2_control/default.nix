{
  lib,
  stdenv,
  cmake,
  rosPackages,
  franka-hardware
}:
stdenv.mkDerivation {
  pname = "franka-ign-ros2-control";
  version = "0.7.9";

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
    franka-hardware
    rosPackages.humble.controller-manager
    rosPackages.humble.hardware-interface
    rosPackages.humble.ignition-gazebo
    rosPackages.humble.ignition-plugin
    rosPackages.humble.pluginlib
    rosPackages.humble.rclcpp
    rosPackages.humble.rclcpp-lifecycle
    rosPackages.humble.yaml-cpp-vendor
  ];

  dontWrapQtApps = true;

  doCheck = false;

  meta = {
    description = "Ignition ros2_control package allows to control simulated robots using ros2_control framework.";
    homepage = "https://github.com/agimus-project/franka_ros2";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.linux;
  };
}