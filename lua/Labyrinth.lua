local labyrinths = {}

forEachFile(packageInfo("logo").data, function(file)
	if string.sub(file, -10) == ".labyrinth" then
		table.insert(labyrinths, string.sub(file, 1, -11))
	end
end)

labyrinths.default = "room"

local base = getPackage("base") -- this table will be unnecessary when TerraME 1.5.1 is released

local function getLabyrinth(pattern)
	local mfile = base.file(pattern..".labyrinth", "logo")

	local lines = {}
	for line in io.lines(mfile) do 
		lines[#lines + 1] = line
	end

	local xdim = string.len(lines[1])
	local ydim = #lines

	if ydim == xdim then ydim = nil end

	local cs = CellularSpace{
		xdim = xdim,
		ydim = ydim
	}

	local ydim = #lines

	forEachElement(lines, function(y, line)
		if xdim ~= string.len(line) then
			customError("Line "..y.." of file "..mfile.." does not have the same length ("
				..string.len(line)..") of the first line ("..xdim..").")
		end

		for x = 1, xdim do
			local value = string.sub(line, x, x)
			if value == " " then
				cs:get(x - 1, y - 1).state = "empty"
			elseif value == "W" then
				cs:get(x - 1, y - 1).state = "wall"
			elseif value == "E" then
				cs:get(x - 1, y - 1).state = "exit"
			else
				customError("Invalid character '"..string.sub(line, x, x)
					.."' in file "..mfile.." (line "..y..").")
			end
		end
	end)

	return cs
end

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

