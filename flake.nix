{
  description = "Whole Body Model Predictive Control in the AGIMUS architecture";

  inputs = {
    gazebros2nix.url = "github:gepetto/gazebros2nix/fork";
    flakoboros.follows = "gazebros2nix/flakoboros";
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
            flakoboros = {
              rosShellDistro = "humble";
              rosOverrideAttrs = {
                agimus-franka-bringup = _: _: {
                  src = lib.cleanSource ./agimus_franka_bringup;
                };

                agimus-franka-example-controllers = _: _: {
                  src = lib.cleanSource ./agimus_franka_example_controllers;
                };

                agimus-franka-fr3-moveit-config = _: _: {
                  src = lib.cleanSource ./agimus_franka_fr3_moveit_config;
                };

                agimus-franka-gripper = _: _: {
                  src = lib.cleanSource ./agimus_franka_gripper;
                };

                agimus-franka-hardware = _: _: {
                  src = lib.cleanSource ./agimus_franka_hardware;
                };

                agimus-franka-msgs = _: _: {
                  src = lib.cleanSource ./agimus_franka_msgs;
                };

                agimus-franka-robot-state-broadcaster = _: _: {
                  src = lib.cleanSource ./agimus_franka_robot_state_broadcaster;
                };

                agimus-franka-ros2 = _: _: {
                  src = lib.cleanSource ./agimus_franka_ros2;
                };

                agimus-franka-semantic-components = _: _: {
                  src = lib.cleanSource ./agimus_franka_semantic_components;
                };

                agimus-integration-launch-testing = _: _: {
                  src = lib.cleanSource ./agimus_integration_launch_testing;
                };
              };
            };
          }
        ];
        flake.nlib = inputs.nixpkgs.lib;
      }
    );
}
