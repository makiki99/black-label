menu = {}

menu.options = {
	{"mode_select", "Start game"},
	{"keyconfig", "Change keys"}
}

function menu.init()
end

function menu.update()
	--
end

function menu.draw()
	--background
	love.graphics.setColor(0,0,0)
	--love.graphics.rectangle("fill",0,0,1366,768)
	--final screen translation
	love.graphics.translate(171,0)
	love.graphics.setColor(255,255,255)
	--board
	--up border
	love.graphics.setColor(127,0,0,200)
	love.graphics.rectangle("fill",336,32,16,672)
	--left border
	love.graphics.setColor(0,127,0,200)
	love.graphics.rectangle("fill",352,32,320,16)
	--down border
	love.graphics.setColor(0,0,127,200)
	love.graphics.rectangle("fill",352,688,320,16)
	--right border
	love.graphics.setColor(127,127,127,200)
	love.graphics.rectangle("fill",672,32,16,672)
	--board bg
	love.graphics.setColor(0,0,0,200)
	love.graphics.rectangle("fill",352,48,320,640)
	--modes
	love.graphics.setColor(255,255,255)
	for i,v in ipairs(menu.options) do
		love.graphics.printf(v[2], 352, 200+i*48, 320, "center")
	end
	--timer
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(love.graphics.newFont(32))
	love.graphics.printf("00:00.00", 352, 724, 320, "center")
end

return menu
