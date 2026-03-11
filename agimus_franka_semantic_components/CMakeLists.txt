cmake_minimum_required(VERSION 3.22)
project(agimus_franka_semantic_components)

option(CHECK_TIDY "Adds clang-tidy tests" OFF)

set(THIS_PACKAGE_INCLUDE_DEPENDS
    agimus_libfranka
    agimus_franka_hardware
    agimus_franka_msgs
    geometry_msgs
    sensor_msgs
    hardware_interface
    rclcpp_lifecycle
    controller_interface
    urdf)

# find dependencies
find_package(ament_cmake REQUIRED)
foreach(Dependency IN ITEMS ${THIS_PACKAGE_INCLUDE_DEPENDS})
  find_package(${Dependency} REQUIRED)
endforeach()

find_package(agimus_libfranka 0.9.3 REQUIRED)
find_package(Eigen3 REQUIRED)

add_library(
  ${PROJECT_NAME} SHARED
  src/agimus_franka_robot_state.cpp
  src/agimus_franka_robot_model.cpp
  src/agimus_franka_cartesian_velocity_interface.cpp
  src/agimus_franka_cartesian_pose_interface.cpp
  src/agimus_franka_semantic_component_interface.cpp
  src/translation_utils.cpp)

target_link_libraries(${PROJECT_NAME} agimus_libfranka::agimus_libfranka Eigen3::Eigen)
target_include_directories(${PROJECT_NAME} PUBLIC include)

ament_target_dependencies(${PROJECT_NAME} agimus_libfranka sensor_msgs
                          geometry_msgs ${THIS_PACKAGE_INCLUDE_DEPENDS})

                        install(TARGETS ${PROJECT_NAME} DESTINATION lib)
install(DIRECTORY include/ DESTINATION include)

if(BUILD_TESTING)
  find_package(ament_cmake_clang_format REQUIRED)
  find_package(ament_cmake_copyright REQUIRED)
  find_package(ament_cmake_cppcheck REQUIRED)
  find_package(ament_cmake_flake8 REQUIRED)
  find_package(ament_cmake_lint_cmake REQUIRED)
  find_package(ament_cmake_pep257 REQUIRED)
  find_package(ament_cmake_xmllint REQUIRED)
  find_package(agimus_franka_msgs REQUIRED)
  find_package(ament_cmake_gmock REQUIRED)
  find_package(controller_interface REQUIRED)

  set(CPP_DIRECTORIES src include)
  ament_clang_format(CONFIG_FILE ../.clang-format ${CPP_DIRECTORIES})
  ament_copyright(${CPP_DIRECTORIES} package.xml)
  ament_cppcheck(${CPP_DIRECTORIES})
  ament_lint_cmake(CMakeLists.txt)
  ament_flake8()
  ament_pep257()
  ament_xmllint()
  if(CHECK_TIDY)
    find_package(ament_cmake_clang_tidy REQUIRED)
    set(ament_cmake_clang_tidy_CONFIG_FILE ../.clang-tidy)
    ament_clang_tidy(${CMAKE_BINARY_DIR} --jobs 6)
  endif()

  ament_add_gmock(test_agimus_franka_robot_state test/agimus_franka_robot_state_test.cpp
APPEND_LIBRARY_DIRS ${CMAKE_BINARY_DIR}
  )
  target_include_directories(test_agimus_franka_robot_state PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
  target_link_libraries(test_agimus_franka_robot_state
    ${PROJECT_NAME}
  )
  ament_target_dependencies(test_agimus_franka_robot_state
    controller_interface
    hardware_interface
    agimus_franka_msgs
    sensor_msgs
    geometry_msgs
    agimus_libfranka
  )
  ament_add_gmock(test_agimus_franka_robot_model test/agimus_franka_robot_model_test.cpp
    APPEND_LIBRARY_DIRS ${CMAKE_BINARY_DIR}
  )
  target_include_directories(test_agimus_franka_robot_model PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)

  target_link_libraries(test_agimus_franka_robot_model
    ${PROJECT_NAME}
  )
  ament_target_dependencies(test_agimus_franka_robot_model
    controller_interface
    hardware_interface
    agimus_franka_msgs
    sensor_msgs
    geometry_msgs
    agimus_libfranka
  )

  ament_add_gmock(
    agimus_franka_semantic_component_interface_test
    test/agimus_franka_semantic_interface_test.cpp
    APPEND_LIBRARY_DIRS ${CMAKE_BINARY_DIR}
  )
  target_include_directories(agimus_franka_semantic_component_interface_test PRIVATE  ${CMAKE_CURRENT_SOURCE_DIR}/include)

  target_link_libraries(agimus_franka_semantic_component_interface_test
    ${PROJECT_NAME}
  )

  ament_target_dependencies(
    agimus_franka_semantic_component_interface_test
    hardware_interface
    sensor_msgs
    geometry_msgs
  )

  ament_add_gmock(
    agimus_franka_cartesian_velocity_interface_test
    test/agimus_franka_cartesian_velocity_interface_test.cpp
    APPEND_LIBRARY_DIRS ${CMAKE_BINARY_DIR}
  )

  target_include_directories(agimus_franka_cartesian_velocity_interface_test PRIVATE  ${CMAKE_CURRENT_SOURCE_DIR}/include)

  target_link_libraries(agimus_franka_cartesian_velocity_interface_test
    ${PROJECT_NAME}
  )

  ament_target_dependencies(
    agimus_franka_cartesian_velocity_interface_test
    hardware_interface
  )

  ament_add_gmock(
    agimus_franka_cartesian_pose_interface_test
    test/agimus_franka_cartesian_pose_interface_test.cpp
    APPEND_LIBRARY_DIRS ${CMAKE_BINARY_DIR}
  )

  target_include_directories(agimus_franka_cartesian_pose_interface_test PRIVATE  ${CMAKE_CURRENT_SOURCE_DIR}/include ${EIGEN3_INCLUDE_DIRS})

  target_link_libraries(agimus_franka_cartesian_pose_interface_test
    ${PROJECT_NAME}
  )

  ament_target_dependencies(
    agimus_franka_cartesian_pose_interface_test
    hardware_interface
    sensor_msgs
    geometry_msgs
  )

  install(FILES test/robot_description_test.txt
    DESTINATION share/${PROJECT_NAME})
endif()

ament_export_include_directories(include)
ament_export_libraries(${PROJECT_NAME})
ament_export_dependencies(${THIS_PACKAGE_INCLUDE_DEPENDS})
ament_package()
