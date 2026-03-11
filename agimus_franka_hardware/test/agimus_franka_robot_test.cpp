#include "agimus_franka_robot_test.hpp"

TEST_F(AgimusFrankaRobotTests, whenInitializeTorqueInterfaceCalled_thenStartTorqueControlCalled) {
  EXPECT_CALL(*mock_libfranka_robot, startTorqueControl()).Times(1);

  agimus_franka_hardware::Robot robot(std::move(mock_libfranka_robot), std::move(mock_model));

  robot.initializeTorqueInterface();
}

TEST_F(AgimusFrankaRobotTests, whenInitializeJointVelocityInterfaceCalled_thenStartJointVelocityControl) {
  EXPECT_CALL(*mock_libfranka_robot, startJointVelocityControl(testing::_)).Times(1);

  agimus_franka_hardware::Robot robot(std::move(mock_libfranka_robot), std::move(mock_model));

  robot.initializeJointVelocityInterface();
}

TEST_F(AgimusFrankaRobotTests,
       whenInitializeJointtPositionInterfaceCalled_thenStartJointPositionControl) {
  EXPECT_CALL(*mock_libfranka_robot, startJointPositionControl(testing::_)).Times(1);

  agimus_franka_hardware::Robot robot(std::move(mock_libfranka_robot), std::move(mock_model));

  robot.initializeJointPositionInterface();
}

TEST_F(AgimusFrankaRobotTests,
       whenInitializeCartesianVelocityInterfaceCalled_thenStartCartesianVelocityControl) {
  EXPECT_CALL(*mock_libfranka_robot, startCartesianVelocityControl(testing::_)).Times(1);

  agimus_franka_hardware::Robot robot(std::move(mock_libfranka_robot), std::move(mock_model));

  robot.initializeCartesianVelocityInterface();
}

TEST_F(AgimusFrankaRobotTests, whenInitializeCartesianPoseInterfaceCalled_thenStartCartesianPoseControl) {
  EXPECT_CALL(*mock_libfranka_robot, startCartesianPoseControl(testing::_)).Times(1);

  agimus_franka_hardware::Robot robot(std::move(mock_libfranka_robot), std::move(mock_model));

  robot.initializeCartesianPoseInterface();
}

TEST_F(AgimusFrankaRobotTests,
       givenCartesianVelocityControlIsStarted_whenReadOnceIsCalled_expectCorrectRobotState) {
  agimus_franka::RobotState robot_state;
  agimus_franka::Duration duration;
  robot_state.q_d = std::array<double, 7>{1, 2, 3, 1, 2, 3, 1};
  auto active_control_read_return_tuple = std::make_pair(robot_state, duration);

  EXPECT_CALL(*mock_active_control, readOnce())
      .WillOnce(testing::Return(active_control_read_return_tuple));
  EXPECT_CALL(*mock_libfranka_robot, startCartesianVelocityControl(testing::_))
      .WillOnce(testing::Return(testing::ByMove((std::move(mock_active_control)))));

  agimus_franka_hardware::Robot robot(std::move(mock_libfranka_robot), std::move(mock_model));

  robot.initializeCartesianVelocityInterface();
  auto actual_state = robot.readOnce();
  ASSERT_EQ(robot_state.q_d, actual_state.q_d);
}

TEST_F(AgimusFrankaRobotTests,
       givenCartesianPoseControlIsStarted_whenReadOnceIsCalled_expectCorrectRobotState) {
  agimus_franka::RobotState robot_state;
  agimus_franka::Duration duration;
  robot_state.q_d = std::array<double, 7>{1, 2, 3, 1, 2, 3, 1};
  auto active_control_read_return_tuple = std::make_pair(robot_state, duration);

  EXPECT_CALL(*mock_active_control, readOnce())
      .WillOnce(testing::Return(active_control_read_return_tuple));
  EXPECT_CALL(*mock_libfranka_robot, startCartesianPoseControl(testing::_))
      .WillOnce(testing::Return(testing::ByMove((std::move(mock_active_control)))));

  agimus_franka_hardware::Robot robot(std::move(mock_libfranka_robot), std::move(mock_model));

  robot.initializeCartesianPoseInterface();
  auto actual_state = robot.readOnce();
  ASSERT_EQ(robot_state.q_d, actual_state.q_d);
}

