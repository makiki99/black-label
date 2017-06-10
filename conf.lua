function love.conf(t)
	t.identity = "blockdrop_bl"
	t.version = "0.10.2"                -- The LÖVE version this game was made for (string)
	t.gammacorrect = false              -- Enable gamma-correct rendering, when supported by the system (boolean)
	t.window.title = "Blockdrop Black Label"
	t.window.width = 0
	t.window.height = 0
	t.window.resizable = true          -- Let the window be user-resizable (boolean)
	t.window.fullscreen = true         -- Enable fullscreen (boolean)
	t.window.vsync = false
	t.window.msaa = 0
	t.window.display = 1
	t.modules.mouse = false              -- Enable the mouse module (boolean)
	t.modules.physics = false            -- Enable the physics module (boolean)
	t.modules.touch = false              -- Enable the touch module (boolean)
	t.modules.video = false              -- Enable the video module (boolean)
end
