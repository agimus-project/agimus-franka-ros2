{
  lib,
  stdenv,
  cmake,
  python3Packages,
  rosPackages,
  franka-bringup,
  franka-gripper,
  franka-msgs
}:
stdenv.mkDerivation {
  pname = "integration-launch-testing";
  version = "0.1.15";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
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
    rosPackages.humble.ament-cmake-lint-cmake
    rosPackages.humble.ament-cmake-pep257
    rosPackages.humble.ament-cmake-xmllint
    rosPackages.humble.ament-cmake-gmock
    rosPackages.humble.ament-cmake-clang-tidy
  ];

  propagatedBuildInputs = [
    franka-bringup
    franka-gripper
    franka-msgs
    rosPackages.humble.launch-testing
  ];

  # Issues with the location of the configuration files. Notably .clang-format that the unit-test look at ../.clang-format
  doCheck = false;

    dontWrapQtApps = true;

  meta = {
    description = "Functional integration tests for franka controllers.";
    homepage = "https://github.com/agimus-project/franka_ros2";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.linux;
  };
}