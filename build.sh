#!/bin/bash
g++ -o pystatusbar-ng `pkg-config --cflags --libs lua` -lpthread src/*.cpp
