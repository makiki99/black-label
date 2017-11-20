black_label = {}

basicgame.add_default_events(black_label)

local speedcurve = {
	--rank, gravity, ARE, line delay, lock delay, das
	{1,4,30,30,30,14},
	{2,8,30,30,30,14},
	{3,16,30,30,30,14},
	{4,24,30,30,30,14},
	{5,32,30,30,30,14},
	{6,48,30,30,30,14},
	{7,64,30,30,30,14},
	{8,96,30,30,30,14},
	{9,128,30,30,30,14},
	{10,256,30,30,30,14},
	{11,386,30,30,30,14},
	{12,512,30,30,30,14},
	{13,640,30,30,30,14},
	{14,768,30,30,30,14},
	{15,896,30,30,30,14},
	{16,1024,30,30,30,14},
	{17,1152,30,30,30,14},
	{18,1280,30,30,30,14},
	{19,2560,30,30,30,14},
	{20,5120,30,22,30,8},
	{25,5120,25,16,30,8},
	{30,5120,20,8,30,8},
	{35,5120,16,6,30,8},
	{40,5120,12,4,17,6},
	{45,5120,6,3,17,6},
	{50,5120,4,2,15,4},
	{60,5120,4,2,14,4},
	{70,5120,4,2,13,4},
	{80,5120,4,2,12,4},
	{90,5120,4,2,11,4},
	{100,5120,4,2,10,4},

}

local grades = {
	"9", "8", "7", "6", "5", "4", "3", "2", "1",
	"S1", "S2", "S3", "S4", "S5", "S6", "S7", "S8", "S9",
	"M1", "M2", "M3", "M4", "M5", "M6", "M7", "M8", "M9",
	"X1", "X2", "X3", "X4", "X5", "X6", "X7", "X8", "X9",
	"Master", "MasterK", "MasterV", "MasterO", "MasterM", "MasterX", "Grand Master"
}

local speed_ptr = 1
local rank = 1
local grade = 1
local function process_level()
	if basicgame.level > 999 then
		basicgame.level = 999
		basicgame.is_game_won = true
		basicgame.endframe = 1
	end
	for i=speed_ptr,#speedcurve-1 do
		if rank < speedcurve[i+1][1] then
			speed_ptr = i
			break
		end
	end
	basicgame.gravity = speedcurve[speed_ptr][2]
	basicgame.are = speedcurve[speed_ptr][3]
	basicgame.linedelay = speedcurve[speed_ptr][4]
	basicgame.lockdelay = speedcurve[speed_ptr][5]
	basicgame.das = speedcurve[speed_ptr][6]
	basicgame.lineanimtime = basicgame.linedelay>6 and basicgame.linedelay or 6
end

local function get_grade()
	return grades[1]
end

function black_label.on_spawn()
	if basicgame.level ~= 998 and basicgame.level%100 ~= 99 then
		basicgame.level = basicgame.level + 1
	end
	process_level()
end

function black_label.on_clear(lines)
	if lines >= 4 then
		basicgame.level = basicgame.level + 6
		--
	elseif lines == 3 then
		basicgame.level = basicgame.level + 4
		--
	elseif lines == 2 then
		basicgame.level = basicgame.level + 2
		--
	elseif lines == 1 then
		basicgame.level = basicgame.level + 1
		--
	end
	process_level()
end

function black_label.init()
	speed_ptr = 1
	rank = 1
	grade = 1
	speed_ptr = 1
	basicgame.init_state()
	process_level()
end

function black_label.update()

	basicgame.movement()
end

function black_label.draw()
	--background
	love.graphics.setColor(0,0,0)
	--love.graphics.rectangle("fill",0,0,1366,768)
	--final screen translation
	love.graphics.translate(171,0)
	basicgame.drawboard()
	--timer
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(love.graphics.newFont(32))
	love.graphics.printf(basicgame.level, 720, 500, 80, "center")
	love.graphics.line(720, 537, 800, 537)
	love.graphics.printf(basicgame.level >= 900 and "999" or basicgame.level+100-basicgame.level%100, 720, 540, 80, "center")
	--win/lose
	if basicgame.endframe > 45 then
		love.graphics.setColor(0,0,0,196)
		love.graphics.rectangle("fill", 352, 242, 320, 48)
		love.graphics.setColor(255,255,255)
		love.graphics.printf(basicgame.is_game_won and "Congratulations!" or "Game over...", 352, 250, 320, "center")
	end
	if basicgame.endframe > 60 then
		love.graphics.setColor(0,0,0,196)
		love.graphics.rectangle("fill", 352, 290, 320, 48)
		love.graphics.setColor(255,255,255)
		love.graphics.printf("Grade: "..get_grade(), 352, 298, 320, "center")
	end
end

return black_label
