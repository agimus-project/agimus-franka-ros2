cmake_minimum_required(VERSION 3.22)
set(BASE_NAME franka_hardware)
project(agimus_${BASE_NAME})

option(CHECK_TIDY "Adds clang-tidy tests" OFF)

# find dependencies
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(rclcpp_action REQUIRED)
find_package(agimus_franka_msgs REQUIRED)
find_package(hardware_interface REQUIRED)
find_package(pluginlib REQUIRED)
find_package(agimus_libfranka 0.9.3 REQUIRED)
find_package(rclcpp_components REQUIRED)

add_library(${BASE_NAME} SHARED
        src/franka_action_server.cpp
        src/franka_hardware_interface.cpp
        src/robot.cpp
        src/franka_param_service_server.cpp
        src/franka_executor.cpp
)

target_include_directories(
        ${BASE_NAME}
        PRIVATE
        include
)
target_link_libraries(${BASE_NAME} agimus_libfranka::agimus_libfranka)

ament_target_dependencies(
        ${BASE_NAME}
        hardware_interface
        agimus_libfranka
        pluginlib
        rclcpp
        rclcpp_action
        agimus_franka_msgs
)

pluginlib_export_plugin_description_file(hardware_interface ${BASE_NAME}.xml)


install(
        TARGETS ${BASE_NAME}
        DESTINATION lib
)
install(
        DIRECTORY include/
        DESTINATION include
)

if(BUILD_TESTING)
    find_package(ament_cmake_clang_format REQUIRED)
    find_package(ament_cmake_copyright REQUIRED)
    find_package(ament_cmake_cppcheck REQUIRED)
    find_package(ament_cmake_flake8 REQUIRED)
    find_package(ament_cmake_lint_cmake REQUIRED)
    find_package(ament_cmake_pep257 REQUIRED)
    find_package(ament_cmake_xmllint REQUIRED)

    set(CPP_DIRECTORIES src include)
    ament_clang_format(CONFIG_FILE ../.clang-format ${CPP_DIRECTORIES})
    ament_copyright(${CPP_DIRECTORIES} package.xml)
    ament_cppcheck(${CPP_DIRECTORIES})
    ament_lint_cmake(CMakeLists.txt)
    ament_flake8()
    ament_pep257()
    ament_xmllint()

    add_subdirectory(test)

    if(CHECK_TIDY)
        find_package(ament_cmake_clang_tidy REQUIRED)
        set(ament_cmake_clang_tidy_CONFIG_FILE ../.clang-tidy)
        ament_clang_tidy(${CMAKE_BINARY_DIR} --jobs 6)
    endif()
endif()

ament_export_include_directories(
        include
)

ament_export_libraries(
        ${BASE_NAME}
)
ament_export_dependencies(
        hardware_interface
        pluginlib
        rclcpp
)
ament_package()
