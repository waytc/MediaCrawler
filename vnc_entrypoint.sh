#!/bin/bash
# 启动 VNC 和 NoVNC 服务
/usr/bin/vnc_startup.sh &

# 保持 VNC 服务运行 1 秒，确保服务就绪
sleep 1

# 执行 CMD 传递进来的参数
exec "$@"