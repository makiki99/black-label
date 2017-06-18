start = {}

function start.init()
	if love.filesystem.exists("keys.txt") then
		userconf.load()
		set_gamestate("menu")
	else
		set_gamestate("keyconfig")
	end
end

return start
