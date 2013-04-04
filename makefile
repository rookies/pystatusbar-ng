#  makefile
#  
#  Copyright 2013 Robert Knauer <robert@privatdemail.net>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#

RM=rm
CXX=g++

OBJ=build/main.o build/plugin.o build/statusbar.o
LIBS=lua
CXXFLAGS=-I include -c `pkg-config --cflags $(LIBS)`
LDFLAGS=-lpthread `pkg-config --libs $(LIBS)`

pystatusbar-ng : build $(OBJ)
	$(CXX) $(LDFLAGS) $(OBJ) -o $@

clean :
	$(RM) -rf ./build/

build :
	mkdir ./build/

build/%.o : src/%.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
