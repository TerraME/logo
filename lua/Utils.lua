
--- Return a CellularSpace with the representation of a given labyrinth
-- data available in the package.
-- @arg pattern A string with the name of a labyrinth.
-- @usage import("logo")
--
-- room = getLabyrinth("room")
function getLabyrinth(pattern)
	mandatoryArgument(1, "string", pattern)
	local mfile = filePath(pattern..".labyrinth", "logo")

	local lines = {}
	local mline = mfile:read()

	repeat
		table.insert(lines, mline)
		mline = mfile:read()
	until not mline

	local xdim = string.len(lines[1])
	local ydim = #lines

	if ydim == xdim then ydim = nil end

	local cs = CellularSpace{
		xdim = xdim,
		ydim = ydim
	}

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

