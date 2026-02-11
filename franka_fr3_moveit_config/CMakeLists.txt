cmake_minimum_required(VERSION 3.22)
set(BASE_NAME franka_fr3_moveit_config)
project(agimus_${BASE_NAME})

find_package(ament_cmake REQUIRED)

install(
  DIRECTORY config launch srdf rviz
  DESTINATION share/${BASE_NAME}
)

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  ament_lint_auto_find_test_dependencies()

  find_package(ament_cmake_pytest REQUIRED)
  ament_add_pytest_test(${PROJECT_NAME}_srdf_tests test/srdf_tests.py)
endif()

ament_package()
