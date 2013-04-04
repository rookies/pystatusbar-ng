--[[
   updates.lua
   
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
PLUGIN_infoCollector0_interval = 60
PLUGIN_infoCollector0_important = true

upd = 0
t = 0

function getContent()
	x = os.time()-t
	if x < 60 then
		t_ = x
	elseif x < 3600 then
		minutes = math.floor(x/60)
		t_ = string.format("%0.2d:%0.2d", minutes, (x-minutes*60))
	elseif x < 86400 then
		hours = math.floor(x/3600)
		minutes = math.floor((x-hours*3600)/60)
		t_ = string.format("%d:%0.2d:%0.2d", hours, minutes, (x-hours*3600-minutes*60))
	else
		days = math.floor(x/86400)
		hours = math.floor((x-days*86400)/3600)
		minutes = math.floor((x-days*86400-hours*3600)/60)
		t_ = string.format("%dd %d:%0.2d:%0.2d", days, hours, minutes, (x-days*86400-hours*3600-minutes*60))
	end
	return upd .. " (" .. t_ .. ")"
end
function infoCollector0()
	-- open updatecheck file:
	f = io.open("/var/log/updatecheck", "r")
	-- read:
	line = f.read(f)
	-- split data:
	upd = string.sub(line, 0, string.find(line, "-")-1)
	t = string.sub(line, string.find(line, "-")+1)
	-- close file:
	f.close(f)
	-- return success:
	return true
end
