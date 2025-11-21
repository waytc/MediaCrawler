#!/bin/bash
# 启动 Xvfb (虚拟帧缓冲，作为虚拟屏幕)
Xvfb :99 -screen 0 1280x1024x24 &

# 启动 VNC 服务器，监听虚拟屏幕 :99
x11vnc -display :99 -passwd $VNC_PASSWD -forever -nopw -loop -xkb -bg -rfbport 5900 -quiet &

# 启动 NoVNC (Websocket 代理)
websockify 6901 localhost:5900 &

# 执行 CMD 传递进来的参数
exec "$@"