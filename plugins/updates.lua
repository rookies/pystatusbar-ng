PLUGIN_infoCollectorsNum = 1
PLUGIN_infoCollector0_interval = 60
PLUGIN_infoCollector0_important = true

data = ""

function getContent()
	return data
end
function infoCollector0()
	-- open temperature file:
	f = io.open("/var/log/updatecheck", "r")
	-- read:
	line = f.read(f)
	-- split data:
	data = string.sub(line, 0, string.find(line, "-")-1) .. " (" .. string.sub(line, string.find(line, "-")+1) .. ")"
	-- close file:
	f.close(f)
	-- return success:
	return true
end
