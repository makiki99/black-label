basicgame = {}

function basicgame.key(key)
	return love.keyboard.isDown(userconf.keys[key])
end

function basicgame.init_state()
	basicgame.current = 1
	basicgame.x = 5
	basicgame.y = 0
	basicgame.rotation = 0
end

function basicgame.drawborder()
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
end

function basicgame.drawboard()
	basicgame.drawborder()
end

return basicgame
