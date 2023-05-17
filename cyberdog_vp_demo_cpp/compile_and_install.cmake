# Copyright (c) 2023 Beijing Xiaomi Mobile Software Co., Ltd. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# 功能说明: 修改目标依赖项私有(ament_target_dependencies 会将依赖项声明为私有，但这是 pybind11 所需的，所以复制粘贴)
#
function(ament_target_dependencies_private target)
  if(NOT TARGET ${target})
    message(FATAL_ERROR "ament_target_dependencies() the first argument must be a valid target name")
  endif()
  if(${ARGC} GREATER 0)
    set(definitions "")
    set(include_dirs "")
    set(libraries "")
    set(link_flags "")
    foreach(package_name ${ARGN})
      if(NOT ${${package_name}_FOUND})
        message(FATAL_ERROR "ament_target_dependencies() the passed package name '${package_name}' was not found before")
      endif()
      list_append_unique(definitions ${${package_name}_DEFINITIONS})
      list_append_unique(include_dirs ${${package_name}_INCLUDE_DIRS})
      list(APPEND libraries ${${package_name}_LIBRARIES})
      list_append_unique(link_flags ${${package_name}_LINK_FLAGS})
    endforeach()
    target_compile_definitions(${target}
      PUBLIC ${definitions})
    ament_include_directories_order(ordered_include_dirs ${include_dirs})
    target_include_directories(${target}
      PUBLIC ${ordered_include_dirs})
    ament_libraries_deduplicate(unique_libraries ${libraries})
    target_link_libraries(${target} PRIVATE
      ${unique_libraries})
    foreach(link_flag IN LISTS link_flags)
      set_property(TARGET ${target} APPEND_STRING PROPERTY LINK_FLAGS " ${link_flag} ")
    endforeach()
  endif()
endfunction()

#
# 功能说明: 编译和安装 节点
#
function(compile_and_install_node target)
  cmake_parse_arguments(_ARG "LOG" "" "" ${ARGN})
  if(_${PROJECT_NAME}_AMENT_PACKAGE)
    message(FATAL_ERROR "compile_and_install_node() Must be called before ament_package().")
  endif()
  if(_ARG_LOG)
    message("Compiling and installing ${PROJECT_NAME} node ...")
  endif()

  add_executable(${target}
    src/${target}.cpp)
  target_link_libraries(${target} PRIVATE
    pybind11::module
    pybind11::embed
    ${CMAKE_INSTALL_PREFIX}/lib/libcyberdog_log.so
    ${CMAKE_INSTALL_PREFIX}/lib/libcyberdog_vp_abilityset.so
  )
  target_compile_features(${target} PUBLIC c_std_99 cxx_std_17)  # Require C99 and C++17
  target_include_directories(${target} PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
  )
  ament_target_dependencies_private(${target}
    ament_index_cpp
    rclcpp
    rclcpp_action
    tf2
    tf2_ros
    tf2_msgs
    sensor_msgs
    nav_msgs
    std_srvs
    protocol
    cyberdog_common
    pybind11::embed
    cyberdog_vp_abilityset
  )
  install(TARGETS ${target} DESTINATION lib/${PROJECT_NAME})

  if(_ARG_LOG)
    message("Node ${_node_flag} compiled and installed.")
  endif()
endfunction()
