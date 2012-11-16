/*
 * plugin.cpp
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
 * 
 */
#include "plugin.hpp"

Plugin::Plugin()
{
	m_active = false;
}
Plugin::~Plugin()
{

}
bool Plugin::init(std::string name, std::string file)
{
	/*
	 * Init lua:
	*/
	m_lua = luaL_newstate();
	luaL_openlibs(m_lua);
	if (luaL_loadfile(m_lua, file.c_str()) != 0)
	{
		std::cerr << lua_tostring(m_lua, -1) << std::endl;
		return false;
	};
	if (lua_pcall(m_lua, 0, LUA_MULTRET, 0) != 0)
	{
		std::cerr << lua_tostring(m_lua, -1) << std::endl;
		return false;
	};
	lua_getglobal(m_lua, "PLUGIN_infoCollectorsNum");
	m_infocollectors_num = lua_tointeger(m_lua, -1);
	/*
	 * Set variables:
	*/
	m_name = name;
	m_file = file;
	/*
	 * Return:
	*/
	m_active = true;
	return true;
}
bool Plugin::is_active(void)
{
	return m_active;
}
bool Plugin::print_content(void)
{
	assert(true == m_active);
	/*
	 * Call lua function:
	*/
	lua_getglobal(m_lua, "getContent");
	if (lua_pcall(m_lua, 0, 1, 0) != 0)
	{
		std::cerr << lua_tostring(m_lua, -1) << std::endl;
		return false;
	};
	std::cout << lua_tostring(m_lua, -1);
	/*
	 * Return:
	*/
	return true;
}
void Plugin::uninit(void)
{
	assert(true == m_active);
	m_active = false;
}
std::string Plugin::get_name(void)
{
	assert(true == m_active);
	return m_name;
}
int Plugin::get_infocollectors_num(void)
{
	assert(true == m_active);
	return m_infocollectors_num;
}
