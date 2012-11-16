PLUGIN_infoCollectorsNum = 1
PLUGIN_infoCollector0_interval = 10
PLUGIN_infoCollector0_important = true

data = ""

function getContent()
	return data
end
function infoCollector0()
	-- open loadavg file:
	f = io.open("/proc/loadavg", "r")
	-- read:
	line = f.read(f)
	-- split data:
	a = string.find(line, " ")
	line = string.gsub(line, " ", "", 1)
	acount = 0
	start = 1
	array = {}
	while a do
		array[acount] = string.sub(line, start, a-1)
		start = a
		a = string.find(line, " ")
		line = string.gsub(line, " ", "", 1)
		acount = acount+1
	end
	data = array[0] .. " " .. array[1] .. " " .. array[2]
	-- close file:
	f.close(f)
	-- return success:
	return true
end
