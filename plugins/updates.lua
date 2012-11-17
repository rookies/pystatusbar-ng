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
