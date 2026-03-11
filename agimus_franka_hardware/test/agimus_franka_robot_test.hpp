#include <gmock/gmock.h>
#include <algorithm>
#include <functional>

#include <agimus_franka/active_control_base.h>
#include <agimus_franka/robot.h>
#include "agimus_franka_hardware/robot.hpp"
#include "test_utils.hpp"

#pragma once

class MockActiveControl : public agimus_franka::ActiveControlBase {
 public:
  MOCK_METHOD((std::pair<agimus_franka::RobotState, agimus_franka::Duration>), readOnce, (), (override));
  MOCK_METHOD(void, writeOnce, (const agimus_franka::Torques&), (override));
  MOCK_METHOD(void,
              writeOnce,
              (const agimus_franka::JointPositions&, const std::optional<const agimus_franka::Torques>&),
              (override));
  MOCK_METHOD(void,
              writeOnce,
              (const agimus_franka::JointVelocities&, const std::optional<const agimus_franka::Torques>&),
              (override));
  MOCK_METHOD(void,
              writeOnce,
              (const agimus_franka::CartesianPose&, const std::optional<const agimus_franka::Torques>&),
              (override));
  MOCK_METHOD(void,
              writeOnce,
              (const agimus_franka::CartesianVelocities&, const std::optional<const agimus_franka::Torques>&),
              (override));
  MOCK_METHOD(void, writeOnce, (const agimus_franka::JointPositions&), (override));
  MOCK_METHOD(void, writeOnce, (const agimus_franka::JointVelocities&), (override));
  MOCK_METHOD(void, writeOnce, (const agimus_franka::CartesianPose&), (override));
  MOCK_METHOD(void, writeOnce, (const agimus_franka::CartesianVelocities&), (override));
};

class MockAgimusFrankaRobot : public agimus_franka::Robot {
 public:
  MOCK_METHOD(agimus_franka::RobotState, readOnce, (), (override));
  MOCK_METHOD(std::unique_ptr<agimus_franka::ActiveControlBase>, startTorqueControl, (), (override));
  MOCK_METHOD(std::unique_ptr<agimus_franka::ActiveControlBase>,
              startJointVelocityControl,
              (const agimus_research_interface::robot::Move::ControllerMode&),
              (override));
  MOCK_METHOD(std::unique_ptr<agimus_franka::ActiveControlBase>,
              startJointPositionControl,
              (const agimus_research_interface::robot::Move::ControllerMode&),
              (override));
  MOCK_METHOD(std::unique_ptr<agimus_franka::ActiveControlBase>,
              startCartesianPoseControl,
              (const agimus_research_interface::robot::Move::ControllerMode&),
              (override));
  MOCK_METHOD(std::unique_ptr<agimus_franka::ActiveControlBase>,
              startCartesianVelocityControl,
              (const agimus_research_interface::robot::Move::ControllerMode&),
              (override));
};

namespace agimus_franka {

template <typename T>
bool compareWithTolerance(const T& lhs, const T& rhs) {
  return std::equal(lhs.begin(), lhs.end(), rhs.begin(),
                    [](double lhs_element, double rhs_element) {
                      return std::abs(lhs_element - rhs_element) < k_EPS;
                    });
}

bool operator==(const CartesianVelocities& lhs, const CartesianVelocities& rhs) {
  return compareWithTolerance(lhs.O_dP_EE, rhs.O_dP_EE);
}

bool operator==(const CartesianPose& lhs, const CartesianPose& rhs) {
  return compareWithTolerance(lhs.O_T_EE, rhs.O_T_EE);
}

bool operator==(const JointPositions& lhs, const JointPositions& rhs) {
  return compareWithTolerance(lhs.q, rhs.q);
}

bool operator==(const JointVelocities& lhs, const JointVelocities& rhs) {
  return compareWithTolerance(lhs.dq, rhs.dq);
}

bool operator==(const Torques& lhs, const Torques& rhs) {
  return compareWithTolerance(lhs.tau_J, rhs.tau_J);
}
}  // namespace agimus_franka

class AgimusFrankaRobotTests : public ::testing::Test {
 protected:
  std::unique_ptr<MockAgimusFrankaRobot> mock_libfranka_robot;
  std::unique_ptr<MockModel> mock_model;
  std::unique_ptr<MockActiveControl> mock_active_control;

  template <typename RobotInitFunction, typename ControlType, typename RawControlInputType>
  void testReadWriteOnce(RobotInitFunction initFunction,
                         std::function<void()> expectCallFunction,
                         const RawControlInputType& control_input,
                         const ControlType& expected_active_control_input) {
    EXPECT_CALL(*mock_active_control, writeOnce(expected_active_control_input));
    EXPECT_CALL(*mock_active_control, readOnce());
    expectCallFunction();
    agimus_franka_hardware::Robot robot(std::move(mock_libfranka_robot), std::move(mock_model));
    (robot.*initFunction)();
    robot.readOnce();
    robot.writeOnce(control_input);
  }

  void SetUp() override {
    mock_libfranka_robot = std::make_unique<MockAgimusFrankaRobot>();
    mock_model = std::make_unique<MockModel>();
    mock_active_control = std::make_unique<MockActiveControl>();
  }
  void TearDown() override {
    mock_libfranka_robot.reset();
    mock_model.reset();
    mock_active_control.reset();
  }
};
