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
                  fileset = lib.fileset.unions [ ./franka_bringup ];
                };
              };
              agimus-franka-example-controllers = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./franka_example_controllers ];
                };
              };
              agimus-franka-fr3-moveit-config = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./franka_fr3_moveit_config ];
                };
              };
              agimus-franka-gazebo-bringup = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./franka_gazebo/franka_gazebo_bringup ];
                };
              };
              agimus-franka-ign-ros2-control = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./franka_gazebo/franka_ign_ros2_control ];
                };
              };
              agimus-franka-gripper = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./franka_gripper ];
                };
              };
              agimus-franka-hardware = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./franka_hardware ];
                };
              };
              agimus-franka-msgs = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./franka_msgs ];
                };
              };
              agimus-franka-robot-state-broadcaster = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./franka_robot_state_broadcaster ];
                };
              };
              agimus-franka-ros2 = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./franka_ros2 ];
                };
              };
              agimus-franka-semantic-components = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./franka_semantic_components ];
                };
              };
              integration-launch-testing = _final: _ros-final: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [ ./integration_launch_testing ];
                };
              };
            };
          }
        ];
      }
    );
}
