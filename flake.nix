{
  description = "Whole Body Model Predictive Control in the AGIMUS architecture";

  inputs.gepetto.url = "github:gepetto/nix";

  outputs =
    inputs:
    inputs.gepetto.lib.mkFlakoboros inputs (
      { lib, ... }:
      {
        rosDistros = [
          "humble"
          "jazzy"
        ];
        rosShellDistro = "jazzy";
        rosOverrideAttrs = {
          agimus-franka-bringup = {
            src = lib.fileset.toSource {
              root = ./.;
              fileset = ./agimus_franka_bringup;
            };
          };

          agimus-franka-example-controllers = {
            src = lib.fileset.toSource {
              root = ./.;
              fileset = ./agimus_franka_example_controllers;
            };
          };

          agimus-franka-fr3-moveit-config = {
            src = lib.fileset.toSource {
              root = ./.;
              fileset = ./agimus_franka_fr3_moveit_config;
            };
          };

          agimus-franka-gazebo-bringup = {
            src = lib.fileset.toSource {
              root = ./.;
              fileset = ./agimus_franka_gazebo/agimus_franka_gazebo_bringup;
            };
          };

          agimus-franka-ign-ros2-control = {
            src = lib.fileset.toSource {
              root = ./.;
              fileset = ./agimus_franka_gazebo/agimus_franka_ign_ros2_control;
            };
          };

          agimus-franka-gripper = {
            src = lib.fileset.toSource {
              root = ./.;
              fileset = ./agimus_franka_gripper;
            };
          };

          agimus-franka-hardware = {
            src = lib.fileset.toSource {
              root = ./.;
              fileset = ./agimus_franka_hardware;
            };
          };

          agimus-franka-msgs = {
            src = lib.fileset.toSource {
              root = ./.;
              fileset = ./agimus_franka_msgs;
            };
          };

          agimus-franka-robot-state-broadcaster = {
            src = lib.fileset.toSource {
              root = ./.;
              fileset = ./agimus_franka_robot_state_broadcaster;
            };
          };

          agimus-franka-ros2 = {
            src = lib.fileset.toSource {
              root = ./.;
              fileset = ./agimus_franka_ros2;
            };
          };

          agimus-franka-semantic-components = {
            src = lib.fileset.toSource {
              root = ./.;
              fileset = ./agimus_franka_semantic_components;
            };
          };

          agimus-integration-launch-testing = {
            src = lib.fileset.toSource {
              root = ./.;
              fileset = ./agimus_integration_launch_testing;
            };
          };
        };
      }
    );
}
