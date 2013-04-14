--[[
   loadavg.lua
   
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
   Template options:
    * load1: The 1 minute load average
    * load5: The 5 minutes load average
    * load15: The 15 minutes load average
]]--
PLUGIN_infoCollectorsNum = 1
PLUGIN_infoCollector0_interval = 10
PLUGIN_infoCollector0_important = true

if PLUGINCONF_template then
	tpl = PLUGINCONF_template
else
	tpl = "return load1 .. ' ' .. load5 .. ' ' .. load15"
end

data = ""

function getContent()
	return data
end
function infoCollector0()
	-- open loadavg file:
	f = io.open("/proc/loadavg", "r")
	-- read:
	line = f.read(f)
	-- split data:
	a = string.find(line, " ")
	line = string.gsub(line, " ", "", 1)
	acount = 0
	start = 1
	array = {}
	while a do
		array[acount] = string.sub(line, start, a-1)
		start = a
		a = string.find(line, " ")
		line = string.gsub(line, " ", "", 1)
		acount = acount+1
	end
	load1 = tonumber(array[0])
	load5 = tonumber(array[1])
	load15 = tonumber(array[2])
	f_ = loadstring(tpl)
	data = f_()
	-- close file:
	f.close(f)
	-- return success:
	return true
end
