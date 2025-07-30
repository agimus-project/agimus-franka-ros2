cmake_minimum_required(VERSION 3.22)
project(agimus_franka_ign_ros2_control)

# Find dependencies
find_package(ament_cmake REQUIRED)
find_package(ament_index_cpp REQUIRED)
find_package(controller_manager REQUIRED)
find_package(hardware_interface REQUIRED)
find_package(pluginlib REQUIRED)
find_package(rclcpp REQUIRED)
find_package(yaml_cpp_vendor REQUIRED)
find_package(agimus_franka_hardware REQUIRED)
find_package(urdf REQUIRED)
find_package(kdl_parser REQUIRED)
find_package(agimus_libfranka 0.9.3 REQUIRED)
find_package(tf2_geometry_msgs REQUIRED)
find_package(tf2_eigen REQUIRED)

if("$ENV{IGNITION_VERSION}" STREQUAL "garden")
  find_package(gz-sim7 REQUIRED)
  set(GZ_SIM_VER ${gz-sim7_VERSION_MAJOR})
  message(STATUS "Compiling against Gazebo garden")
  find_package(gz-plugin2 REQUIRED)
  set(GZ_PLUGIN_VER ${gz-plugin2_VERSION_MAJOR})

elseif("$ENV{GAZEBO_VERSION}" STREQUAL "harmonic")
  find_package(gz-sim8 REQUIRED)
  set(GZ_SIM_VER ${gz-sim8_VERSION_MAJOR})
  message(STATUS "Compiling against Gazebo Harmonic")
  find_package(gz-plugin2 REQUIRED)
  set(GZ_PLUGIN_VER ${gz-plugin2_VERSION_MAJOR})

elseif("$ENV{GAZEBO_VERSION}" STREQUAL "ionic")
  find_package(gz-sim9 REQUIRED)
  set(GZ_SIM_VER ${gz-sim9_VERSION_MAJOR})
  message(STATUS "Compiling against Gazebo Ionic")
  find_package(gz-plugin3 REQUIRED)
  set(GZ_PLUGIN_VER ${gz-plugin3_VERSION_MAJOR})

elseif("$ENV{GAZEBO_VERSION}" STREQUAL "jetty")
  find_package(gz-sim10 REQUIRED)
  set(GZ_SIM_VER ${gz-sim10_VERSION_MAJOR})
  message(STATUS "Compiling against Gazebo Jetty")
  find_package(gz-plugin4 REQUIRED)
  set(GZ_PLUGIN_VER ${gz-plugin4_VERSION_MAJOR})

else()
  find_package(gz-sim8 REQUIRED)
  set(GZ_SIM_VER ${gz-sim8_VERSION_MAJOR})
  message(STATUS "Compiling against Gazebo Harmonic")
  find_package(gz-plugin2 REQUIRED)
  set(GZ_PLUGIN_VER ${gz-plugin2_VERSION_MAJOR})
endif()


include_directories(include)

add_library(${PROJECT_NAME}-system SHARED
  src/ign_ros2_control_plugin.cpp
  src/model_kdl.cpp
)

target_link_libraries(${PROJECT_NAME}-system
        gz-sim${GZ_SIM_VER}::core
  gz-plugin${GZ_PLUGIN_VER}::register
)
ament_target_dependencies(${PROJECT_NAME}-system
  ament_index_cpp
  controller_manager
  hardware_interface
  pluginlib
  rclcpp
  yaml_cpp_vendor
  rclcpp_lifecycle
  agimus_franka_hardware
  agimus_libfranka
  urdf
  kdl_parser
  tf2_geometry_msgs
  tf2_eigen
)

#########

add_library(ign_hardware_plugins SHARED
  src/ign_system.cpp
  src/model_kdl.cpp
)
ament_target_dependencies(ign_hardware_plugins
  rclcpp_lifecycle
  hardware_interface
  rclcpp
  agimus_franka_hardware
  agimus_libfranka
  urdf
  kdl_parser
  tf2_geometry_msgs
  tf2_eigen
)
target_link_libraries(ign_hardware_plugins
        gz-sim${GZ_SIM_VER}::core
)

## Install
install(TARGETS
  ign_hardware_plugins
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION bin
)

install(DIRECTORY
  include/
  DESTINATION include
)

ament_export_include_directories(include)
ament_export_libraries(${PROJECT_NAME}-system ign_hardware_plugins)

# Install directories
install(TARGETS ${PROJECT_NAME}-system
  DESTINATION lib
)

pluginlib_export_plugin_description_file(${PROJECT_NAME} ign_hardware_plugins.xml)

# Setup the project
ament_package()
