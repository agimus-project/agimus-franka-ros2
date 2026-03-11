cmake_minimum_required(VERSION 3.22)
set(BASE_NAME integration_launch_testing)
project(agimus_${BASE_NAME})

# find dependencies
find_package(ament_cmake REQUIRED)

install(
  DIRECTORY test
  DESTINATION share/${BASE_NAME}
)

if(BUILD_TESTING)
    find_package(ament_cmake_copyright REQUIRED)
    find_package(ament_cmake_flake8 REQUIRED)
    find_package(ament_cmake_lint_cmake REQUIRED)
    find_package(ament_cmake_pep257 REQUIRED)
    find_package(ament_cmake_xmllint REQUIRED)
    find_package(launch_testing_ament_cmake)

    ament_copyright(package.xml)
    ament_lint_cmake(CMakeLists.txt)
    ament_flake8()
    ament_pep257()
    ament_xmllint()
endif()

ament_export_libraries(
  ${BASE_NAME}
)
ament_package()
