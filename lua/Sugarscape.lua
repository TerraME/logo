local sugar = {}

forEachFile(packageInfo("logo").data, function(file)
	if string.sub(file, -6) == ".sugar" then
		table.insert(sugar, string.sub(file, 1, -7))
	end
end)

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

