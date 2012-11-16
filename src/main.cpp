/*
 * main.cpp
 * 
 * Copyright 2012 Robert Knauer <robert@privatdemail.net>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 * 
 * g++ -o pystatusbar-ng `pkg-config --cflags --libs lua` -lpthread src/*.cpp
 */
#include "main.hpp"


int main (int argc, char **argv)
{
	/*
	 * Variable declarations:
	*/
	StatusBar bar;
	/*
	 * Init:
	*/
	std::cout << "Loading ..." << std::endl;
	if (!bar.init())
		return 1;
	/*
	 * Start main loop:
	*/
	bar.loop();
	/*
	 * Uninit:
	*/
	bar.uninit();
	return 0;
}
/*int main (int argc, char **argv)
{
	lua_State *lua = luaL_newstate();
	luaL_openlibs(lua);
	if (luaL_loadfile(lua, "test1.lua") == 0)
	{
		if (lua_pcall(lua, 0, LUA_MULTRET, 0) == 0)
		{
			lua_getglobal(lua, "ggT");
			lua_pushnumber(lua, 5);
			lua_pushnumber(lua, 10);
			if (lua_pcall(lua, 2, 1, 0) == 0)
			{
				std::cout << lua_tointeger(lua, -1) << std::endl;
				lua_getglobal(lua, "func2");
				if (lua_pcall(lua, 0, 0, 0) == 0)
				{
					
				}
				else
					std::cerr << lua_tostring(lua, -1) << std::endl;
			}
			else
				std::cerr << lua_tostring(lua, -1) << std::endl;
		}
		else
			std::cerr << lua_tostring(lua, -1) << std::endl;
	}
	else
		std::cerr << lua_tostring(lua, -1) << std::endl;
	lua_close(lua);
	return 0;
}*/
