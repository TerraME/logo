
local base = getPackage("base") -- this table will be unnecessary when TerraME 1.5.1 is released

--- Return a CellularSpace with the representation of a given labyrinth
-- data available in the package.
-- @arg pattern A string with the name of a labyrinth.
-- @usage import("logo")
--
-- room = getLabyrinth("room")
function getLabyrinth(pattern)
	mandatoryArgument(1, "string", pattern)
	local mfile = base.filePath(pattern..".labyrinth", "logo")

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

--- Return a CellularSpace with the representation of a given sugarscape
-- data available in the package.
-- @arg pattern A string with the name of a sugarscape.
-- @usage import("logo")
--
-- room = getSugar("default")
function getSugar(pattern)
	mandatoryArgument(1, "string", pattern)

	local mfile = base.filePath(pattern..".sugar", "logo")

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
			if tostring(tonumber(value)) ~= value then
				customError("Invalid character '"..value
					.."' in file "..mfile.." (line "..y..").")
			end

			if tonumber(value) > 4 then
				customError("Maximum allowed value is 4, got "..value..".")
			end

			cs:get(x - 1, y - 1).maxSugar = tonumber(value)
		end
	end)

	return cs
end

