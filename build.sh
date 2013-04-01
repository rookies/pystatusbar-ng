#!/bin/bash
g++ -o pystatusbar-ng -Iinclude $(pkg-config --cflags --libs lua) -lpthread src/*.cpp
