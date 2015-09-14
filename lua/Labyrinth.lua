local labyrinths = {}

forEachFile(packageInfo("logo").data, function(file)
	if string.sub(file, -10) == ".labyrinth" then
		table.insert(labyrinths, string.sub(file, 1, -11))
	end
end)

labyrinths.default = "room"

--- A labyrynth, where agents move randomly from
-- a given entrance until an exit point.
-- There are some available labyrynths available.
-- See the documentation of data.
Labyrinth = LogoModel{
	labyrinth = Choice(labyrinths),
	space = function(instance)
		return getLabyrinth(instance.labyrinth)
	end,
	quantity = 1,
	background = {
		select = "state",
		value = {"wall", "exit", "empty", "found"},
		color = {"black", "red", "white", "green"}
	},
	finalTime = 2000,
	changes = function(agent)
		local empty = {}
		local exit
		forEachNeighbor(agent:getCell(), function(_, neigh)
			if neigh.state == "exit" then
				exit = neigh
			elseif neigh.state == "empty" then
				table.insert(empty, neigh)
			end
		end)

		if exit then
			exit.state = "found"
			agent:die()
		else
			agent:move(Random():sample(empty))
		end
	end
}

