/*
 * statusbar.cpp
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
#include "statusbar.hpp"

StatusBar::StatusBar()
{
	m_inited = false;
}
StatusBar::~StatusBar()
{

}
bool StatusBar::init(void)
{
	/*
	 * Variable declarations:
	*/
	int i, ret;
	glob_t glob_res;
	std::string tmp;
	/*
	 * TODO: Load config
	*/
	/*
	 * Load plugins:
	*/
	glob("plugins/*.lua", GLOB_TILDE, NULL, &glob_res);
	switch (glob_res.gl_pathc)
	{
		case 0:
			std::cerr << "No plugins found, exiting." << std::endl;
			return false;
			break;
		case 1:
			std::cerr << "1 plugin found, loading." << std::endl;
			break;
		default:
			std::cerr << glob_res.gl_pathc << " plugins found, loading." << std::endl;
	}
	m_plugins = new Plugin[glob_res.gl_pathc];
	m_plugins_c = glob_res.gl_pathc;
	for (i=0; i < glob_res.gl_pathc; i++)
	{
		tmp = basename(glob_res.gl_pathv[i]);
		tmp = tmp.substr(0, tmp.find_last_of("."));
		if (m_plugins[i].init(tmp, glob_res.gl_pathv[i]))
		{
			std::cerr << "  [" << tmp << "] (" << glob_res.gl_pathv[i] << ") done." << std::endl;
		}
		else
		{
			std::cerr << "  [" << tmp << "] (" << glob_res.gl_pathv[i] << ") FAILed." << std::endl;
		};
	}
	/*
	 * Start threads:
	*/
	m_infoCollectionThreads = new pthread_t[m_config.get_infoThreadCount()];
	for (i=0; i < m_config.get_infoThreadCount(); i++)
	{
		ret = pthread_create(&m_infoCollectionThreads[i], NULL, m_infoCollectionThread_, NULL);
		assert(0 == ret);
	}
	/*
	 * Return:
	*/
	m_inited = true;
	return true;
}
void StatusBar::uninit(void)
{
	if (!m_inited)
		return;
	delete[] m_plugins;
	delete[] m_infoCollectionThreads;
}
void StatusBar::loop(void)
{
	/*
	 * Variable declarations:
	*/
	int i;
	/*
	 * Loop:
	*/
	while (true)
	{
		for (i=0; i < m_plugins_c; i++)
		{
			if (m_plugins[i].is_active())
			{
				if (!m_plugins[i].print_content())
				{
					m_plugins[i].uninit();
				};
			};
		}
		std::cout << std::endl;
		sleep(1);
	};
}
void *StatusBar::m_infoCollectionThread_(void *ctx)
{
	return ((StatusBar *)ctx)->m_infoCollectionThread();
}
void *StatusBar::m_infoCollectionThread(void)
{
	while (true)
	{
		sleep(1);
	}
	return 0;
}
