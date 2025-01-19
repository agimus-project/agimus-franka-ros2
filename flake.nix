{
  description = "The franka_ros2 repository provides a ROS 2 integration of libfranka, allowing efficient control of the Franka Robotics arm within the ROS 2 framework. This project is designed to facilitate robotic research and development by providing a robust interface for controlling the research versions of Franka Robotics robots.";

  inputs = {
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/master";
    libfranka = {
      url = "/home/mnaveau/devel/workspace_gepetto_nix/nix/workspace/nix-src/libfranka";
      inputs.nix-ros-overlay.follows = "nix-ros-overlay";
    };
    franka-description = {
      url = "github:agimus-project/franka_description/humble_devel";
      inputs.nix-ros-overlay.follows = "nix-ros-overlay";
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
          default = self.packages.${system}.franka-hardware;

          franka-example-controllers = pkgs.callPackage ./franka_example_controllers/default.nix{
            inherit (self.packages.${system}) franka-msgs;
            inherit (self.packages.${system}) franka-semantic-components;
          };

          franka-fr3-moveit-config = pkgs.callPackage ./franka_fr3_moveit_config/default.nix{
            inherit (self.inputs.franka-description.packages.${system}) franka-description;
            inherit (self.packages.${system}) franka-gripper;
            inherit (self.packages.${system}) franka-hardware;
          };
          
          franka-ign-ros2-control = pkgs.callPackage ./franka_gazebo/franka_ign_ros2_control/default.nix{
            
          };

          franka-gripper = pkgs.callPackage ./franka_gripper/default.nix{
            inherit (self.inputs.libfranka.packages.${system}) libfranka;
            inherit (self.packages.${system}) franka-msgs;
          };

          franka-hardware = pkgs.callPackage ./franka_hardware/default.nix{
            inherit (self.inputs.libfranka.packages.${system}) libfranka;
            inherit (self.packages.${system}) franka-msgs;
          };

          franka-msgs = pkgs.callPackage ./franka_msgs/default.nix {};

          franka-robot-state-broadcaster = pkgs.callPackage ./franka_robot_state_broadcaster/default.nix {
            inherit (self.packages.${system}) franka-msgs;
            inherit (self.packages.${system}) franka-semantic-components;
          };

          franka-semantic-components = pkgs.callPackage ./franka_semantic_components/default.nix {
            inherit (self.inputs.libfranka.packages.${system}) libfranka;
            inherit (self.packages.${system}) franka-msgs;
            inherit (self.packages.${system}) franka-hardware;
          };

          integration-launch-testing = pkgs.callPackage ./integration_launch_testing/default.nix{
            inherit (self.packages.${system}) franka-bringup;
            inherit (self.packages.${system}) franka-gripper;
            inherit (self.packages.${system}) franka-msgs;
          };

          joint-trajectory-controller = pkgs.callPackage ./joint_trajectory_controller/default.nix{
            
          };

          franka-bringup = pkgs.callPackage ./franka_bringup/default.nix {
            inherit (self.inputs.franka-description.packages.${system}) franka-description;
            inherit (self.packages.${system}) franka-hardware;
            inherit (self.packages.${system}) franka-robot-state-broadcaster;
          };
        };
      }
    );
}