TEST_F(AgimusFrankaRobotTests,
       givenJointControlIsNotStarted_whenReadOnceIsCalled_expectCorrectRobotState) {
  agimus_franka::RobotState robot_state;
  robot_state.q_d = std::array<double, 7>{1, 2, 3, 1, 2, 3, 1};

  EXPECT_CALL(*mock_libfranka_robot, readOnce()).WillOnce(testing::Return(robot_state));

  agimus_franka_hardware::Robot robot(std::move(mock_libfranka_robot), std::move(mock_model));
  auto actual_state = robot.readOnce();

  ASSERT_EQ(robot_state.q_d, actual_state.q_d);
}

TEST_F(
    AgimusFrankaRobotTests,
    givenCartesianVelocityControlIsStarted_whenWriteOnceIsCalled_expectActiveControlWriteOnceCalled) {
  const std::array<double, 6>& cartesian_velocities{1, 2, 3, 1, 2, 3};
  const agimus_franka::CartesianVelocities expected_cartesian_velocities(cartesian_velocities);

  auto expectCallFunction = [this]() {
    EXPECT_CALL(*mock_libfranka_robot, startCartesianVelocityControl(testing::_))
        .WillOnce(testing::Return(testing::ByMove((std::move(mock_active_control)))));
  };

  testReadWriteOnce<void (agimus_franka_hardware::Robot::*)(), agimus_franka::CartesianVelocities,
                    std::array<double, 6>>(
      &agimus_franka_hardware::Robot::initializeCartesianVelocityInterface, expectCallFunction,
      cartesian_velocities, expected_cartesian_velocities);
}

TEST_F(AgimusFrankaRobotTests,
       givenCartesianPoseControlIsStart_whenWriteOnceIsCalled_expectActiveControlWriteOnceCalled) {
  const std::array<double, 16>& cartesian_pose{2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 2, 0, 2, 3, 4, 1};
  const agimus_franka::CartesianPose expected_cartesian_pose(cartesian_pose);

  auto expectCallFunction = [this]() {
    EXPECT_CALL(*mock_libfranka_robot, startCartesianPoseControl(testing::_))
        .WillOnce(testing::Return(testing::ByMove((std::move(mock_active_control)))));
  };

  testReadWriteOnce<void (agimus_franka_hardware::Robot::*)(), agimus_franka::CartesianPose,
                    std::array<double, 16>>(
      &agimus_franka_hardware::Robot::initializeCartesianPoseInterface, expectCallFunction, cartesian_pose,
      expected_cartesian_pose);
}

TEST_F(
    AgimusFrankaRobotTests,
    givenJointPositionControlIsControlIsStarted_whenWriteOnceIsCalled_expectActiveControlWriteOnceCalled) {
  const std::array<double, 7>& joint_positions{1, 0, 0, 0, 0, 0, 0};
  const agimus_franka::JointPositions expected_joint_positions(joint_positions);

  auto expectCallFunction = [this]() {
    EXPECT_CALL(*mock_libfranka_robot, startJointPositionControl(testing::_))
        .WillOnce(testing::Return(testing::ByMove((std::move(mock_active_control)))));
  };

  testReadWriteOnce<void (agimus_franka_hardware::Robot::*)(), agimus_franka::JointPositions,
                    std::array<double, 7>>(
      &agimus_franka_hardware::Robot::initializeJointPositionInterface, expectCallFunction,
      joint_positions, expected_joint_positions);
}

