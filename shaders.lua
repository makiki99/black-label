shaders = {}

shaders.currentMino = love.graphics.newShader([[
	extern number lockpercent;
	vec4 effect (vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
	{
		vec4 texcolor = Texel(texture, texture_coords);
		number shadepercent = 0.6+(1-lockpercent)*0.4;
		return texcolor * color * vec4(shadepercent,shadepercent,shadepercent,1.0);
	}
]])

shaders.stack = love.graphics.newShader([[
	vec4 effect (vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
	{
		vec4 texcolor = Texel(texture, texture_coords);
		return texcolor * color * vec4(0.5,0.5,0.5,1.0);
	}
]])

return shaders
