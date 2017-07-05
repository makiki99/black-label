original = {}

basicgame.add_default_events(original)
function original.init()
	basicgame.init_state()
end

function original.update()
	basicgame.movement()
end

function original.draw()
	--background
	love.graphics.setColor(0,0,0)
	--love.graphics.rectangle("fill",0,0,1366,768)
	--final screen translation
	love.graphics.translate(171,0)
	basicgame.drawboard()
	--timer
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(love.graphics.newFont(32))
	love.graphics.printf("00:00.00", 352, 724, 320, "center")
end

return original
