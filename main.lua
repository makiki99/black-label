FPS = 60

require "basicgame"
require "minos"
require "userconf"

function love.resize(w,h)
	local ratio = w/h;
	if ratio > 16/9 then
		-- screen too wide
		scr.scale = h/768
		scr.offx = (w/scr.scale-1366)/2
		scr.offy = 0
	elseif ratio > 4/3 then
		scr.scale = h/768
		scr.offx = -171*(16/9-ratio)/(16/9-4/3)
		scr.offy = 0
	else
		scr.scale = w/1024
		scr.offx = -171
		scr.offy = (h/scr.scale-768)/2
	end
end

function love.load()
	print(love.filesystem.getSaveDirectory())
	scr = {
		scale = 1,
		offx = 0,
		offy = 0
	}
	dt_storage = 0
	gamestate_list = {
		keyconfig = require "keyconfig",
		start = require "start",
		terminate = require "terminate",
		menu = require "menu",
		mode_select = require "mode_select",
		original = require "original",
		blacklabel = require "blacklabel",
	}
	set_gamestate("start")
end

function set_gamestate(id)
	gamestate = id
	assert(gamestate_list[id])
	gamestate_list[id].init()
	print("gamestate set: "..gamestate)
end

function love.update(dt)
	dt_storage = dt_storage + dt
	while dt_storage > 1/FPS do
		updatetick()
		dt_storage = dt_storage - 1/FPS
	end
end

function updatetick()
	gamestate_list[gamestate].update()
end

function love.draw()
	love.graphics.scale(scr.scale)
	love.graphics.translate(scr.offx,scr.offy)
	--borders for debug purposes
	love.graphics.setColor(255,0,0)
	love.graphics.rectangle("line",0,0,1366,768)
	love.graphics.setColor(0,0,255)
	love.graphics.rectangle("line",171,0,1024,768)
	--gamestate's redraw
	gamestate_list[gamestate].draw()
end

--standard library extensions
function math.sign(n) return n>0 and 1 or n<0 and -1 or 0 end
