# cyberdog visual programming demo
## 概述
> 当前项目为 cyberdog 可视化编程项目针对高级玩家的示例项目。
> 在此默认高级玩家具备脱离APP基于 cyberdog 能力集进行一系列编程，所以示例分为如下三个，用户可以根据自己的使用场景参考：
> 1. cyberdog_vp_demo_cpp: 基于 cyberdog 能力集 C++ API 进行简单展示；
> 2. cyberdog_vp_demo_py: 基于 cyberdog 能力集 Python API 进行简单展示；
> 3. cyberdog_vp_terminal: 基于 cyberdog 能力集 C++ 和 Python API 进行稍复杂的调试展示，该工程请在官方开源cyberdog_vp仓内。

## 注意
如果在调用API过程中，如果想用“断点（breakpoint_block()）”功能，则需要先注册任务以及开启任务，其中：
* 注册任务：以cyberdog为例，在/home/mi/.cyberdog/cyberdog_vp/workspace/task/task.toml中添加如下信息：
```
[task.task_id]                                    # 需要将这里的task_id替换为创建的Cyberdog实例名称
condition = "now"
operate = []
style = "style"
be_depended = []
state = "run_wait"
describe = "Visual default abilityset task."
mode = "cycle"
dependent = []
file = "file"
```
以 "cyberdog = Cyberdog("abilityset_reuse_ros_demo", "namespace", <font color=red size=4>True</font>, "")" 为例，则添加：
```
[task.abilityset_reuse_ros_demo]
condition = "now"
operate = []
style = "style"
be_depended = []
state = "run_wait"
describe = "Visual default abilityset task."
mode = "cycle"
dependent = []
file = "file"
```
* 开启任务：举例如下：
```
cyberdog = Cyberdog("abilityset_reuse_ros_demo", "namespace", True, "")
cyberdog.task.start()
```