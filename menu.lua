menu = {}

function menu.update()
end

function menu.draw()
	--background
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,0,1366,768)
	--final screen translation
	love.graphics.translate(171,0)
	love.graphics.setColor(255,255,255)
	--board
	love.graphics.rectangle("line",352,48,320,640)
	love.graphics.rectangle("line",336,32,352,672)
	love.graphics.setColor(0,0,0,200)
	love.graphics.rectangle("fill",352,48,320,640)
	--timer
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(love.graphics.newFont(32))
	love.graphics.printf("00:00.00", 352, 724, 320, "center")
end

return menu
