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
	basicgame.current_piece = 3
	basicgame.piece_x = 5
	basicgame.piece_y = 1
	basicgame.rotation = 1
	basicgame.pressedA = false
	basicgame.pressedB = false
	basicgame.pressedC = false
	basicgame.canHold = false
	basicgame.gravity_counter = 0
	basicgame.gravity = 128 -- 256 units = 1 cell/frame
	basicgame.das_charge = 0
	basicgame.das = 14
	--test
	basicgame.board[6][18] = 8
	basicgame.board[6][19] = 8
	basicgame.board[7][18] = 8
	basicgame.board[8][18] = 8
	basicgame.board[8][19] = 8
	basicgame.board[8][20] = 8
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
	else
		love.graphics.setColor(128,128,128,255)
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
	for x=1,10 do
		for y=1,20 do
			if basicgame.board[x][y]>0 then
				basicgame.setColorFromPiece(basicgame.board[x][y])
				love.graphics.rectangle("fill",320+32*x,16+32*y,32,32)
			end
		end
	end
end

function basicgame.col_check(offx,offy)
	for i=1,4 do
		local x = minos.data[basicgame.current_piece][basicgame.rotation][i][1] + basicgame.piece_x + offx
		local y = minos.data[basicgame.current_piece][basicgame.rotation][i][2] + basicgame.piece_y + offy
		if x < 1 or x > 10 or y > 20 or basicgame.board[x][y] > 0 then
			return true
		end
	end
	return false
end

function basicgame.lock()
	--stubbed
end

function basicgame.kick()
	local can_kick = false
	for i=1,4 do
		local x = minos.data[basicgame.current_piece][basicgame.rotation][i][1]
		local y = minos.data[basicgame.current_piece][basicgame.rotation][i][2]
		if x ~= 0 then
			x = x + basicgame.piece_x
			y = y + basicgame.piece_y
			if x < 1 or x > 10 or y > 20 or basicgame.board[x][y] > 0 then
				can_kick = true
			end
		end
	end
	if can_kick then
		if not basicgame.col_check(1,0) then
			basicgame.piece_x = basicgame.piece_x + 1
			return true
		end
		if not basicgame.col_check(-1,0) then
			basicgame.piece_x = basicgame.piece_x - 1
			return true
		end
	end
	return false
end

--TODO: refactor because fuck code repetition
function basicgame.rotate_left()
	basicgame.rotation = basicgame.rotation-1
	if basicgame.rotation < 1 then
		basicgame.rotation = 4
	end
	if not basicgame.col_check(0,0) then
		return
	end
	if basicgame.kick() then
		return
	end
	basicgame.rotation = basicgame.rotation+1
	if basicgame.rotation > 4 then
		basicgame.rotation = 1
	end
end

function basicgame.rotate_right()
	basicgame.rotation = basicgame.rotation+1
	if basicgame.rotation > 4 then
		basicgame.rotation = 1
	end
	if not basicgame.col_check(0,0) then
		return;
	end
	if basicgame.kick() then
		return
	end
	basicgame.rotation = basicgame.rotation-1
	if basicgame.rotation < 1 then
		basicgame.rotation = 4
	end
end

function basicgame.movement()
	--rotation buttons
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
	if basicgame.key("d") then
		--stubbed for now - hold button
	end
	--d-pad
	local x_axis = 0
	local y_axis = 0
	if basicgame.key("left") then
		x_axis = x_axis - 1
	end
	if basicgame.key("right") then
		x_axis = x_axis + 1
	end
	if basicgame.key("up") then
		y_axis = y_axis - 1
	end
	if basicgame.key("down") then
		y_axis = y_axis + 1
	end
	--movement
	if x_axis == 0 then
		basicgame.das_charge = 0
	elseif math.sign(basicgame.das_charge) == x_axis then
		basicgame.das_charge = basicgame.das_charge + x_axis
	else
		basicgame.das_charge = x_axis
	end
	if math.abs(basicgame.das_charge) == 1 or math.abs(basicgame.das_charge) >= basicgame.das then
		local dir = math.sign(basicgame.das_charge)
		if not basicgame.col_check(dir,0) then
			basicgame.piece_x = basicgame.piece_x + dir
		end
	end
	--gravity
	if not basicgame.col_check(0,1) then
		--don't apply gravity while on ground
		basicgame.gravity_counter = basicgame.gravity_counter + basicgame.gravity
		while basicgame.gravity_counter > 256 and not basicgame.col_check(0,1) do
			basicgame.piece_y = basicgame.piece_y + 1
			basicgame.gravity_counter = basicgame.gravity_counter - 256
		end
	end
	--lock
end

return basicgame
