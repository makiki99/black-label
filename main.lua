FPS = 60

function love.resize(w,h)
	local ratio = w/h;
	if ratio > 16/9 then
		-- screen too wide
		scr.scale = h/720
		scr.offx = 0
	elseif ratio > 4/3 then
		scr.scale = h/720
		scr.offx = -160*(16/9-ratio)/(16/9-4/3)
	else
		scr.scale = w/960
		scr.offx = -160
	end
end

function love.load()
	scr = {
		scale = 1,
		offx = 0,
		offy = 0
	}
	dt_storage = 0
	timer = 0
end

function love.update(dt)
	dt_storage = dt_storage + dt
	while dt_storage > 1/FPS do
		updatetick()
		dt_storage = dt_storage - 1/FPS
	end
end

function updatetick()
	timer = timer + 1
end

function love.draw()
	love.graphics.scale(scr.scale)
	love.graphics.translate(scr.offx,scr.offy)
	--borders for debug purposes
	love.graphics.setColor(128,0,0)
	love.graphics.rectangle("line",0,0,1280,720)
	love.graphics.setColor(0,0,128)
	love.graphics.rectangle("line",160,0,960,720)
end
