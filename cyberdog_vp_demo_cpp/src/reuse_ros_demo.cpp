// Copyright (c) 2023 Beijing Xiaomi Mobile Software Co., Ltd. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <pybind11/pybind11.h>
#include <pybind11/embed.h>
#include <pybind11/stl.h>
#include <pybind11/complex.h>
#include <pybind11/functional.h>
#include <pybind11/chrono.h>

#include <rclcpp/rclcpp.hpp>
#include <cyberdog_vp_abilityset/cyberdog.hpp>

#include <iostream>

int main(int argc, char ** argv)
{
  try {
    std::cout << "Cyberdog abilityset demo node started." << std::endl;
    pybind11::scoped_interpreter guard{};

    auto get_namespace = [&]() -> std::string {
      pybind11::object get_namespace_py;
      pybind11::module manual = pybind11::module::import("mi.cyberdog_bringup.manual");
      if (!pybind11::hasattr(manual, "get_namespace")) {
        ERROR("'get_namespace()' function not found in 'mi.cyberdog_bringup.manual' module");
        return "null_namespace";
      }
      get_namespace_py = manual.attr("get_namespace");
      pybind11::object namespace_py = get_namespace_py();
      return std::string(namespace_py.cast<std::string>());
    };

    rclcpp::init(argc, argv);
    cyberdog_visual_programming_abilityset::Cyberdog cyberdog("abilityset_reuse_ros_demo",
      get_namespace(), false, "");
    if (cyberdog.state_.code != cyberdog_visual_programming_abilityset::StateCode::success) {
      std::cerr << "Cyberdog abilityset demo node is " << cyberdog.state_.describe << "." <<
        std::endl;
      rclcpp::shutdown();
      return 1;
    }
    std::cout << "Do somthine ..." << std::endl;
    cyberdog.audio_.OfflinePlay();  // 比如：汪汪
    std::cout << "Cyberdog abilityset demo node stopped." << std::endl;
    cyberdog.Shutdown();
    rclcpp::shutdown();
    return 0;
  } catch (const std::exception & e) {
    std::cerr << "Cyberdog abilityset demo node is failed, " << e.what() << "." << std::endl;
  }
  rclcpp::shutdown();
  return 2;
}
