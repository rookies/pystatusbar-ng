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
	extern "C" {
#		include <lua.h>
#		include <lualib.h>
#		include <lauxlib.h>
	}
#	include <assert.h>
	
	class Plugin
	{
		public:
			Plugin();
			virtual ~Plugin();

			bool init(std::string name, std::string file);
			bool is_active(void);
			bool print_content(void);
			void uninit(void);
			std::string get_name(void);
			int get_infocollectors_num(void);
		private:
			bool m_active;
			std::string m_name;
			std::string m_file;
			lua_State *m_lua;
			int m_infocollectors_num;
	};
#endif // PLUGIN_HPP
