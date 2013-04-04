/*
 * plugin.hpp
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
#ifndef PLUGIN_HPP
#	define PLUGIN_HPP

#	include <iostream>
#	include <lua.hpp>
#	include <assert.h>
#	include <sstream>
#	include <time.h>
	
	class PluginInfoCollector
	{
		public:
			PluginInfoCollector();
			
			time_t last_exec_finished;
			bool running;
			time_t interval;
			bool important;
	};

	class PluginConfigPair
	{
		public:
			std::string key;
			std::string value;
	};
	
	class Plugin
	{
		public:
			Plugin();
			virtual ~Plugin();

			bool init(std::string name, std::string file, PluginConfigPair *conf);
			bool is_active(void);
			bool print_content(void);
			void uninit(void);
			std::string get_name(void);
			unsigned int get_infocollectors_num(void);
			PluginInfoCollector get_infocollector(int index);
			int get_infocollector_to_exec(void);
			void set_infocollector_running(int id, bool running);
			int exec_infocollector(int id);
			bool important_infocollectors_executed(void);
		private:
			bool m_active;
			std::string m_name;
			std::string m_file;
			lua_State *m_lua;
			int m_infocollectors_num;
			PluginInfoCollector *m_infocollectors;
	};
#endif // PLUGIN_HPP
