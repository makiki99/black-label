shaders = {}

shaders.stack = love.graphics.newShader([[
	vec4 effect (vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
	{
		vec4 texcolor = Texel(texture, texture_coords);
		return texcolor * color * vec4(0.5,0.5,0.5,1.0);
	}
]])

shaders.grayscale_stack = love.graphics.newShader([[
	vec4 effect (vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
	{
		vec4 texcolor = Texel(texture, texture_coords) * color;
		number avg = (texcolor.r + texcolor.g + texcolor.b) / 6.0;
		return vec4(avg,avg,avg,texcolor.a);
	}
]])

return shaders
