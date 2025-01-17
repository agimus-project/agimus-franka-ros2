{
  lib,
  stdenv,
  cmake,
  python3Packages,
  rosPackages,
}:
stdenv.mkDerivation {
  pname = "franka-msgs";
  version = "0.1.15";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./action
      ./msg
      ./srv
      ./CMakeLists.txt
      ./package.xml
    ];
  };

  nativeBuildInputs = [
    cmake
    python3Packages.python
    rosPackages.humble.ament-cmake
    rosPackages.humble.ament-cmake-cppcheck
    rosPackages.humble.ament-cmake-cpplint
    rosPackages.humble.ament-cmake-flake8
    rosPackages.humble.ament-cmake-pep257
    rosPackages.humble.ament-cmake-uncrustify
    rosPackages.humble.ament-lint-auto
    rosPackages.humble.rosidl-default-generators
  ];

  propagatedBuildInputs = [
    rosPackages.humble.builtin-interfaces
    rosPackages.humble.std-msgs
    rosPackages.humble.action-msgs
    rosPackages.humble.geometry-msgs
    rosPackages.humble.sensor-msgs
    rosPackages.humble.rosidl-default-runtime
  ];

  doCheck = true;

  meta = {
    description = "franka_msgs provides messages and actions specific to Franka Robotics research robots.";
    homepage = "https://github.com/agimus-project/franka_ros2";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.linux;
  };
}