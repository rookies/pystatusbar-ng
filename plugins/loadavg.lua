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
]]--
PLUGIN_infoCollectorsNum = 1
PLUGIN_infoCollector0_interval = 10
PLUGIN_infoCollector0_important = true

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
	data = array[0] .. " " .. array[1] .. " " .. array[2]
	-- close file:
	f.close(f)
	-- return success:
	return true
end
