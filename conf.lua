function love.conf(t)
	t.identity = "makiki99-blacklabel"
	t.version = "0.10.2"                -- The LÖVE version this game was made for (string)
	t.gammacorrect = false              -- Enable gamma-correct rendering, when supported by the system (boolean)
	t.window.title = "Blockdrop Black Label"
	t.window.width = 1366
	t.window.height = 768
	t.window.resizable = true          -- Let the window be user-resizable (boolean)
	t.window.fullscreen = true         -- Enable fullscreen (boolean)
	t.window.vsync = false
	t.window.msaa = 1
	t.window.display = 1
	t.modules.mouse = false
	t.modules.physics = false
	t.modules.touch = false
	t.modules.video = false
end
