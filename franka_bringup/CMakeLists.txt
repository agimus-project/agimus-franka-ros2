cmake_minimum_required(VERSION 3.22)
set(BASE_NAME franka_bringup)
project(agimus_${BASE_NAME})

find_package(ament_cmake REQUIRED)

install(
  DIRECTORY config launch
  DESTINATION share/${BASE_NAME}
)

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  ament_lint_auto_find_test_dependencies()
endif()

ament_package()
