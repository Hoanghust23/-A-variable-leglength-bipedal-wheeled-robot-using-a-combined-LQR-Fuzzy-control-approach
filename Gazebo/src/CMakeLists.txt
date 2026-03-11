cmake_minimum_required(VERSION 2.8.3)

project(robotcanbang_1)

find_package(catkin REQUIRED COMPONENTS
  rospy
  std_msgs
  sensor_msgs
  geometry_msgs
  tf
  gazebo_ros
)

catkin_package()

find_package(roslaunch)

# Install directories
foreach(dir config launch meshes urdf scripts)
  install(DIRECTORY ${dir}/
    DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/${dir})
endforeach(dir)

# Install Python scripts
catkin_install_python(PROGRAMS
  scripts/lqr_balance_controller.py
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)
