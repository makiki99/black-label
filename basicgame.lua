basicgame = {}

function basicgame.key(key)
	return love.keyboard.isDown(userconf.keys[key])
end

function basicgame.init_state()
	basicgame.board = {}
	for x=1,10 do
		basicgame.board[x] = {}
		for y=0,20 do
			basicgame.board[x][y] = 0
		end
	end
	basicgame.current_piece = love.math.random(1,7)
	basicgame.piece_x = 5
	basicgame.piece_y = 1
	basicgame.rotation = 1
	basicgame.pressedA = false
	basicgame.pressedB = false
	basicgame.pressedC = false
	basicgame.gravity = 4 -- 256 units = 1 cell/frame
end

function basicgame.setColorFromPiece(id)
	if id == 1 then
		love.graphics.setColor(255,0,0,255)
	elseif id == 2 then
		love.graphics.setColor(0,255,255,255)
	elseif id == 3 then
		love.graphics.setColor(255,128,0,255)
	elseif id == 4 then
		love.graphics.setColor(0,0,255,255)
	elseif id == 5 then
		love.graphics.setColor(255,0,255,255)
	elseif id == 6 then
		love.graphics.setColor(0,255,0,255)
	elseif id == 7 then
		love.graphics.setColor(255,255,0,255)
	end
end

function basicgame.drawborder()
	--colors
	love.graphics.setColor(110,16,16,255)
	--up border
	love.graphics.rectangle("fill",336,32,16,672)
	--left border
	love.graphics.rectangle("fill",352,32,320,16)
	--down border
	love.graphics.rectangle("fill",352,688,320,16)
	--right border
	love.graphics.rectangle("fill",672,32,16,672)
	--board bg
	love.graphics.setColor(0,0,0,200)
	love.graphics.rectangle("fill",352,48,320,640)
end

function basicgame.drawcurrent()
	basicgame.setColorFromPiece(basicgame.current_piece)
	for i=1,4 do
		local x = minos.data[basicgame.current_piece][basicgame.rotation][i][1] + basicgame.piece_x
		local y = minos.data[basicgame.current_piece][basicgame.rotation][i][2] + basicgame.piece_y
		love.graphics.rectangle("fill",320+32*x,16+32*y,32,32)
	end
end

function basicgame.drawboard()
	basicgame.drawborder()
	basicgame.drawcurrent()
end

function basicgame.rotate_left()
	basicgame.rotation = basicgame.rotation-1
	if basicgame.rotation < 1 then
		basicgame.rotation = 4
	end
end

function basicgame.rotate_right()
	basicgame.rotation = basicgame.rotation+1
	if basicgame.rotation > 4 then
		basicgame.rotation = 1
	end
end

function basicgame.movement()
	if basicgame.key("a") then
		if not basicgame.pressedA then
			basicgame.rotate_left()
		end
		basicgame.pressedA = true
	else
		basicgame.pressedA = false
	end
	if basicgame.key("b") then
		if not basicgame.pressedB then
			basicgame.rotate_right()
		end
		basicgame.pressedB = true
	else
		basicgame.pressedB = false
	end
	if basicgame.key("c") then
		if not basicgame.pressedC then
			basicgame.rotate_left()
		end
		basicgame.pressedC = true
	else
		basicgame.pressedC = false
	end
end

return basicgame
