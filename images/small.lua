
Random{seed = 12345}

import("logo")
local cs = getSugar("small")
forEachCell(cs, function(cell)
	cell.sugar = cell.maxSugar
end)

m = Map{
	target = cs,
	select = "sugar",
	min = 0,
	max = 4,
	slices = 5,
	color = "Reds"
}
	
m:save("small.bmp")
clean()

