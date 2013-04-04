PLUGIN_infoCollectorsNum = 1
PLUGIN_infoCollector0_interval = 10
PLUGIN_infoCollector0_important = true

data = ""

function getContent()
	return data .. "°C"
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
	data = line/1000
	-- close file:
	f.close(f)
	-- return success:
	return true
end
