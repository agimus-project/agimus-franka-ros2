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

#include <gmock/gmock.h>

#include "controller_interface/controller_interface.hpp"
#include "agimus_franka_robot_state_broadcaster/agimus_franka_robot_state_broadcaster.hpp"
#include "agimus_franka_semantic_components/agimus_franka_robot_state.hpp"
#include "hardware_interface/types/hardware_interface_return_values.hpp"
#include "hardware_interface/types/hardware_interface_type_values.hpp"
#include "rclcpp/rclcpp.hpp"
#include "ros2_control_test_assets/descriptions.hpp"

class MockAgimusFrankaRobotState : public agimus_franka_semantic_components::AgimusFrankaRobotState {
 public:
  MockAgimusFrankaRobotState(const std::string& name, const std::string& robot_description)
      : AgimusFrankaRobotState(name, robot_description){};

  MOCK_METHOD(void, initialize_robot_state_msg, (agimus_franka_msgs::msg::AgimusFrankaRobotState&), (override));
};

using namespace agimus_franka_robot_state_broadcaster;
class TestAgimusFrankaRobotStateBroadcaster : public ::testing::Test {
 protected:
  void SetUp() override {
    agimus_franka_robot_state_ = std::make_unique<MockAgimusFrankaRobotState>(
        "mock_franka_robot_state", ros2_control_test_assets::minimal_robot_urdf);
    broadcaster_ = std::make_unique<AgimusFrankaRobotStateBroadcaster>(std::move(agimus_franka_robot_state_));
    broadcaster_->init("test_broadcaster");
    broadcaster_->get_node()->set_parameter(
        {"robot_description", ros2_control_test_assets::minimal_robot_urdf});
  }
  std::unique_ptr<AgimusFrankaRobotStateBroadcaster> broadcaster_;
  std::unique_ptr<MockAgimusFrankaRobotState> agimus_franka_robot_state_;
};

TEST_F(TestAgimusFrankaRobotStateBroadcaster, test_init_return_success) {
  EXPECT_EQ(broadcaster_->on_init(), controller_interface::CallbackReturn::SUCCESS);
}

TEST_F(TestAgimusFrankaRobotStateBroadcaster, test_configure_return_success) {
  EXPECT_EQ(broadcaster_->on_configure(rclcpp_lifecycle::State()),
            controller_interface::CallbackReturn::SUCCESS);
}

TEST_F(TestAgimusFrankaRobotStateBroadcaster, test_activate_return_success) {
  EXPECT_EQ(broadcaster_->on_configure(rclcpp_lifecycle::State()),
            controller_interface::CallbackReturn::SUCCESS);
  EXPECT_EQ(broadcaster_->on_activate(rclcpp_lifecycle::State()),
            controller_interface::CallbackReturn::SUCCESS);
}

TEST_F(TestAgimusFrankaRobotStateBroadcaster, test_deactivate_return_success) {
  EXPECT_EQ(broadcaster_->on_configure(rclcpp_lifecycle::State()),
            controller_interface::CallbackReturn::SUCCESS);
  EXPECT_EQ(broadcaster_->on_deactivate(rclcpp_lifecycle::State()),
            controller_interface::CallbackReturn::SUCCESS);
}

TEST_F(TestAgimusFrankaRobotStateBroadcaster, test_update_without_franka_state_interface_returns_error) {
  EXPECT_EQ(broadcaster_->on_configure(rclcpp_lifecycle::State()),
            controller_interface::CallbackReturn::SUCCESS);
  EXPECT_EQ(broadcaster_->on_activate(rclcpp_lifecycle::State()),
            controller_interface::CallbackReturn::SUCCESS);
  rclcpp::Time time(0.0, 0.0);
  rclcpp::Duration period(0, 0);

  EXPECT_EQ(broadcaster_->update(time, period), controller_interface::return_type::ERROR);
}

TEST_F(TestAgimusFrankaRobotStateBroadcaster, test_update_with_franka_state_returns_success) {
  // Todo(anyone)
  GTEST_SKIP() << "Realtime publisher lock behaviour is not deterministic";
  EXPECT_EQ(broadcaster_->on_configure(rclcpp_lifecycle::State()),
            controller_interface::CallbackReturn::SUCCESS);
  EXPECT_EQ(broadcaster_->on_activate(rclcpp_lifecycle::State()),
            controller_interface::CallbackReturn::SUCCESS);

  rclcpp::Time time(0.0, 0.0);
  rclcpp::Duration period(0, 0);

  EXPECT_EQ(broadcaster_->update(time, period), controller_interface::return_type::OK);
}

int main(int argc, char** argv) {
  ::testing::InitGoogleTest(&argc, argv);
  rclcpp::init(argc, argv);
  int result = RUN_ALL_TESTS();
  rclcpp::shutdown();
  return result;
}
