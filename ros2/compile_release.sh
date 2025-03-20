#!/bin/bash
export CMAKE_PREFIX_PATH=/usr/include/x86_64-linux-gnu/TensorRT:$CMAKE_PREFIX_PATH
colcon build --packages-select=bevfusion --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=ON