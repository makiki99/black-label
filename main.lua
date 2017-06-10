FPS = 60

function love.load()
	dt_storage = 0
	frametimer = 0
end

function love.update(dt)
	dt_storage = dt_storage + dt
	while dt_storage > 1/FPS do
		updatetick()
	end
end

function updatetick()
	frametimer = frametimer + 1/FPS
	dt_storage = dt_storage - 1/FPS
end

function love.draw()
	love.graphics.scale(2)
	love.graphics.print(frametimer, 100, 100)
end
