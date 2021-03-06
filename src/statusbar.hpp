/*
 * statusbar.hpp
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
#ifndef STATUSBAR_HPP
#	define STATUSBAR_HPP
#	include <iostream>
#	include <pthread.h>
#	include <assert.h>
#	include <libgen.h>
#	include <unistd.h>
#	include <sstream>
#	include <SimpleIni.h>
#	include "plugin.hpp"

	class StatusBar
	{
		public:
			StatusBar();
			virtual ~StatusBar();

			bool init(std::string confpath);
			void uninit(void);
			void loop(void);
		private:
			void m_init_plugin(unsigned int index, std::string name);
			static void *m_infoCollectionThread_(void *ctx);
			void *m_infoCollectionThread();

			unsigned int m_threads;
			unsigned int m_infoCollectionThreadInitCounter;
			pthread_t *m_infoCollectionThreads;
			int *m_infoCollectionThreadJobsMajor;
			int *m_infoCollectionThreadJobsMinor;
			bool m_inited;
			Plugin *m_plugins;
			unsigned int m_plugins_c;
			bool m_stderr_locked;
			CSimpleIniA m_ini;
	};
#endif // STATUSBAR_HPP
