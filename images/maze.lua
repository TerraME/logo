import("logo")
local cs = getLabyrinth("maze")

m = Map{
	target = cs,
	select = "state",
	value = {"wall", "exit", "empty", "found"},
	color = {"black", "red", "white", "green"}
}

m:save("maze.bmp")	
clean()
