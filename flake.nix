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
              };

              agimus-franka-example-controllers = final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./agimus_franka_example_controllers ];
                };
                preConfigure = ''
                  export NIX_CFLAGS_COMPILE=$(echo $NIX_CFLAGS_COMPILE | tr ' ' '\n' | grep -v '/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee' | tr '\n' ' ')
                '';
                cmakeFlags = [
                  # TODO: ?
                  "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;test_load_agimus_franka_robot_state_broadcaster"
                ];
              };

              agimus-franka-fr3-moveit-config = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./agimus_franka_fr3_moveit_config ];
                };
              };

              agimus-franka-gazebo-bringup = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./agimus_franka_gazebo/agimus_franka_gazebo_bringup ];
                };
              };

              agimus-franka-ign-ros2-control = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./agimus_franka_gazebo/agimus_franka_ign_ros2_control ];
                };
              };

              agimus-franka-gripper = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./agimus_franka_gripper ];
                };
              };

              agimus-franka-hardware =
                final: ros-final:
                (super: {
                  src = lib.fileset.toSource {
                    root = ./.;
                    fileset = lib.fileset.unions [ ./agimus_franka_hardware ];
                  };
                  preConfigure = ''
                    export NIX_CFLAGS_COMPILE=$(echo $NIX_CFLAGS_COMPILE | tr ' ' '\n' | grep -v '/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee' | tr '\n' ' ')
                  '';
                });

              agimus-franka-msgs = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./agimus_franka_msgs ];
                };
              };

              agimus-franka-robot-state-broadcaster = final: ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./agimus_franka_robot_state_broadcaster ];
                };
                cmakeFlags = [
                  # TODO
                  "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;test_load_agimus_franka_robot_state_broadcaster"
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
              };

              agimus-franka-semantic-components = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./agimus_franka_semantic_components ];
                };
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
              };
            };
          }
        ];
      }
    );
}
