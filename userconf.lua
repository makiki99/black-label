userconf = {}

local keyfile = love.filesystem.newFile("keys.txt")

userconf.keys = {}

userconf.numalias = {
	"up",
	"down",
	"left",
	"right",
	"a",
	"b",
	"c",
	"d",
	"menu_up",
	"menu_down" ,
	"menu_left",
	"menu_right",
	"menu_confirm",
	"menu_cancel",
}

function userconf.load()
	keyfile:open('r')
	for i in keyfile:lines() do
		print("read line "..i)
	end
	keyfile:close()
end

function userconf.save()
	keyfile:open('w')
	for i,v in ipairs(userconf.numalias) do
		keyfile:write(userconf.keys[v]..'\n')
		print("written line "..i..' '..v)
	end
	keyfile:close()
end

return userconf
