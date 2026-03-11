{
  description = "Whole Body Model Predictive Control in the AGIMUS architecture";

  inputs = {
    gazebros2nix.url = "github:gepetto/gazebros2nix/fork";
    flake-parts.follows = "gazebros2nix/flake-parts";
    nixpkgs.follows = "gazebros2nix/nixpkgs";
    nix-ros-overlay.follows = "gazebros2nix/nix-ros-overlay";
    systems.follows = "gazebros2nix/systems";
    treefmt-nix.follows = "gazebros2nix/treefmt-nix";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {
        systems = import inputs.systems;
        imports = [
          inputs.gazebros2nix.flakeModule
          {
            gazebros2nix.rosOverrides = {
              agimus-franka-bringup = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./agimus_franka_bringup ];
                };
                sourceRoot = "source/agimus_franka_bringup";
              };
              agimus-franka-example-controllers = final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./agimus_franka_example_controllers ];
                };
                sourceRoot = "source/agimus_franka_example_controllers";
                preConfigure = ''
                  export NIX_CFLAGS_COMPILE=$(echo $NIX_CFLAGS_COMPILE | tr ' ' '\n' | grep -v '/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee' | tr '\n' ' ')
                '';
                cmakeFlags = [
                  # This need to download an xml schema at check time
                  # TODO: clang-format
                  # TODO: load ?
                  "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;'xmllint|clang_format|test_load_agimus_franka_robot_state_broadcaster'"
                ];
                nativeCheckInputs = [
                  final.writableTmpDirAsHomeHook
                ];
                # can't load its own controllers otherwise
                checkTarget = " ";
                doInstallCheck = true;
                preInstallCheck = "export AMENT_PREFIX_PATH=$out:$AMENT_PREFIX_PATH";
                intsallCheckTarget = "test";
              };
              agimus-franka-fr3-moveit-config = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./agimus_franka_fr3_moveit_config ];
                };
                sourceRoot = "source/agimus_franka_fr3_moveit_config";
                cmakeFlags = [
                  # This need to download an xml schema at check time
                  "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;xmllint"
                ];
                # This package has a test that test xacro with an installed version of itself
                checkTarget = " ";
                doInstallCheck = true;
                preInstallCheck = "export AMENT_PREFIX_PATH=$out:$AMENT_PREFIX_PATH";
                intsallCheckTarget = "test";
              };
              agimus-franka-gazebo-bringup = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./agimus_franka_gazebo/agimus_franka_gazebo_bringup ];
                };
                sourceRoot = "source/agimus_franka_gazebo/agimus_franka_gazebo_bringup";
              };
              agimus-franka-ign-ros2-control = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./agimus_franka_gazebo/agimus_franka_ign_ros2_control ];
                };
                sourceRoot = "source/agimus_franka_gazebo/agimus_franka_ign_ros2_control";
              };
              agimus-franka-gripper = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./agimus_franka_gripper ];
                };
                sourceRoot = "source/agimus_franka_gripper";
                cmakeFlags = [
                  # This need to download an xml schema at check time
                  # TODO: clang-format
                  "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;'xmllint|clang_format'"
                ];
              };
              agimus-franka-hardware =
                final: ros-final:
                (super: {
                  src = lib.fileset.toSource {
                    root = ./.;
                    fileset = lib.fileset.unions [ ./agimus_franka_hardware ];
                  };
                  sourceRoot = "source/agimus_franka_hardware";
                  cmakeFlags = [
                    # This need to download an xml schema at check time
                    # TODO: clang-format
                    "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;'xmllint|clang_format'"
                  ];
                  nativeBuildInputs = super.nativeBuildInputs ++ [
                    final.writableTmpDirAsHomeHook
                    ros-final.rmw-implementation-cmake
                  ];
                  preConfigure = ''
                    export NIX_CFLAGS_COMPILE=$(echo $NIX_CFLAGS_COMPILE | tr ' ' '\n' | grep -v '/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee' | tr '\n' ' ')
                  '';
                });
              agimus-franka-msgs = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./agimus_franka_msgs ];
                };
                sourceRoot = "source/agimus_franka_msgs";
              };
              agimus-franka-robot-state-broadcaster = final: ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./agimus_franka_robot_state_broadcaster ];
                };
                sourceRoot = "source/agimus_franka_robot_state_broadcaster";
                nativeCheckInputs = [
                  final.writableTmpDirAsHomeHook
                  ros-final.ament-cmake-clang-format
                  ros-final.ament-cmake-copyright
                  ros-final.ament-cmake-cppcheck
                  ros-final.ament-cmake-flake8
                  ros-final.ament-cmake-lint-cmake
                  ros-final.ament-cmake-pep257
                  ros-final.ament-cmake-xmllint
                ];
                cmakeFlags = [
                  # TODO
                  "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;'clang_format|test_load_agimus_franka_robot_state_broadcaster'"
                ];
                preConfigure = ''
                  export NIX_CFLAGS_COMPILE=$(echo $NIX_CFLAGS_COMPILE | tr ' ' '\n' | grep -v '/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee' | tr '\n' ' ')
                '';
              };
              agimus-franka-ros2 = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./agimus_franka_ros2 ];
                };
                sourceRoot = "source/agimus_franka_ros2";
              };
              agimus-franka-semantic-components = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./agimus_franka_semantic_components ];
                };
                sourceRoot = "source/agimus_franka_semantic_components";
                cmakeFlags = [
                  # This need to download an xml schema at check time
                  # TODO: clang-format
                  "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;'xmllint|clang_format'"
                ];
                checkTarget = " ";
                doInstallCheck = true;
                preInstallCheck = "export AMENT_PREFIX_PATH=$out:$AMENT_PREFIX_PATH";
                intsallCheckTarget = "test";
              };
              agimus-integration-launch-testing = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./agimus_integration_launch_testing ];
                };
                sourceRoot = "source/agimus_integration_launch_testing";
                cmakeFlags = [
                  # This need to download an xml schema at check time
                  "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;xmllint"
                ];
              };
            };
          }
        ];
      }
    );
}
