--[[
   wifi.lua
   
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
    * interface: The network interface to check
        Default: wlan0
   Template options:
    * essid: The network ESSID
    * quality: The network quality in percent
]]--
PLUGIN_infoCollectorsNum = 1
PLUGIN_infoCollector0_interval = 10
PLUGIN_infoCollector0_important = true

require "subprocess"

if PLUGINCONF_interface then
	iface = PLUGINCONF_interface
else
	iface = "wlan0"
end
if PLUGINCONF_template then
	tpl = PLUGINCONF_template
else
	tpl = "return essid .. ' (' .. quality .. '%)'"
end

data = ""

function getContent()
	return data
end
function infoCollector0()
	-- Exec iwconfig:
	p = subprocess.popen({
		"iwconfig",
		iface,
		stdout=subprocess.PIPE
	})
	p:wait()
	-- Check exitcode:
	if not p.exitcode == 0 then
		data = "Error"
	end
	-- Read from process stdout:
	i = 0
	while true do
		l = p.stdout:read()
		if not l then
			break
		end
		if i == 0 then
			-- Get ESSID:
			essid = l:match('%b""'):sub(2):sub(1, -2)
		elseif i == 5 then
			-- Get Link Quality:
			q = l:match('%b= '):sub(2):sub(1, -2)
			q_full = tonumber(q:sub(q:find('/')+1, -1))
			q = tonumber(q:sub(0, q:find('/')-1))
			-- Calculate percent:
			quality = math.floor((q/q_full)*100)
		end
		i = i+1
	end
	-- Set data variable:
	f = loadstring(tpl)
	data = f()
	-- Return success:
	return true
end
