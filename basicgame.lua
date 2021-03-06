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
	basicgame.lineanim = {}
	for i=1,20 do
		basicgame.lineanim[i] = 0
	end
	basicgame.current_piece = 1
	basicgame.rotation = 1
	basicgame.piece_x = 5
	basicgame.piece_y = 1
	basicgame.hold_piece = 0 -- zero means no hold piece
	basicgame.randomizer_history = {5,6,5,6}
	basicgame.next_queue = {love.math.random(1, 4),basicgame.get_next_piece(),basicgame.get_next_piece()}
	basicgame.gravity_counter = 0
	basicgame.das_charge = 0
	basicgame.lock_counter = 0
	basicgame.are_counter = 0
	--settings
	basicgame.gravity = 5120 -- 256 units = 1 cell/frame
	basicgame.das = 14
	basicgame.are = 25
	basicgame.lockdelay = 30
	basicgame.lockflash = 0
	basicgame.linedelay = 40
	basicgame.lineanimtime = 8
	basicgame.gameover_frame = 0
	basicgame.level = 1
	--info
	basicgame.framecount = 0
	basicgame.endframe = 0
	basicgame.is_game_won = false
	--flags
	basicgame.pressedA = false
	basicgame.pressedB = false
	basicgame.pressedC = false
	basicgame.has_floorkicked = false
	basicgame.has_accepted_floorkick = false
	basicgame.can_instalock = false
	basicgame.has_spawned = false
	basicgame.has_locked = false
	basicgame.can_hold = true
	--test
end

function basicgame.add_default_events(gamestate)
	print(gamestate)
	gamestate.on_hold = function() end
	gamestate.on_spawn = function() end
	gamestate.on_lock = function() end
	gamestate.on_clear = function(lines) end
	print(gamestate)
end

function basicgame.get_next_piece()
	for roll=1,6 do
		local block = love.math.random(1, 7)
		local in_history = false
		if roll ~= 6 then
			for i=1,4 do
				if block == basicgame.randomizer_history[i] then
					in_history = true
					break
				end
			end
		end
		if not in_history then
			--basicgame.randomizer_history = {5,6,5,6}
			for i=1,3 do
				basicgame.randomizer_history[i] = basicgame.randomizer_history[i+1]
			end
			basicgame.randomizer_history[4] = block
			return block
		end
	end
end

function basicgame.setColorFromPiece(id)
	if basicgame.endframe > 0 and not basicgame.is_game_won then
		love.graphics.setColor(128,128,128,255)
	elseif id == 1 then
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
			love.graphics.setShader(shaders.currentMino)
			shaders.currentMino:send("lockpercent", basicgame.lock_counter/basicgame.lockdelay)
		end
		for i=1,4 do
			local x = minos.data[basicgame.current_piece][basicgame.rotation][i][1] + basicgame.piece_x
			local y = minos.data[basicgame.current_piece][basicgame.rotation][i][2] + basicgame.piece_y
			love.graphics.rectangle("fill",320+32*x,16+32*y,32,32)
		end
		love.graphics.setShader()
	end
end

function basicgame.drawnext()
	for i=1,3 do
		basicgame.setColorFromPiece(basicgame.next_queue[i])
		for j=1,4 do
			local x = minos.data[basicgame.next_queue[i]][1][j][1]
			local y = minos.data[basicgame.next_queue[i]][1][j][2]
			love.graphics.rectangle("fill",736+32*x,12+32*y+80*i,32,32)
		end
	end
end

function basicgame.drawhold()
	if basicgame.hold_piece ~= 0 then
		basicgame.setColorFromPiece(basicgame.hold_piece)
		for j=1,4 do
			local x = minos.data[basicgame.hold_piece][1][j][1]
			local y = minos.data[basicgame.hold_piece][1][j][2]
			love.graphics.rectangle("fill",208+32*x,92+32*y,32,32)
		end
	end
end

