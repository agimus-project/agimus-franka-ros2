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

#pragma once

#include <algorithm>
#include <memory>
#include <string>
#include <vector>

#include "agimus_franka/model.h"
#include "agimus_franka/robot_state.h"
#include "agimus_franka_semantic_components/agimus_franka_robot_model.hpp"
#include "gmock/gmock.h"

class AgimusFrankaRobotModelTest;

class MockModel : public agimus_franka_hardware::Model {
 public:
  MOCK_METHOD((std::array<double, 7>), gravity, (const agimus_franka::RobotState&), (const, override));
  MOCK_METHOD((std::array<double, 7>), coriolis, (const agimus_franka::RobotState&), (const, override));
  MOCK_METHOD((std::array<double, 16>),
              pose,
              (agimus_franka::Frame, const agimus_franka::RobotState&),
              (const, override));
  MOCK_METHOD((std::array<double, 42>),
              bodyJacobian,
              (agimus_franka::Frame, const agimus_franka::RobotState&),
              (const, override));
  MOCK_METHOD((std::array<double, 42>),
              zeroJacobian,
              (agimus_franka::Frame, const agimus_franka::RobotState&),
              (const, override));
  MOCK_METHOD((std::array<double, 49>), mass, (const agimus_franka::RobotState&), (const, override));
};

class AgimusFrankaRobotModelTestFriend : public agimus_franka_semantic_components::AgimusFrankaRobotModel {
  FRIEND_TEST(AgimusFrankaRobotModelTest, validate_state_names_and_size);
  FRIEND_TEST(AgimusFrankaRobotModelTest,
              given_franka_semantic_model_initialized_when_get_coriolis_expect_one);
  FRIEND_TEST(AgimusFrankaRobotModelTest,
              given_franka_semantic_model_initialized_when_get_gravity_expect_one);
  FRIEND_TEST(AgimusFrankaRobotModelTest,
              given_franka_semantic_model_initialized_when_get_pose_expect_one);
  FRIEND_TEST(AgimusFrankaRobotModelTest,
              given_franka_semantic_model_initialized_when_get_mass_expect_correct);
  FRIEND_TEST(AgimusFrankaRobotModelTest, given_franka_semantic_model_not_initialized_expect_exception);
  FRIEND_TEST(AgimusFrankaRobotModelTest,
              given_franka_semantic_model_not_initialized_when_get_gravity_called_expect_exception);
  FRIEND_TEST(AgimusFrankaRobotModelTest,
              given_franka_semantic_model_not_initialized_when_get_pose_called_expect_exception);
  FRIEND_TEST(AgimusFrankaRobotModelTest,
              given_franka_semantic_model_not_initialized_when_get_pose_called_expect_exception);
  FRIEND_TEST(
      AgimusFrankaRobotModelTest,
      given_franka_semantic_model_not_initialized_when_get_body_jacobian_called_expect_exception);
  FRIEND_TEST(
      AgimusFrankaRobotModelTest,
      given_franka_semantic_model_not_initialized_when_get_zero_jacobian_called_expect_exception);

 public:
  AgimusFrankaRobotModelTestFriend(const std::string& model_interface_name,
                             const std::string& model_state_name)
      : agimus_franka_semantic_components::AgimusFrankaRobotModel(model_interface_name, model_state_name) {}
  AgimusFrankaRobotModelTestFriend() = delete;

  virtual ~AgimusFrankaRobotModelTestFriend() = default;
};

class AgimusFrankaRobotModelTest : public ::testing::Test {
 public:
  void SetUp();
  void TearDown();

 protected:
  const size_t size = 2;
  const std::string robot_name = "fr3";
  const std::string agimus_franka_model_interface_name = "robot_model";
  const std::string agimus_franka_state_interface_name = "robot_state";

  MockModel mock_model;
  MockModel* model_address = &mock_model;

  agimus_franka::RobotState robot_state;
  agimus_franka::RobotState* robot_state_address = &robot_state;

  std::unique_ptr<AgimusFrankaRobotModelTestFriend> agimus_franka_robot_model_friend;

  std::vector<std::string> full_interface_names;
};
