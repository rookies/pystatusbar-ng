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
CC=gcc
MKDIR=mkdir
PKGCONFIG=pkg-config
CP=cp

OBJ=build/main.o build/plugin.o build/statusbar.o
HEADERS=src/main.hpp src/plugin.hpp src/statusbar.hpp include/SimpleIni.h include/ConvertUTF.h
LIBS=lua5.1
LIBS_LUAMODS=lua5.1
LUAMODS=luamods/subprocess.so luamods/struct.so luamods/md5.lua luamods/md5/core.so
LM_SUBPROCESS=src/luamods/subprocess/liolib-copy.c src/luamods/subprocess/subprocess.c
LM_STRUCT=src/luamods/struct/struct.c
LM_MD5_CORE=src/luamods/md5/md5.c src/luamods/md5/md5lib.c
CXXFLAGS=-I include -c -Wall `$(PKGCONFIG) --cflags $(LIBS)`
LDFLAGS=-lpthread `pkg-config --libs $(LIBS)`
LUAMOD_FLAGS=`$(PKGCONFIG) --cflags --libs $(LIBS_LUAMODS)` -fPIC -shared -O2

all : pystatusbar-ng mods

pystatusbar-ng : build $(OBJ)
	$(CXX) $(LDFLAGS) $(OBJ) -o $@

clean :
	$(RM) -rf ./build/
	$(RM) -rf ./luamods/
	$(RM) -f ./pystatusbar-ng

build :
	$(MKDIR) ./build/

build/%.o : src/%.cpp $(HEADERS)
	$(CXX) $(CXXFLAGS) $< -o $@

mods : luamods $(LUAMODS)

luamods : 
	$(MKDIR) ./luamods/

luamods/subprocess.so : $(LM_SUBPROCESS)
	$(CC) -DOS_POSIX -o $@ $(LUAMOD_FLAGS) $(LM_SUBPROCESS)

luamods/struct.so : $(LM_STRUCT)
	$(CC) -D_POSIX_SOURCE -DSTRUCT_INT="long long" -o $@ $(LUAMOD_FLAGS) $(LM_STRUCT)

luamods/md5 : 
	$(MKDIR) $@

luamods/md5.lua : src/luamods/md5/md5.lua
	$(CP) $< $@

luamods/md5/core.so : luamods/md5 $(LM_MD5_CORE)
	$(CC) -o $@ $(LUAMOD_FLAGS) $(LM_MD5_CORE)
