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

import rclpy
from mi.cyberdog_bringup.manual import get_namespace
from mi.cyberdog_vp.abilityset import Cyberdog
from mi.cyberdog_vp.abilityset import StateCode


def main(args=None):
    print("Cyberdog abilityset demo node started.")
    rclpy.init(args=args)  # Cyberdog 内部无感，下面初始化依旧需要初始化自己的ROS环境
    cyberdog = Cyberdog("abilityset_reuse_ros_demo", get_namespace(), True, "")
    if cyberdog.state.code != StateCode.success:
        print("Cyberdog abilityset demo node is ", cyberdog.state.describe, ".")
        return 1
    print("Do somthine ...")
    cyberdog.audio.offline_play()
    print("Cyberdog abilityset demo node stopped.")
    cyberdog.shutdown()
    rclpy.shutdown()
    return 0


if __name__ == "__main__":
    main()
