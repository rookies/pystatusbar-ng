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
   Configuration options:
    * goal: The goal of the countdown as UNIX timestamp
        Default: far, far away
]]--
PLUGIN_infoCollectorsNum = 0

-- Get goal as UNIX timestamp:
if PLUGINCONF_goal then
	goal = tonumber(PLUGINCONF_goal)
else
	goal = 32901067722 -- in thousand years
end

function formatTwoDigits(number)
	if number < 10 then
		return "0" .. tostring(number)
	else
		return tostring(number)
	end
end

function getContent()
	-- Calculate the remaining time in seconds:
	t = goal-os.time()
	if t < 0 then
		t = 0
	end
	-- Format:
	if t < 60 then
		return formatTwoDigits(t) .. "s"
	elseif t < 3600 then
		m = math.floor(t/60)
		t = t-(m*60)
		return formatTwoDigits(m) .. "m " .. formatTwoDigits(t) .. "s"
	elseif t < 86400 then
		m = math.floor(t/60)
		t = t-(m*60)
		h = math.floor(m/60)
		m = m-(h*60)
		return formatTwoDigits(h) .. "h " .. formatTwoDigits(m) .. "m " .. formatTwoDigits(t) .. "s"
	else
		m = math.floor(t/60)
		t = t-(m*60)
		h = math.floor(m/60)
		m = m-(h*60)
		d = math.floor(h/24)
		h = h-(d*24)
		return d .. "d " .. formatTwoDigits(h) .. "h " .. formatTwoDigits(m) .. "m " .. formatTwoDigits(t) .. "s"
	end
end
