// Copyright (c) 2023 Franka Robotics GmbH
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "agimus_franka_robot_state_test.hpp"

#include <memory>
#include <string>
#include <vector>

void AgimusFrankaRobotStateTest::TearDown() {
  agimus_franka_state_friend.reset(nullptr);
}

void AgimusFrankaRobotStateTest::SetUp() {
  full_interface_names.reserve(size);
  full_interface_names.emplace_back(robot_name + "/" + agimus_franka_state_interface_name);
  agimus_franka_state_friend =
      std::make_unique<AgimusFrankaRobotStateTestFriend>(robot_name + "/" + agimus_franka_state_interface_name);

  std::vector<std::string> interface_names = agimus_franka_state_friend->get_state_interface_names();

  robot_state.q = joint_angles;
  robot_state.q_d = joint_velocities;
  robot_state.O_T_EE = end_effector_pose;
  robot_state.robot_mode = robot_mode;

  hardware_interface::StateInterface agimus_franka_hw_state{
      robot_name, agimus_franka_state_interface_name, reinterpret_cast<double*>(&robot_state_address)};
  std::vector<hardware_interface::LoanedStateInterface> temp_state_interfaces;

  temp_state_interfaces.reserve(size);

  temp_state_interfaces.emplace_back(agimus_franka_hw_state);
  agimus_franka_state_friend->assign_loaned_state_interfaces(temp_state_interfaces);
  ASSERT_TRUE(agimus_franka_state_friend->get_values_as_message(agimus_franka_robot_state_msg));
}

TEST_F(AgimusFrankaRobotStateTest, validate_state_names_and_size) {
  ASSERT_EQ(agimus_franka_state_friend->name_, robot_name + "/" + agimus_franka_state_interface_name);

  ASSERT_EQ(agimus_franka_state_friend->interface_names_.size(), size);
  ASSERT_EQ(agimus_franka_state_friend->state_interfaces_.capacity(), size);

  ASSERT_TRUE(std::equal(agimus_franka_state_friend->interface_names_.begin(),
                         agimus_franka_state_friend->interface_names_.end(), full_interface_names.begin(),
                         full_interface_names.end()));
  ASSERT_EQ(agimus_franka_state_friend->state_interfaces_.size(), size);
  agimus_franka_state_friend->release_interfaces();
  // validate the count of state_interfaces_
  ASSERT_EQ(agimus_franka_state_friend->state_interfaces_.size(), 0u);
}

TEST_F(AgimusFrankaRobotStateTest, robot_state_ptr_uncasted_correctly) {
  auto robot_state_ptr = agimus_franka_state_friend->get_robot_state();
  ASSERT_EQ(robot_state_ptr, robot_state_address);
  agimus_franka_state_friend->release_interfaces();
  // validate the count of state_interfaces_
  ASSERT_EQ(agimus_franka_state_friend->state_interfaces_.size(), 0u);
}

TEST_F(AgimusFrankaRobotStateTest,
       givenFrankaSemanticStateInitialized_whenMessageReturnedExpectsCorrectValues) {
  ASSERT_THAT(joint_angles,
              ::testing::ElementsAreArray(agimus_franka_robot_state_msg.measured_joint_state.position));
  ASSERT_THAT(joint_velocities,
              ::testing::ElementsAreArray(agimus_franka_robot_state_msg.desired_joint_state.position));

  ASSERT_EQ(end_effector_pose[12], agimus_franka_robot_state_msg.o_t_ee.pose.position.x);
  ASSERT_EQ(end_effector_pose[13], agimus_franka_robot_state_msg.o_t_ee.pose.position.y);
  ASSERT_EQ(end_effector_pose[14], agimus_franka_robot_state_msg.o_t_ee.pose.position.z);

  ASSERT_EQ(agimus_franka_msgs::msg::AgimusFrankaRobotState::ROBOT_MODE_USER_STOPPED,
            agimus_franka_robot_state_msg.robot_mode);
  agimus_franka_state_friend->release_interfaces();
  // validate the count of state_interfaces_
  ASSERT_EQ(agimus_franka_state_friend->state_interfaces_.size(), 0u);
}

TEST_F(AgimusFrankaRobotStateTest, givenInitializedRobotStateMsg_thenCorrectFrameIDs) {
  agimus_franka_state_friend->initialize_robot_state_msg(agimus_franka_robot_state_msg);

  ASSERT_EQ(agimus_franka_robot_state_msg.o_t_ee.header.frame_id, "fr3_link0");
  ASSERT_EQ(agimus_franka_robot_state_msg.ee_t_k.header.frame_id, "fr3_hand_tcp");
  ASSERT_EQ(agimus_franka_robot_state_msg.measured_joint_state.name[1], "fr3_joint2");
  ASSERT_EQ(agimus_franka_robot_state_msg.k_f_ext_hat_k.header.frame_id, "fr3_hand_tcp");
  ASSERT_EQ(agimus_franka_robot_state_msg.o_f_ext_hat_k.header.frame_id, "fr3_link0");
  ASSERT_EQ(agimus_franka_robot_state_msg.o_dp_ee_c.header.frame_id, "fr3_link0");
  ASSERT_EQ(agimus_franka_robot_state_msg.o_ddp_ee_c.header.frame_id, "fr3_link0");
}
