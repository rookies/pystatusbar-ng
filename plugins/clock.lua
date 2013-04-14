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
    * dateformat: Format of the date output (goes to os.date() of lua)
        Default: %d.%m.%Y, %H:%M:%S
    * day_monday: Translation of 'Monday'
        Default: Monday
    * day_tuesday: Translation of 'Tuesday'
        Default: Tuesday
    * day_wednesday: Translation of 'Wednesday'
        Default: Wednesday
    * day_thursday: Translation of 'Thursday'
        Default: Thursday
    * day_friday: Translation of 'Friday'
        Default: Friday
    * day_saturday: Translation of 'Saturday'
        Default: Saturday
    * day_sunday: Translation of 'Sunday'
        Default: Sunday
   Template variables:
    * now: Formatted date string
    * day: Translated day
]]--
PLUGIN_infoCollectorsNum = 0

if PLUGINCONF_template then
	tpl = PLUGINCONF_template
else
	tpl = "return now .. ' (' .. day .. ')'"
end

function getContent()
	if PLUGINCONF_dateformat then
		x = os.date(PLUGINCONF_dateformat)
	else
		x = os.date("%d.%m.%Y, %H:%M:%S")
	end
	y = tonumber(os.date("%w"))
	if y == 1 then
		if PLUGINCONF_day_monday then
			d = PLUGINCONF_day_monday
		else
			d = "Monday"
		end
	elseif y == 2 then
		if PLUGINCONF_day_tuesday then
			d = PLUGINCONF_day_tuesday
		else
			d = "Tuesday"
		end
	elseif y == 3 then
		if PLUGINCONF_day_wednesday then
			d = PLUGINCONF_day_wednesday
		else
			d = "Wednesday"
		end
	elseif y == 4 then
		if PLUGINCONF_day_thursday then
			d = PLUGINCONF_day_thursday
		else
			d = "Thursday"
		end
	elseif y == 5 then
		if PLUGINCONF_day_friday then
			d = PLUGINCONF_day_friday
		else
			d = "Friday"
		end
	elseif y == 6 then
		if PLUGINCONF_day_saturday then
			d = PLUGINCONF_day_saturday
		else
			d = "Saturday"
		end
	elseif y == 0 then
		if PLUGINCONF_day_sunday then
			d = PLUGINCONF_day_sunday
		else
			d = "Sunday"
		end
	end
	now = x
	day = d
	f = loadstring(tpl)
	return f()
end
