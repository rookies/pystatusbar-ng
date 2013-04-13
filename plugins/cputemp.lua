--[[
   cputemp.lua
   
   Copyright 2013 Robert Knauer <robert@privatdemail.net>
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
   This is a plugin for pystatusbar-ng.
   Configuration options:
    * file_sysfs: path to the temp-file in sysfs containing the CPU temp
                  in millidegrees Celsius
        Default: /sys/class/thermal/thermal_zone0/temp
    * fahrenheit: 1 if you want the temperature in degrees Fahrenheit
                  0 if you want the temperature in degrees Celsius
        Default: 0
]]--
PLUGIN_infoCollectorsNum = 1
PLUGIN_infoCollector0_interval = 10
PLUGIN_infoCollector0_important = true

data = ""

function getContent()
	return data
end
function infoCollector0()
	-- open temperature file:
	if PLUGINCONF_file_sysfs then
		f = io.open(PLUGINCONF_file_sysfs, "r")
	else
		f = io.open("/sys/class/thermal/thermal_zone0/temp", "r")
	end
	-- read:
	line = f:read()
	-- calculate temperature:
	t_c = line/1000
	t_f = (t_c*1.8)+32
	-- set data:
	if PLUGINCONF_fahrenheit and PLUGINCONF_fahrenheit == "1" then
		data = t_f .. "°F"
	else
		data = t_c .. "°C"
	end
	-- close file:
	f:close()
	-- return success:
	return true
end