TEST_F(
    AgimusFrankaRobotTests,
    givenJointVelocityControlIsStarted_whenWriteOnceIsCalled_expectActiveControlWriteOnceCalled) {
  const std::array<double, 7>& joint_velocities{1, 0, 0, 0, 0, 0, 0};
  const agimus_franka::JointVelocities expected_joint_velocities(joint_velocities);

  const auto expectCallFunction = [this]() {
    EXPECT_CALL(*mock_libfranka_robot, startJointVelocityControl(testing::_))
        .WillOnce(testing::Return(testing::ByMove((std::move(mock_active_control)))));
  };

  testReadWriteOnce<void (agimus_franka_hardware::Robot::*)(), agimus_franka::JointVelocities,
                    std::array<double, 7>>(
      &agimus_franka_hardware::Robot::initializeJointVelocityInterface, expectCallFunction,
      joint_velocities, expected_joint_velocities);
}

TEST_F(AgimusFrankaRobotTests,
       givenEffortControlIsStarted_whenWriteOnceIsCalled_expectActiveControlWriteOnceCalled) {
  const std::array<double, 7>& joint_torques{1, 0, 0, 0, 0, 0, 0};
  // Torque rate limiter defaulted to active
  const agimus_franka::Torques expected_joint_torques{0.999999, 0, 0, 0, 0, 0, 0};

  auto expectCallFunction = [this]() {
    EXPECT_CALL(*mock_libfranka_robot, startTorqueControl())
        .WillOnce(testing::Return(testing::ByMove((std::move(mock_active_control)))));
  };

  testReadWriteOnce<void (agimus_franka_hardware::Robot::*)(), agimus_franka::Torques, std::array<double, 7>>(
      &agimus_franka_hardware::Robot::initializeTorqueInterface, expectCallFunction, joint_torques,
      expected_joint_torques);
}

TEST_F(AgimusFrankaRobotTests,
       givenControlIsNotStarted_whenWriteOnceIsCalled_expectRuntimeExceptionToBeThrown) {
  const std::array<double, 7>& joint_torques{1, 0, 0, 0, 0, 0, 0};
  const agimus_franka::Torques joint_torques_franka(joint_torques);

  const std::array<double, 6>& cartesian_velocities{1, 0, 0, 0, 0, 0};
  const agimus_franka::CartesianVelocities cartesian_franka_velocities(cartesian_velocities);

  const std::array<double, 16>& cartesian_pose{1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1};
  const agimus_franka::CartesianPose expected_cartesian_pose(cartesian_pose);

  const std::array<double, 2>& elbow{0.0, 0.0};
  const agimus_franka::CartesianPose expected_cartesian_pose_with_elbow(cartesian_pose, elbow);
  const agimus_franka::CartesianVelocities expected_cartesian_velocities_with_elbow(cartesian_velocities,
                                                                             elbow);

  EXPECT_CALL(*mock_active_control, writeOnce(joint_torques_franka)).Times(0);
  EXPECT_CALL(*mock_active_control, writeOnce(cartesian_franka_velocities)).Times(0);
  EXPECT_CALL(*mock_active_control, writeOnce(expected_cartesian_pose)).Times(0);
  EXPECT_CALL(*mock_active_control, writeOnce(expected_cartesian_velocities_with_elbow)).Times(0);
  EXPECT_CALL(*mock_active_control, writeOnce(expected_cartesian_pose_with_elbow)).Times(0);

  agimus_franka_hardware::Robot robot(std::move(mock_libfranka_robot), std::move(mock_model));

  EXPECT_THROW(robot.writeOnce(joint_torques), std::runtime_error);
  EXPECT_THROW(robot.writeOnce(cartesian_velocities), std::runtime_error);
  EXPECT_THROW(robot.writeOnce(cartesian_velocities, elbow), std::runtime_error);
  EXPECT_THROW(robot.writeOnce(cartesian_pose), std::runtime_error);
  EXPECT_THROW(robot.writeOnce(cartesian_pose, elbow), std::runtime_error);
}
