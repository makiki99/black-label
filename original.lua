original = {}

basicgame.add_default_events(original)

local speedcurve = {
	--level, gravity, ARE, line delay, lock delay, das, scoremult
	{1,4,25,40,30,14, 1.0},
	{20,8,25,40,30,14, 1.0},
	{40,16,25,40,30,14, 1.0},
	{60,32,25,40,30,14, 1.0},
	{80,48,25,40,30,14, 1.0},
	{100,64,25,40,30,14, 1.0},
	{120,80,25,40,30,14, 1.0},
	{140,96,25,40,30,14, 1.0},
	{160,112,25,40,30,14, 1.0},
	{180,128,25,40,30,14, 1.0},
	{200,4,25,40,30,14, 1.0},
	{220,32,25,40,30,14, 1.0},
	{225,64,25,40,30,14, 1.0},
	{230,96,25,40,30,14, 1.0},
	{235,128,25,40,30,14, 1.0},
	{240,160,25,40,30,14, 1.0},
	{245,192,25,40,30,14, 1.0},
	{250,256,25,40,30,14, 1.2},
	{300,512,25,40,30,14, 1.5},
	{330,768,25,40,30,14, 1.5},
	{360,1024,25,40,30,14, 1.5},
	{400,1280,25,40,30,14, 1.5},
	{420,1024,25,40,30,14, 1.5},
	{450,768,25,40,30,14, 1.5},
	{500,5120,25,25,30,8, 1.5},
	{600,5120,25,16,30,8, 1.7},
	{700,5120,16,9,30,8, 1.9},
	{800,5120,12,4,30,8, 2.1},
	{900,5120,12,4,17,6, 2.5},
}

local grades = {
	{0, "30th kyu"},
	{20, "29th kyu"},
	{40, "28th kyu"},
	{60, "27th kyu"},
	{80, "26th kyu"},
	{100, "25th kyu"},
	{120, "24th kyu"},
	{140, "23rd kyu"},
	{160, "22nd kyu"},
	{180, "21st kyu"},
	{200, "20th kyu"},
	{230, "19th kyu"},
	{260, "18th kyu"},
	{290, "17th kyu"},
	{320, "16th kyu"},
	{350, "15th kyu"},
	{380, "14th kyu"},
	{410, "13th kyu"},
	{440, "12th kyu"},
	{470, "11th kyu"},
	{500, "10th kyu"},
	{530, "9th kyu"},
	{560, "8th kyu"},
	{590, "7th kyu"},
	{620, "6th kyu"},
	{650, "5th kyu"},
	{680, "4th kyu"},
	{710, "3rd kyu"},
	{745, "2nd kyu"},
	{780, "1st kyu"},
	{815, "1st dan"},
	{850, "2nd dan"},
	{885, "3rd dan"},
	{920, "4th dan"},
	{955, "5th dan"},
	{990, "6th dan"},
	{1025, "7th dan"},
	{1050, "8th dan"},
	{1090, "9th dan"},
	{1150, "10th dan"},
}

local speed_ptr = 1
local function process_level()
	if basicgame.level > 999 then
		basicgame.level = 999
		basicgame.is_game_won = true
		basicgame.endframe = 1
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
	original.scoremult = speedcurve[speed_ptr][7]
	basicgame.lineanimtime = basicgame.linedelay>6 and basicgame.linedelay or 6
	print(original.score)
end

local function get_grade(score)
	for i=speed_ptr,#grades-1 do
		if original.score < grades[i+1][1] then
			return grades[i][2]
		end
	end
	return grades[#grades][2]
end

function original.on_spawn()
	if basicgame.level ~= 998 and basicgame.level%100 ~= 99 then
		basicgame.level = basicgame.level + 1
		original.score = original.score + original.scoremult
	end
	process_level()
end

function original.on_clear(lines)
	if lines >= 4 then
		basicgame.level = basicgame.level + 6
		original.score = original.score + original.scoremult*10
	elseif lines == 3 then
		basicgame.level = basicgame.level + 4
		original.score = original.score + original.scoremult*6
	elseif lines == 2 then
		basicgame.level = basicgame.level + 2
		original.score = original.score + original.scoremult*2.5
	elseif lines == 1 then
		basicgame.level = basicgame.level + 1
		original.score = original.score + original.scoremult
	end
	process_level()
end

function original.init()
	speed_ptr = 1
	basicgame.init_state()
	original.score = 0
	original.scoremult = speedcurve[1][7]
	process_level()
end

function original.update()
	if basicgame.endframe == 0 then
		original.score = original.score - original.scoremult/60
	end
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

return original
