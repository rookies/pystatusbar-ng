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

PluginInfoCollector::PluginInfoCollector()
{
	last_exec_finished = 0;
	running = false;
}
Plugin::Plugin()
{
	m_active = false;
}
Plugin::~Plugin()
{
	
}
bool Plugin::init(std::string name, std::string file, PluginConfigPair *conf)
{
	m_active = false;
	/*
	 * Variable declarations:
	*/
	int i, tmp;
	std::stringstream ss;
	std::string tmp2, tmp3;
	/*
	 * Init lua:
	*/
	m_lua = luaL_newstate();
	luaL_openlibs(m_lua);
	/*
	 * Get LUA_CPATH:
	*/
	lua_getglobal(m_lua, "package");
	lua_getfield(m_lua, -1, "cpath");
	tmp2 = lua_tostring(m_lua, -1);
	/*
	 * Append our module directory to the path:
	*/
	tmp3 = "./luamods/?.so";
	if (tmp2.length() > 0)
	{
		tmp3.append(";");
		tmp3.append(tmp2);
	};
	/*
	 * And push the new LUA_CPATH:
	*/
	lua_pop(m_lua, 1);
	lua_pushstring(m_lua, tmp3.c_str());
	lua_setfield(m_lua, -2, "cpath");
	lua_pop(m_lua, 1);
	/*
	 * Get LUA_PATH:
	*/
	lua_getglobal(m_lua, "package");
	lua_getfield(m_lua, -1, "path");
	tmp2 = lua_tostring(m_lua, -1);
	/*
	 * Append our module directory to the path:
	*/
	tmp3 = "./luamods/?.lua";
	if (tmp2.length() > 0)
	{
		tmp3.append(";");
		tmp3.append(tmp2);
	};
	/*
	 * And push the new LUA_PATH:
	*/
	lua_pop(m_lua, 1);
	lua_pushstring(m_lua, tmp3.c_str());
	lua_setfield(m_lua, -2, "path");
	lua_pop(m_lua, 1);
	/*
	 * Push the plugin configuration to the lua stack:
	*/
	for (i=0; conf[i].key != ""; i++)
	{
		ss.str("");
		ss << "PLUGINCONF_" << conf[i].key;
		lua_pushstring(m_lua, conf[i].value.c_str());
		lua_setglobal(m_lua, ss.str().c_str());
	}
	/*
	 * Load the plugin file:
	*/
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
	/*
	 * Init info collectors:
	*/
	lua_getglobal(m_lua, "PLUGIN_infoCollectorsNum");
	m_infocollectors_num = lua_tointeger(m_lua, -1);
	m_infocollectors = new PluginInfoCollector[m_infocollectors_num];
	for (i=0; i < m_infocollectors_num; i++)
	{
		ss.str("");
		ss << "PLUGIN_infoCollector";
		ss << i;
		ss << "_interval";
		lua_getglobal(m_lua, ss.str().c_str());
		tmp = lua_tointeger(m_lua, -1);
		if (tmp > 0)
			m_infocollectors[i].interval = tmp;
		else
		{
			std::cerr << "Invalid value for " << ss.str() << "." << std::endl;
			return false;
		};
		ss.str("");
		ss << "PLUGIN_infoCollector";
		ss << i;
		ss << "_important";
		lua_getglobal(m_lua, ss.str().c_str());
		m_infocollectors[i].important = lua_toboolean(m_lua, -1);
	}
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
	delete[] m_infocollectors;
	m_active = false;
}
std::string Plugin::get_name(void)
{
	assert(true == m_active);
	return m_name;
}
unsigned int Plugin::get_infocollectors_num(void)
{
	assert(true == m_active);
	return m_infocollectors_num;
}
PluginInfoCollector Plugin::get_infocollector(int index)
{
	assert(true == m_active);
	assert(index <= m_infocollectors_num);
	return m_infocollectors[index];
}
int Plugin::get_infocollector_to_exec(void)
{
	assert(true == m_active);
	/*
	 * Variable declarations:
	*/
	int i;
	/*
	 * Loop:
	*/
	for (i=0; i < m_infocollectors_num; i++)
	{
		if (m_infocollectors[i].last_exec_finished == 0 || time(NULL)-m_infocollectors[i].interval > m_infocollectors[i].last_exec_finished)
			if (!m_infocollectors[i].running)
				return i;
	}
	return -1;
}
void Plugin::set_infocollector_running(int id, bool running)
{
	assert(true == m_active);
	m_infocollectors[id].running = running;
}
int Plugin::exec_infocollector(int id)
{
	if (!m_active)
		return 2;
	if (id > m_infocollectors_num-1)
		return 1;
	/*
	 * Variable declarations:
	*/
	std::stringstream ss;
	/*
	 * Call lua function:
	*/
	ss.str("");
	ss << "infoCollector";
	ss << id;
	lua_getglobal(m_lua, ss.str().c_str());
	if (lua_pcall(m_lua, 0, 1, 0) != 0)
	{
		std::cerr << lua_tostring(m_lua, -1) << std::endl;
		return 1;
	};
	/*
	 * Set last_exec_finished & running:
	*/
	m_infocollectors[id].last_exec_finished = time(NULL);
	m_infocollectors[id].running = false;
	/*
	 * Return:
	*/
	if (lua_toboolean(m_lua, -1))
		return 0;
	else
		return 1;
}
bool Plugin::important_infocollectors_executed(void)
{
	/*
	 * Variable declarations:
	*/
	int i;
	/*
	 * Loop:
	*/
	for (i=0; i < m_infocollectors_num; i++)
	{
		if (true == m_infocollectors[i].important && 0 == m_infocollectors[i].last_exec_finished)
			return false;
	}
	return true;
}
