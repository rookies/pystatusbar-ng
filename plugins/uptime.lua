--[[
   uptime.lua
   
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

function formatTwoDigits(number)
	if number < 10 then
		return "0" .. tostring(number)
	else
		return tostring(number)
	end
end

function getContent()
	-- Open uptime file:
	f = io.open("/proc/uptime", "r")
	l = f:read()
	f:close()
	-- Get the first value:
	val = math.floor(tonumber(l:sub(0, l:find(' ')-1)))
	-- Format it:
	if val < 60 then
		return formatTwoDigits(val)
	elseif val < 3600 then
		m = math.floor(val/60)
		val = val-(m*60)
		return formatTwoDigits(m) .. ":" .. formatTwoDigits(val)
	elseif val < 86400 then
		m = math.floor(val/60)
		val = val-(m*60)
		h = math.floor(m/60)
		m = m-(h*60)
		return formatTwoDigits(h) .. ":" .. formatTwoDigits(m) .. ":" .. formatTwoDigits(val)
	else
		m = math.floor(val/60)
		val = val-(m*60)
		h = math.floor(m/60)
		m = m-(h*60)
		d = math.floor(h/24)
		h = h-(d*24)
		return d .. "d " .. formatTwoDigits(h) .. ":" .. formatTwoDigits(m) .. ":" .. formatTwoDigits(val)
	end
end
