PLUGIN_infoCollectorsNum = 1
PLUGIN_infoCollector0_interval = 10
PLUGIN_infoCollector0_important = true

data = ""

function getContent()
	return data
end
function infoCollector0()
	-- open temperature file:
	if PLUGINCONF_file_sysfs then
		f = io.open(PLUGINCONF_file_sysfs, "r")
	else
		f = io.open("/sys/class/thermal/thermal_zone0/temp", "r")
	end
	-- read:
	line = f.read(f)
	-- calculate temperature:
	t_c = line/1000
	t_f = (t_c*1.8)+32
	-- set data:
	if PLUGINCONF_fahrenheit and PLUGINCONF_fahrenheit == "1" then
		data = t_f .. "°F"
	else
		data = t_c .. "°C"
	end
	-- close file:
	f.close(f)
	-- return success:
	return true
end
