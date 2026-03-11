cmake_minimum_required(VERSION 3.22)
project(agimus_franka_robot_state_broadcaster)

option(CHECK_TIDY "Adds clang-tidy tests" OFF)

set(THIS_PACKAGE_INCLUDE_DEPENDS
    builtin_interfaces
    control_msgs
    controller_interface
    controller_manager
    agimus_franka_msgs
    agimus_franka_semantic_components
    generate_parameter_library
    pluginlib
    rclcpp_lifecycle
    rcutils
    realtime_tools
    sensor_msgs
    visualization_msgs)


# find dependencies
find_package(ament_cmake REQUIRED)

foreach(Dependency IN ITEMS ${THIS_PACKAGE_INCLUDE_DEPENDS})
  find_package(${Dependency} REQUIRED)
endforeach()

add_library(${PROJECT_NAME}
        SHARED
        src/${PROJECT_NAME}.cpp)
target_include_directories(
  ${PROJECT_NAME}
        PRIVATE
        include
)


generate_parameter_library(agimus_franka_robot_state_broadcaster_parameters src/agimus_franka_robot_state_broadcaster_parameters.yaml)

target_link_libraries(${PROJECT_NAME}
                      PUBLIC agimus_franka_robot_state_broadcaster_parameters)
                    ament_target_dependencies(${PROJECT_NAME} PUBLIC
                          ${THIS_PACKAGE_INCLUDE_DEPENDS})


                        pluginlib_export_plugin_description_file(controller_interface ${PROJECT_NAME}.xml)


install(
  TARGETS ${PROJECT_NAME}
        DESTINATION lib
)
install(
        DIRECTORY include/
        DESTINATION include
)


if(BUILD_TESTING)
    find_package(ament_cmake_gmock REQUIRED)
    find_package(ament_cmake_clang_format REQUIRED)
    find_package(ament_cmake_copyright REQUIRED)
    find_package(ament_cmake_cppcheck REQUIRED)
    find_package(ament_cmake_flake8 REQUIRED)
    find_package(ament_cmake_lint_cmake REQUIRED)
    find_package(ament_cmake_pep257 REQUIRED)
    find_package(ament_cmake_xmllint REQUIRED)
    find_package(ros2_control_test_assets REQUIRED)
    find_package(controller_manager REQUIRED)

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

    ament_add_gmock(${PROJECT_NAME}_test
        test/test_agimus_franka_robot_state_broadcaster.cpp
        APPEND_LIBRARY_DIRS ${CMAKE_BINARY_DIR})
        # ${CMAKE_CURRENT_SOURCE_DIR}/test/agimus_franka_robot_state_broadcaster_parameters.yaml)
    target_include_directories(${PROJECT_NAME}_test PRIVATE include)
    target_link_libraries(${PROJECT_NAME}_test ${PROJECT_NAME})
    ament_target_dependencies(${PROJECT_NAME}_test controller_manager hardware_interface ros2_control_test_assets)

    ament_add_gmock(test_load_agimus_franka_robot_state_broadcaster test/test_load_agimus_franka_robot_state_broadcaster.cpp
      APPEND_LIBRARY_DIRS ${CMAKE_BINARY_DIR})
    target_include_directories(test_load_agimus_franka_robot_state_broadcaster PRIVATE include)
    target_link_libraries(test_load_agimus_franka_robot_state_broadcaster ${PROJECT_NAME})
    ament_target_dependencies(
      test_load_agimus_franka_robot_state_broadcaster controller_manager hardware_interface
      ros2_control_test_assets)
endif()

ament_export_include_directories(
        include
)
ament_export_libraries(
  ${PROJECT_NAME}
)
ament_export_dependencies(
        hardware_interface
        pluginlib
        rclcpp
)
ament_package()
