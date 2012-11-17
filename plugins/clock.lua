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
