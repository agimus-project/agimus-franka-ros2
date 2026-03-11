ament_add_gmock(${PROJECT_NAME}_test
  agimus_franka_hardware_interface_test.cpp
  agimus_franka_action_server_test.cpp
  APPEND_LIBRARY_DIRS ${CMAKE_BINARY_DIR}
)
target_include_directories(${PROJECT_NAME}_test PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../include)
target_link_libraries(${PROJECT_NAME}_test ${PROJECT_NAME} ${${_default_rmw}_LIBRARIES})


ament_add_gmock(${PROJECT_NAME}_command_interface_test agimus_franka_hardware_cartesian_command_interface_test.cpp
  APPEND_LIBRARY_DIRS ${CMAKE_BINARY_DIR}
)
target_include_directories(${PROJECT_NAME}_command_interface_test PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../include)
target_link_libraries(${PROJECT_NAME}_command_interface_test ${PROJECT_NAME})

ament_add_gmock(${PROJECT_NAME}_robot_test agimus_franka_robot_test.cpp
  APPEND_LIBRARY_DIRS ${CMAKE_BINARY_DIR}
)
target_include_directories(${PROJECT_NAME}_robot_test PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../include)
target_link_libraries(${PROJECT_NAME}_robot_test ${PROJECT_NAME})