function basicgame.drawlineanim()
	love.graphics.setShader(shaders.lineClear)
	for i=1,20 do
		if basicgame.lineanim[i]>0 then
			local percentage = (basicgame.lineanim[i]/basicgame.lineanimtime)
			shaders.lineClear:send("animpercent",percentage);
			love.graphics.rectangle("fill",352,16+32*i,320,32)
		end
	end
	love.graphics.setShader()
end

function basicgame.drawtimer()
	local function leftpad2(str)
		str = ""..str
		if #str==1 then
			return "0"..str
		else
			return str
		end
	end
	local framecount = basicgame.framecount
	local minutes = math.floor(framecount/3600)
	framecount = framecount - minutes*3600
	local seconds = math.floor(framecount/60)
	framecount = framecount - seconds*60
	local centiseconds = math.floor(100/60*framecount)
	local timerstr = ""..leftpad2(minutes)..":"..leftpad2(seconds).."."..leftpad2(centiseconds)
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(love.graphics.newFont(32))
	love.graphics.printf(timerstr, 352, 716, 320, "center")
end

function basicgame.drawboard()
	basicgame.drawborder()
	for x=1,10 do
		for y=1,20 do
			if basicgame.lineanim[y]==0 and basicgame.board[x][y]>0 then
				basicgame.setColorFromPiece(basicgame.board[x][y])
				love.graphics.setShader(shaders.stack)
				love.graphics.rectangle("fill",320+32*x,16+32*y,32,32)
				love.graphics.setShader()
				--stack border
				love.graphics.setColor(255,255,255,255)
				--top
				if basicgame.board[x][y-1]==0 then
				love.graphics.rectangle("fill",320+32*x,16+32*y,32,2)
				end
				--left
				if basicgame.board[x-1] and basicgame.board[x-1][y]==0 then
				love.graphics.rectangle("fill",320+32*x,16+32*y,2,32)
				end
				--right
				if basicgame.board[x+1] and basicgame.board[x+1][y]==0 then
				love.graphics.rectangle("fill",350+32*x,16+32*y,2,32)
				end
				--bottom
				if basicgame.board[x][y+1]==0 then
				love.graphics.rectangle("fill",320+32*x,46+32*y,32,2)
				end
			end
		end
	end
	basicgame.drawcurrent()
	basicgame.drawlineanim()
	basicgame.drawnext()
	basicgame.drawhold()
	basicgame.drawtimer()
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

function basicgame.hold()
	if basicgame.can_hold then
		if basicgame.hold_piece == 0 then
			basicgame.hold_piece = basicgame.current_piece
			basicgame.current_piece = basicgame.next_queue[1]
			basicgame.next_queue[1] = basicgame.next_queue[2]
			basicgame.next_queue[2] = basicgame.next_queue[3]
			basicgame.next_queue[3] = basicgame.get_next_piece()
		else
			basicgame.hold_piece,basicgame.current_piece = basicgame.current_piece,basicgame.hold_piece
		end
		basicgame.piece_x = 5
		basicgame.piece_y = 1
		basicgame.rotation = 1
		basicgame.lock_counter = 0
		basicgame.can_hold = false
		basicgame.has_floorkicked = false
		basicgame.can_instalock = false
		basicgame.gravity_counter = basicgame.gravity
		while basicgame.gravity_counter > 256 and not basicgame.col_check(0,1) do
			basicgame.piece_y = basicgame.piece_y + 1
			basicgame.gravity_counter = basicgame.gravity_counter - 256
			basicgame.lock_counter = 0
		end
		gamestate_list[gamestate].on_hold()
	end
end

