minos = {}

--minos.data[mino][rotaton][block][x/y]
minos.data = {
	--I
	{
		{{-1,0},{0,0},{1,0},{2,0}},
		{{1,-1},{1,0},{1,1},{1,2}},
		{{-1,0},{0,0},{1,0},{2,0}},
		{{1,-1},{1,0},{1,1},{1,2}},
	},
	--T
	{
		{{-1,0},{0,0},{1,0},{0,1}},
		{{0,-1},{-1,0},{0,0},{0,1}},
		{{-1,-1},{0,-1},{1,-1},{0,0}},
		{{0,-1},{0,0},{1,0},{0,1}},
	},
	--L
	{
		{{-1,0},{0,0},{1,0},{-1,-1}},
		{{0,-1},{0,0},{0,1},{-1,-1}},
		{{-1,-1},{0,-1},{1,-1},{1,0}},
		{{0,-1},{0,0},{0,1},{1,1}},
	},
	--J
	{
		{{-1,0},{0,0},{1,0},{1,-1}},
		{{0,-1},{0,0},{0,1},{-1,1}},
		{{-1,-1},{0,-1},{1,-1},{-1,0}},
		{{0,-1},{0,0},{0,1},{1,-1}},
	},
	--S
	{
		{{0,0},{1,0},{-1,1},{0,1}},
		{{-1,-1},{-1,0},{0,0},{0,1}},
		{{0,0},{1,0},{-1,1},{0,1}},
		{{-1,-1},{-1,0},{0,0},{0,1}},
	},
	--Z
	{
		{{0,0},{-1,0},{1,1},{0,1}},
		{{1,-1},{1,0},{0,0},{0,1}},
		{{0,0},{-1,0},{1,1},{0,1}},
		{{1,-1},{1,0},{0,0},{0,1}},
	},
	--O
	{
		{{0,0},{0,1},{1,0},{1,1}},
		{{0,0},{0,1},{1,0},{1,1}},
		{{0,0},{0,1},{1,0},{1,1}},
		{{0,0},{0,1},{1,0},{1,1}},
	},
}


return rotations
