local sugar = {}

forEachFile(packageInfo("logo").data, function(file)
	if string.sub(file, -6) == ".sugar" then
		table.insert(sugar, string.sub(file, 1, -7))
	end
end)

local base = getPackage("base") -- this table will be unnecessary when TerraME 1.5.1 is released

local function getSugar(pattern)
	local mfile = base.file(pattern..".sugar", "logo")

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

--- Model where a given Society grows, filling
-- the whole space. Agents reproduce with 20% of
-- probability if there is an empty neighbor.
Sugarscape = LogoModel{
	sugarMap = Choice(sugar),
	quantity = 10,
	finalTime = 200,
	space = function(instance)
		local cs = getSugar(instance.sugarMap)
		forEachCell(cs, function(cell)
			cell.sugar = cell.maxSugar
		end)
		return cs
	end,
	background = {
		select = "sugar",
		min = 0,
		max = 4,
		slices = 5,
		color = "Reds"
	},
	init = function(agent)
		agent.sugar = 10
	end,
	cell = function(cell)
		cell.sugar = cell.sugar + 0.25
		if cell.sugar > cell.maxSugar then
			cell.sugar = cell.maxSugar
		end
	end,
	changes = function(agent)
		agent.sugar = agent.sugar - 1

		local candidates = {agent:getCell()}

		forEachNeighbor(agent:getCell(), function(_, neigh)
			if neigh.sugar > candidates[1].sugar then
				candidates = {neigh}
			elseif neigh.sugar == candidates[1].sugar then
				table.insert(candidates, neigh)
			end
		end)

		local target = Random():sample(candidates)
		agent:move(target)
		target.sugar = 0
	end
}