function basicgame.spawn()
	basicgame.has_floorkicked = false
	basicgame.has_accepted_floorkick = false
	basicgame.can_instalock = false
	basicgame.can_hold = true
	basicgame.current_piece = basicgame.next_queue[1]
	basicgame.next_queue[1] = basicgame.next_queue[2]
	basicgame.next_queue[2] = basicgame.next_queue[3]
	basicgame.next_queue[3] = basicgame.get_next_piece()
	basicgame.piece_x = 5
	basicgame.piece_y = 1
	basicgame.rotation = 1
	basicgame.lock_counter = 0
	if basicgame.key("d") then
		basicgame.hold()
	end
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
	basicgame.gravity_counter = basicgame.gravity
	while basicgame.gravity_counter > 256 and not basicgame.col_check(0,1) do
		basicgame.piece_y = basicgame.piece_y + 1
		basicgame.gravity_counter = basicgame.gravity_counter - 256
		basicgame.lock_counter = 0
	end
	if basicgame.col_check(0,0) then
		basicgame.endframe = 1
	end
	gamestate_list[gamestate].on_spawn()
end

function basicgame.lock()
	for i=1,4 do
		local x = minos.data[basicgame.current_piece][basicgame.rotation][i][1] + basicgame.piece_x
		local y = minos.data[basicgame.current_piece][basicgame.rotation][i][2] + basicgame.piece_y
		basicgame.board[x][y] = basicgame.current_piece
	end
	basicgame.are_counter = basicgame.are

	gamestate_list[gamestate].on_lock()
	--check line clears
	local lines_cleared = 0
	for y=0,20 do
		local filled = true
		for x=1,10 do
			if basicgame.board[x][y]==0 then
				filled = false
				break
			end
		end
		if filled then
			lines_cleared = lines_cleared + 1
			if y>0 then
				basicgame.lineanim[y] = basicgame.lineanimtime
			end
			-- for yy=y, 1,-1 do
			-- 	for xx=1,10 do
			-- 		basicgame.board[xx][yy] = basicgame.board[xx][yy-1]
			-- 	end
			-- end
		end
	end
	if lines_cleared == 0 then
		basicgame.lockflash = 2
	else
		gamestate_list[gamestate].on_clear(lines_cleared)
		basicgame.are_counter = basicgame.are_counter + basicgame.linedelay
	end
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
		if basicgame.has_accepted_floorkick then
			basicgame.can_instalock = true
		end
		return
	end
	if basicgame.kick() then
		if basicgame.has_accepted_floorkick then
			basicgame.can_instalock = true
		elseif basicgame.has_floorkicked then
			basicgame.has_accepted_floorkick = true
		end
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
		if basicgame.has_accepted_floorkick then
			basicgame.can_instalock = true
		end
		return
	end
	if basicgame.kick() then
		if basicgame.has_accepted_floorkick then
			basicgame.can_instalock = true
		elseif basicgame.has_floorkicked then
			basicgame.has_accepted_floorkick = true
		end
		return
	end
	basicgame.rotation = basicgame.rotation-1
	if basicgame.rotation < 1 then
		basicgame.rotation = 4
	end
end

function basicgame.movement()
	for i=1,20 do
		if basicgame.lineanim[i] > 0 then
			--check line collapse
			if basicgame.lineanim[i] == 1 then
				for y=i, 1,-1 do
					for x=1,10 do
						basicgame.board[x][y] = basicgame.board[x][y-1]
					end
				end
			end
			basicgame.lineanim[i] = basicgame.lineanim[i] - 1
		end
	end
	if basicgame.endframe > 0 then
		if basicgame.endframe > 120 then
			if basicgame.key("a") or basicgame.key("b") or basicgame.key("c") or basicgame.key("d") then
				set_gamestate("menu")
			end
		end
		basicgame.endframe = basicgame.endframe +1
		return
	end
	basicgame.framecount = basicgame.framecount + 1
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
	if basicgame.are_counter == 0 then
		if basicgame.key("d") then
			basicgame.hold()
		end
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
			while basicgame.gravity_counter >= 256 and not basicgame.col_check(0,1) do
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
			if x_axis == 0 then
				basicgame.das_charge = 0
			elseif math.sign(basicgame.das_charge) == x_axis then
				basicgame.das_charge = basicgame.das_charge + x_axis
			else
				basicgame.das_charge = x_axis
			end
			if basicgame.are_counter == 0 then
				basicgame.spawn()
			end
		end
	end
end

return basicgame
