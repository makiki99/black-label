start = {}

function start.init()
	if love.filesystem.exists("keys.txt") then
		userconf.load()
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
