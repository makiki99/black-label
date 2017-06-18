menu = {}

local options = {
	{"mode_select", "Start game"},
	{"keyconfig", "Change keys"}
}

local current_opt = 1

local function keyhandle(key)
	if key == userconf.keys["menu_up"] then
		current_opt = current_opt-1
		if current_opt < 1 then
			current_opt = #options
		end
	elseif key == userconf.keys["menu_down"] then
		current_opt = current_opt+1
		if current_opt > #options then
			current_opt = 1
		end
	elseif key == userconf.keys["menu_confirm"] then
		love.keypressed = nil
		set_gamestate(options[current_opt][1])
	end
end

function menu.init()
	love.keypressed = keyhandle;
	assert(love.keypressed)
end

function menu.update() end

function menu.draw()
	--background
	love.graphics.setColor(0,0,0)
	--love.graphics.rectangle("fill",0,0,1366,768)
	--final screen translation
	love.graphics.translate(171,0)
	--board
	basicgame.drawborder()
	--cursor
	love.graphics.setColor(64,64,64)
	love.graphics.rectangle("fill", 352, 196+current_opt*48, 320, 48)
	--modes
	love.graphics.setColor(255,255,255)
	for i,v in ipairs(options) do
		love.graphics.printf(v[2], 352, 200+i*48, 320, "center")
	end
	--timer
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(love.graphics.newFont(32))
	love.graphics.printf("00:00.00", 352, 724, 320, "center")
end

return menu
