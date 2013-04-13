--[[
   dayuptime.lua
   
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
    * uptimelog: path to the uptimelog file written by a cronjob
        Default: /var/log/uptimestats.bin
]]--
PLUGIN_infoCollectorsNum = 1
PLUGIN_infoCollector0_interval = 60
PLUGIN_infoCollector0_important = true

require "struct"

if PLUGINCONF_uptimelog then
	uptimelog = PLUGINCONF_uptimelog
else
	uptimelog = "/var/log/uptimestats.bin"
end

data = ""

function tonumber_(val)
	if val then
		return tonumber(val)
	else
		return 0
	end
end
function formatTwoDigits(number)
	if number < 10 then
		return "0" .. tostring(number)
	else
		return tostring(number)
	end
end

function getContent()
	return data
end
function infoCollector0()
	-- Open file:
	f = io.open(uptimelog, "rb")
	-- Calculate start & end time:
	now = os.date("*t")
	starttime = os.time({
		year=now["year"],
		month=now["month"],
		day=now["day"],
		isdst=now["isdst"],
		hour=0,
		min=0,
		sec=0
	})
	endtime = os.time({
		year=now["year"],
		month=now["month"],
		day=now["day"],
		isdst=now["isdst"],
		hour=23,
		min=59,
		sec=59
	})
	-- Read from file & calculate uptime:
	uptime = 0
	while true do
		buf = f:read(8)
		if not buf then
			break
		else
			t = struct.unpack("i8", buf)
			buf = f:read(1)
			if not buf then
				break
			else
				unlocked = struct.unpack("B", buf)
				if unlocked == 1 and t >= starttime and t <= endtime then
					uptime = uptime+1
				end
			end
		end
	end
	-- Format the time:
	if uptime < 60 then
		data = "00:" .. formatTwoDigits(uptime)
	else
		h = math.floor(uptime/60)
		uptime = uptime-(h*60)
		data = formatTwoDigits(h) .. ":" .. formatTwoDigits(uptime)
	end
	-- Close file:
	f:close()
	-- Return success:
	return true
end
