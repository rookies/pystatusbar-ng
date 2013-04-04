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
]]--
PLUGIN_infoCollectorsNum = 0

function getContent()
	x = os.date("%d.%m.%Y, %H:%M:%S")
	y = os.date("%w")
	if y == "1" then
		d = "Montag"
	elseif y == "2" then
		d = "Dienstag"
	elseif y == "3" then
		d = "Mittwoch"
	elseif y == "4" then
		d = "Donnerstag"
	elseif y == "5" then
		d = "Freitag"
	elseif y == "6" then
		d = "Samstag"
	elseif y == "0" then
		d = "Sonntag"
	end
	return x .. " (" .. d .. ")"
end
