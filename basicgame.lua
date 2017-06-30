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
	basicgame.current_piece = 2
	basicgame.rotation = 1
	basicgame.piece_x = 5
	basicgame.piece_y = 1
	basicgame.hold_piece = 0 -- zero means no hold piece
	basicgame.next_queue = {}
	basicgame.gravity_counter = 0
	basicgame.gravity = 5120 -- 256 units = 1 cell/frame
	basicgame.das_charge = 0
	basicgame.das = 8
	basicgame.are_counter = 0
	basicgame.are = 30
	basicgame.lock_counter = 0
	basicgame.lockdelay = 30
	basicgame.lockflash = 0
	--flags
	basicgame.pressedA = false
	basicgame.pressedB = false
	basicgame.pressedC = false
	basicgame.has_floorkicked = false
	basicgame.can_instalock = false
	basicgame.has_locked = false
	basicgame.can_hold = true
	--test
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
	if basicgame.are_counter == 0 or basicgame.lockflash > 0 then
		if basicgame.lockflash > 0 then
			love.graphics.setColor(255,255,255,255)
		else
			basicgame.setColorFromPiece(basicgame.current_piece)
		end
		for i=1,4 do
			local x = minos.data[basicgame.current_piece][basicgame.rotation][i][1] + basicgame.piece_x
			local y = minos.data[basicgame.current_piece][basicgame.rotation][i][2] + basicgame.piece_y
			love.graphics.rectangle("fill",320+32*x,16+32*y,32,32)
		end
	end
end

function basicgame.drawboard()
	basicgame.drawborder()
	for x=1,10 do
		for y=1,20 do
			if basicgame.board[x][y]>0 then
				basicgame.setColorFromPiece(basicgame.board[x][y])
				love.graphics.rectangle("fill",320+32*x,16+32*y,32,32)
				--temporary until I'll write a shader
				love.graphics.setColor(0,0,0,64)
				love.graphics.rectangle("fill",320+32*x,16+32*y,32,32)
			end
		end
	end
	basicgame.drawcurrent()
end

function basicgame.col_check(offx,offy)
	for i=1,4 do
		local x = minos.data[basicgame.current_piece][basicgame.rotation][i][1] + basicgame.piece_x + offx
		local y = minos.data[basicgame.current_piece][basicgame.rotation][i][2] + basicgame.piece_y + offy
		if x < 1 or x > 10 or y > 20 or y < 0 or basicgame.board[x][y] > 0 then
			return true
		end
	end
	return false
end

function basicgame.spawn()
	basicgame.has_floorkicked = false
	basicgame.can_instalock = false
	basicgame.has_locked = false
	basicgame.can_hold = true
	basicgame.piece_x = 5
	basicgame.piece_y = 1
	basicgame.rotation = 1
	if basicgame.key("a") then
		basicgame.rotate_left()
		basicgame.pressedA = true
	else
		basicgame.pressedA = false
	end
	if basicgame.key("b") then
		basicgame.rotate_right()
		basicgame.pressedB = true
	else
		basicgame.pressedB = false
	end
	if basicgame.key("c") then
		basicgame.rotate_left()
		basicgame.pressedC = true
	else
		basicgame.pressedC = false
	end
	if basicgame.key("d") then
		--stubbed for now - hold button
	end
end

function basicgame.lock()
	for i=1,4 do
		local x = minos.data[basicgame.current_piece][basicgame.rotation][i][1] + basicgame.piece_x
		local y = minos.data[basicgame.current_piece][basicgame.rotation][i][2] + basicgame.piece_y
		basicgame.board[x][y] = basicgame.current_piece
	end
	basicgame.are_counter = basicgame.are
	basicgame.lockflash = 2
end

function basicgame.kick()
	local can_kick = false
	if basicgame.current_piece == 1 then
		if basicgame.rotation%2 == 0 then
			--floorkicks
			--check if on ground before kick
			basicgame.rotation = basicgame.rotation-1
			if basicgame.col_check(0,1) then
				can_kick = true
			end
			basicgame.rotation = basicgame.rotation+1
			if can_kick then
				if not basicgame.col_check(0, -1) then
					basicgame.piece_y = basicgame.piece_y - 1
					basicgame.has_floorkicked = true
					return true
				elseif not basicgame.col_check(0, -2) then
					basicgame.piece_y = basicgame.piece_y - 2
					basicgame.has_floorkicked = true
					return true
				end
			end
		else
			can_kick = true
			if not basicgame.col_check(1,0) then
				basicgame.piece_x = basicgame.piece_x + 1
				return true
			elseif not basicgame.col_check(2,0) then
				basicgame.piece_x = basicgame.piece_x + 2
				return true
			elseif not basicgame.col_check(-1,0) then
				basicgame.piece_x = basicgame.piece_x - 1
				return true
			end
		end
	else
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
			elseif not basicgame.col_check(-1,0) then
				basicgame.piece_x = basicgame.piece_x - 1
				return true
			elseif (basicgame.current_piece == 2 and not basicgame.col_check(0,-1)) then
				basicgame.piece_y = basicgame.piece_y - 1
				basicgame.has_floorkicked = true
				return true
			end
		end
	end
	return false
end

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
	if basicgame.are_counter == 0 then
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
			if y_axis == 1 and basicgame.gravity_counter < 256 then
				basicgame.gravity_counter = 256
			elseif y_axis == -1 then
				basicgame.gravity_counter = 5120
			end
			while basicgame.gravity_counter > 256 and not basicgame.col_check(0,1) do
				basicgame.piece_y = basicgame.piece_y + 1
				basicgame.gravity_counter = basicgame.gravity_counter - 256
				basicgame.lock_counter = 0
			end
		end
		--lock
		if basicgame.col_check(0,1) then
			basicgame.gravity_counter = 0
			if y_axis == 1 or basicgame.lock_counter > basicgame.lockdelay or basicgame.can_instalock then
				basicgame.lock()
			else
				basicgame.lock_counter = basicgame.lock_counter + 1
			end
		end
	else
		if basicgame.lockflash > 0 then
			basicgame.lockflash = basicgame.lockflash - 1
		else
			basicgame.are_counter = basicgame.are_counter - 1
			if basicgame.are_counter == 0 then
				basicgame.spawn()
			end
		end
	end
end

return basicgame
