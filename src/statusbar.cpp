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
	m_stderr_locked = false;
}
StatusBar::~StatusBar()
{

}
bool StatusBar::init(std::string confpath)
{
	/*
	 * Variable declarations:
	*/
	unsigned int i;
	int ret;
	std::string tmp, tmp2;
	SI_Error err;
	size_t pos, lpos;
	/*
	 * Load INI file:
	*/
	m_ini.SetUnicode();
	err = m_ini.LoadFile(confpath.c_str());
	if (err < 0)
	{
		std::cerr << "Failed to load config file, exiting." << std::endl;
		return false;
	};
	/*
	 * Get the number of threads to start:
	*/
	m_threads = atoi(m_ini.GetValue("general", "threads", "5"));
	/*
	 * Try to get the plugin list:
	*/
	tmp = m_ini.GetValue("general", "plugins", "");
	if (tmp.length() == 0)
	{
		std::cerr << "Empty plugin list, exiting." << std::endl;
		return false;
	}
	else if (tmp.find(" ") == std::string::npos)
	{
		/*
		 * Single plugin
		*/
		m_plugins = new Plugin[1];
		m_plugins_c = 1;
		m_init_plugin(0, tmp);
	}
	else
	{
		/*
		 * Plugin list, split the string:
		*/
		pos = 0;
		m_plugins_c = 0;
		do {
			if (pos >= tmp.length())
				break;
			lpos = ((pos == 0)?(pos):(pos+1));
			pos = tmp.find_first_of(" ", pos+1);
			/*
			 * And count them:
			*/
			m_plugins_c++;
		}
		while (pos != std::string::npos);
		/*
		 * Init the plugin array:
		*/
		m_plugins = new Plugin[m_plugins_c];
		/*
		 * And again, this time init them:
		*/
		pos = 0;
		i = 0;
		do {
			if (pos >= tmp.length())
				break;
			lpos = ((pos == 0)?(pos):(pos+1));
			pos = tmp.find_first_of(" ", pos+1);
			if (pos != std::string::npos)
			{
				m_init_plugin(i, tmp.substr(lpos, pos-lpos));
			}
			else
			{
				m_init_plugin(i, tmp.substr(lpos));
			};
			i++;
		}
		while (pos != std::string::npos);
	};
	/*
	 * Start threads:
	*/
	m_infoCollectionThreads = new pthread_t[m_threads];
	m_infoCollectionThreadJobsMajor = new int[m_threads];
	m_infoCollectionThreadJobsMinor = new int[m_threads];
	m_infoCollectionThreadInitCounter = 0;
	for (i=0; i < m_threads; i++)
	{
		m_infoCollectionThreadJobsMajor[i] = -1;
		m_infoCollectionThreadJobsMinor[i] = -1;
		ret = pthread_create(&m_infoCollectionThreads[i], NULL, m_infoCollectionThread_, this);
		assert(0 == ret);
		while(m_infoCollectionThreadInitCounter == i);
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
	delete[] m_infoCollectionThreadJobsMajor;
	delete[] m_infoCollectionThreadJobsMinor;
}
void StatusBar::loop(void)
{
	/*
	 * Variable declarations:
	*/
	unsigned int i, j, k;
	int id;
	bool done;
	/*
	 * Loop:
	*/
	while (true)
	{
		/*
		 * Check for first exec of important info collectors:
		*/
		done = true;
		for (i=0; i < m_plugins_c; i++)
		{
			if (!m_plugins[i].important_infocollectors_executed() && m_plugins[i].is_active())
				done = false;
		}
		for (i=0; i < m_plugins_c; i++)
		{
			if (m_plugins[i].is_active())
			{
				/*
				 * Print content:
				*/
				if (done)
				{
					if (i > 0)
						std::cout << "^fg(#333333)^p(5;-2)^ro(2)^p()^fg()^p(5)";
					std::cout << "^fg(#FFFFFF)";
					if (!m_plugins[i].print_content())
					{
						std::cerr << "ERROR: " << m_plugins[i].get_name() << " -> getContent() failed." << std::endl;
						m_plugins[i].uninit();
					};
				};
				/*
				 * Exec info collection functions:
				*/
				k = 0;
				do
				{
					if (!m_plugins[i].is_active())
						break;
					id = m_plugins[i].get_infocollector_to_exec();
					if (id > -1)
					{
						/*
						 * We've got an info collector that needs to get executed.
						 * So search for a thread that has nothing to do:
						*/
						for (j=0; j < m_threads; j++)
						{
							if (m_infoCollectionThreadJobsMajor[j] < 0 && m_infoCollectionThreadJobsMinor[j] < 0)
							{
								m_infoCollectionThreadJobsMajor[j] = i;
								m_infoCollectionThreadJobsMinor[j] = id;
								m_plugins[i].set_infocollector_running(id, true);
								//std::cerr << "Allocated infoCollector " << m_plugins[i].get_name() << "#" << id << " to thread #" << j << "." << std::endl;
								break;
							};
						}
					};
					k++;
				}
				while (id > -1 && k < 5);
			};
		}
		if (done)
		{
			std::cout << std::endl;
			sleep(1);
		}
		else
			usleep(100 * 1000);
	}
}
void StatusBar::m_init_plugin(unsigned int index, std::string name)
{
	/*
	 * Variable declarations:
	*/
	std::string tmp, tmp3;
	std::stringstream tmp2;
	unsigned int i;
	CSimpleIniA::TNamesDepend keys;
	CSimpleIniA::TNamesDepend::const_iterator j;
	PluginConfigPair *conf;
	/*
	 * Get plugin file path:
	*/
	tmp = m_ini.GetValue("general", "plugindir", "plugins");
	if (tmp.substr(tmp.length()-1).compare("/") != 0)
		tmp.append("/");
	tmp.append(name);
	tmp.append(".lua");
	/*
	 * Construct the config section name:
	*/
	tmp2.str("");
	tmp2 << "plugin" << index;
	tmp3 = tmp2.str();
	/*
	 * Get the plugin configuration:
	*/
	m_ini.GetAllKeys(tmp3.c_str(), keys);
	conf = new PluginConfigPair[keys.size()+1];
	i = 0;
	for (j = keys.begin(); j != keys.end(); j++)
	{
		conf[i].key = j->pItem;
		conf[i].value = m_ini.GetValue(tmp3.c_str(), j->pItem, "");
		i++;
	}
	conf[i].key = "";
	conf[i].value = "";
	/*
	 * Try to call the init() method:
	*/
	if (m_plugins[index].init(name, tmp, conf, m_ini.GetValue("general", "moduledir", "luamods")))
	{
		/*
		 * Successfull, print information:
		*/
		std::cerr << "  [" << name << "] (" << tmp << ") done." << std::endl;
		for (i=0; i < m_plugins[index].get_infocollectors_num(); i++)
		{
			std::cerr << "    (" << i <<") Interval:  " << m_plugins[index].get_infocollector(i).interval << std::endl;
			if (m_plugins[index].get_infocollector(i).important)
				std::cerr << "    (" << i <<") Important: true" << std::endl;
			else
				std::cerr << "    (" << i <<") Important: false" << std::endl;
		}
	}
	else
	{
		/*
		 * Failed, print error:
		*/
		std::cerr << "  [" << name << "] (" << tmp << ") FAILed." << std::endl;
	};
	/*
	 * Remove the plugin config from heap:
	*/
	delete[] conf;
}
void *StatusBar::m_infoCollectionThread_(void *ctx)
{
	return ((StatusBar *)ctx)->m_infoCollectionThread();
}
void *StatusBar::m_infoCollectionThread()
{
	/*
	 * Variable declarations:
	*/
	int _id;
	/*
	 * Init:
	*/
	_id = m_infoCollectionThreadInitCounter;
	std::cerr << "Thread #" << _id << " inited." << std::endl;
	m_infoCollectionThreadInitCounter++;
	/*
	 * Loop:
	*/
	while (true)
	{
		if (m_infoCollectionThreadJobsMajor[_id] > -1 && m_infoCollectionThreadJobsMinor[_id] > -1)
		{
			switch (m_plugins[m_infoCollectionThreadJobsMajor[_id]].exec_infocollector(m_infoCollectionThreadJobsMinor[_id]))
			{
				case 0:
					/*
					 * Success
					*/
					while(m_stderr_locked);
					m_stderr_locked = true;
					std::cerr << m_plugins[m_infoCollectionThreadJobsMajor[_id]].get_name() << " -> infoCollector" << m_infoCollectionThreadJobsMinor[_id] << "() done by Thread #" << _id << "." << std::endl;
					m_stderr_locked = false;
					m_infoCollectionThreadJobsMajor[_id] = -1;
					m_infoCollectionThreadJobsMinor[_id] = -1;
					break;
				case 2:
					/*
					 * m_active was false
					*/
					break;
				default:
					while(m_stderr_locked);
					m_stderr_locked = true;
					std::cerr << "ERROR: " << m_plugins[m_infoCollectionThreadJobsMajor[_id]].get_name() << " -> infoCollector" << m_infoCollectionThreadJobsMinor[_id] << "() failed." << std::endl;
					m_stderr_locked = false;
					m_plugins[m_infoCollectionThreadJobsMajor[_id]].uninit();
			}
		}
		else
			usleep(200*1000);
	}
	return 0;
}
