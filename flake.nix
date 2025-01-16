{
  description = "The franka_ros2 repository provides a ROS 2 integration of libfranka, allowing efficient control of the Franka Robotics arm within the ROS 2 framework. This project is designed to facilitate robotic research and development by providing a robust interface for controlling the research versions of Franka Robotics robots.";

  inputs = {
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/master";
    franka-description = {
      url = "github:agimus-project/franka_description/humble_devel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nix-ros-overlay, self, ... }:
    nix-ros-overlay.inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nix-ros-overlay.inputs.nixpkgs {
          inherit system;
          overlays = [ nix-ros-overlay.overlays.default ];
        };
      in
      {
        packages = {
          default = [
            self.packages.${system}.franka-description

          ];
          
          packages = {
            default = self.packages.${system}.franka-bringup;
            franka-example-controllers = pkgs.callPackage ./franka_example_controllers/default.nix;
            franka-fr3-moveit-config = pkgs.callPackage ./franka_fr3_moveit_config/default.nix;
            franka-gazebo = pkgs.callPackage ./franka_gazebo/default.nix;
            franka-gripper = pkgs.callPackage ./franka_gripper/default.nix;
            franka-hardware = pkgs.callPackage ./franka_hardware/default.nix;
            franka-msgs = pkgs.callPackage ./franka_msgs/default.nix;
            franka-robot-state-broadcaster = pkgs.callPackage ./franka_robot_state_broadcaster/default.nix;
            franka-semantic-components = pkgs.callPackage ./franka_semantic_components/default.nix;
            integration-launch-testing = pkgs.callPackage ./integration_launch_testing/default.nix;
            joint-trajectory-controller = pkgs.callPackage ./joint_trajectory_controller/default.nix;
            franka-bringup = pkgs.callPackage ./franka_bringup/default.nix {
              inherit franka-description = inputs.franka-description.packages.${system}.franka_description;
              inherit franka-hardware;
              inherit franka-robot-state-broadcaster;
            };
          };
        };
      }
    );
}