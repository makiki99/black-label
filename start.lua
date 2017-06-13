start = {}

function start.init()
	if love.filesystem.exists("keys.txt") then
		userconf.keys = bitser.loadLoveFile("keys.txt")
		set_gamestate("menu")
	else
		set_gamestate("keyconfig")
	end
end

function start.update()
end

function start.draw()
end

return start
