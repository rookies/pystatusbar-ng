--[[
   countdown.lua
   
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
PLUGIN_infoCollectorsNum = 0

-- Get goal as UNIX timestamp:
if PLUGINCONF_goal then
	goal = tonumber(PLUGINCONF_goal)
else
	goal = 32901067722 -- in thousand years
end

function getContent()
	-- Calculate the remaining time in seconds:
	t = goal-os.time()
	if t < 0 then
		t = 0
	end
	-- Format:
	if t < 60 then
		return t .. "s"
	elseif t < 3600 then
		m = math.floor(t/60)
		t = t-(m*60)
		return m .. "m " .. t .. "s"
	elseif t < 86400 then
		m = math.floor(t/60)
		t = t-(m*60)
		h = math.floor(m/60)
		m = m-(h*60)
		return h .. "h " .. m .. "m " .. t .. "s"
	else
		m = math.floor(t/60)
		t = t-(m*60)
		h = math.floor(m/60)
		m = m-(h*60)
		d = math.floor(h/24)
		h = h-(d*24)
		return d .. "d " .. h .. "h " .. m .. "m " .. t .. "s"
	end
end
