mode_select = {}

mode_select.options = {
	--{"simple", "Simple"},
	{"blacklabel", "Black Label"},
	--{"death", "Deadly Arrange"},
}

function mode_select.init()
end

function mode_select.update()
	--
end

function mode_select.draw()
	--background
	love.graphics.setColor(0,0,0)
	--love.graphics.rectangle("fill",0,0,1366,768)
	--final screen translation
	love.graphics.translate(171,0)
	basicgame.drawborder()
	--modes
	love.graphics.setColor(255,255,255)
	for i,v in ipairs(mode_select.options) do
		love.graphics.printf(v[2], 352, 200+i*48, 320, "center")
	end
	--timer
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(love.graphics.newFont(32))
	love.graphics.printf("00:00.00", 352, 724, 320, "center")
end

return mode_select
