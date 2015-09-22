import("logo")
local cs = getLabyrinth("room")

m = Map{
	target = cs,
	select = "state",
	value = {"wall", "exit", "empty", "found"},
	color = {"black", "red", "white", "green"}
}

m:save("room.bmp")
clean()
