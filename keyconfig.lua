keyconfig = {}

local lastkey
local keyname

local keyset = coroutine.create(function()
	for i,v in ipairs(userconf.numalias) do
		keyname = v
		coroutine.yield()
		userconf.keys[v] = lastkey
		print(v.." = "..userconf.keys[v])
	end
	love.keypressed = nil
	userconf.save()
	set_gamestate("menu")
end)

function keyconfig.keycallback(key)
	lastkey = key
	coroutine.resume(keyset)
end

function keyconfig.init()
	love.keypressed = keyconfig.keycallback
	coroutine.resume(keyset)
end

function keyconfig.update() end

function keyconfig.draw()
	love.graphics.setFont(love.graphics.newFont(32))
	love.graphics.setColor(255,255,255)
	love.graphics.printf("press key for "..keyname.." button", 171, 368, 1024, "center")
end

return keyconfig
