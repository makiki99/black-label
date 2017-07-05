original = {}

basicgame.add_default_events(original)

local speedcurve = {
	--level, gravity, ARE, line delay, lock delay, das
	{1,4,25,40,30,14},
	{30,6,25,40,30,14},
	{35,8,25,40,30,14},
	{40,10,25,40,30,14},
	{50,12,25,40,30,14},
	{60,16,25,40,30,14},
	{70,32,25,40,30,14},
	{80,48,25,40,30,14},
	{90,64,25,40,30,14},
	{100,80,25,40,30,14},
	{120,96,25,40,30,14},
	{140,112,25,40,30,14},
	{160,128,25,40,30,14},
	{170,144,25,40,30,14},
	{200,4,25,40,30,14},
	{220,32,25,40,30,14},
	{230,64,25,40,30,14},
	{233,96,25,40,30,14},
	{236,128,25,40,30,14},
	{239,160,25,40,30,14},
	{243,192,25,40,30,14},
	{247,224,25,40,30,14},
	{251,256,25,40,30,14},
	{300,512,25,40,30,14},
	{330,768,25,40,30,14},
	{360,1024,25,40,30,14},
	{400,1280,25,40,30,14},
	{420,1024,25,40,30,14},
	{450,768,25,40,30,14},
	{500,5120,25,25,30,8},
	{601,5120,25,16,30,8},
	{701,5120,16,10,30,8},
	{801,5120,12,4,30,8},
	{900,5120,12,4,30,6},
	{901,5120,12,4,17,6},
}

local speed_ptr = 1
local function process_level()
	if basicgame.level > 999 then
		basicgame.level = 999
	end
	for i=speed_ptr,#speedcurve-1 do
		if basicgame.level < speedcurve[i+1][1] then
			speed_ptr = i
			break
		end
	end
	basicgame.gravity = speedcurve[speed_ptr][2]
	basicgame.are = speedcurve[speed_ptr][3]
	basicgame.linedelay = speedcurve[speed_ptr][4]
	basicgame.lockdelay = speedcurve[speed_ptr][5]
	basicgame.das = speedcurve[speed_ptr][6]
end

function original.on_spawn()
	if basicgame.level ~= 998 and basicgame.level%100 ~= 99 then
		basicgame.level = basicgame.level + 1
	end
	process_level()
end

function original.on_clear(lines)
	basicgame.level = basicgame.level + lines
	process_level()
end

function original.init()
	basicgame.init_state()
end

function original.update()
	basicgame.movement()
end

function original.draw()
	--background
	love.graphics.setColor(0,0,0)
	--love.graphics.rectangle("fill",0,0,1366,768)
	--final screen translation
	love.graphics.translate(171,0)
	basicgame.drawboard()
	--timer
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(love.graphics.newFont(32))
	love.graphics.printf("00:00.00", 352, 724, 320, "center")
end

return original
