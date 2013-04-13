--[[
   clock.lua
   
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

function getContent()
	return "abc"
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
		return false
	end
	-- Read from process stdout:
	i = 0
	while true do
		l = p.stdout:read()
		if not l then
			break
		end
		if i == 0 then
			-- ESSID line
		elseif i == 5 then
			-- Link Quality line
		end
		i = i+1
	end
	-- Return success:
	return true
end
