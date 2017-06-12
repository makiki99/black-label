userconf = {}

userconf.keys = {
	up = "up",
	down = "down",
	left = "left",
	right = "right",
	a = "z",
	b = "x",
	c = "c",
	d = "rshift",
	menu_up = "up",
	menu_down = "down",
	menu_left = "left",
	menu_right = "right",
	menu_confirm = "z",
	menu_cancel = "x",
}

function userconf.load()
	userconf.keys = bitser.loadLoveFile("keyconfig.sav")
end

function userconf.save()
	bitser.dumpLoveFile("keyconfig.sav", userconf.keys)
end

return userconf
