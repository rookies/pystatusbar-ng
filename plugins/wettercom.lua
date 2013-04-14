--[[
   wettercom.lua
   
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
    * project: the wetter.com API project name
        Default: <empty>
    * apikey: the wetter.com API-key
        Default: <empty>
    * citycode: the wetter.com City Code
	    Default: DE0001020074
	* fahrenheit: 1 if you want the temperature in degrees Fahrenheit
                  0 if you want the temperature in degrees Celsius
        Default: 0
]]--
PLUGIN_infoCollectorsNum = 1
PLUGIN_infoCollector0_interval = 300
PLUGIN_infoCollector0_important = true

require "md5"
http = require "socket.http"
require "LuaXml"

if PLUGINCONF_project then
	project = PLUGINCONF_project
else
	project = ""
end
if PLUGINCONF_apikey then
	apikey = PLUGINCONF_apikey
else
	apikey = ""
end
if PLUGINCONF_citycode then
	citycode = PLUGINCONF_citycode
else
	citycode = "DE0001020074"
end
-- Create md5 hash:
hash = md5.sumhexa(project .. apikey .. citycode)
-- Concat the URL components:
url = "http://api.wetter.com/forecast/weather/city/" .. citycode .. "/project/" .. project .. "/cs/" .. hash

data = ""

function getContent()
	return data
end
function infoCollector0()
	-- Send request:
	content, status, headers = http.request(url)
	-- Check response code:
	if not status == 200 then
		data = "Error " .. status
	else
		data = "OK"
	end
	-- Parse XML response:
	content = xml.eval(content)
	today = content:find("city"):find("forecast"):find("date")
	-- Get nearest forecast:
	now = os.date("*t")
	t = (now["hour"]*3600)+(now["min"]*60)
	times = {
		21600,	-- 06:00
		39600,	-- 11:00
		61200,	-- 17:00
		82800	-- 23:00
	}
	neart = times[1]
	for k, v in pairs(times) do
		if math.abs(neart-t) > math.abs(v-t) then
			neart = v
		end
	end
	-- Get the corresponding element argument:
	if neart == 21600 then arg = "06:00"
	elseif neart == 39600 then arg = "11:00"
	elseif neart == 61200 then arg = "17:00"
	else arg = "23:00" end
	-- Get the element:
	now = today:find("time", "value", arg)
	-- Get the temperature:
	tmin = tonumber(now:find("tn")[1])
	tmax = tonumber(now:find("tx")[1])
	temp = (tmin+tmax)/2
	-- Get the city name:
	city = content:find("name")[1]
	-- Concat all together:
	if PLUGINCONF_fahrenheit and PLUGINCONF_fahrenheit == "1" then
		data = city .. ": " .. ((temp*1.8)+32) .. "°F"
	else
		data = city .. ": " .. temp .. "°C"
	end
	-- Return success:
	return true
end
