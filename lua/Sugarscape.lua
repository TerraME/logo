--- Model where a given Society grows, filling
-- the whole space. Agents reproduce with 20% of
-- probability if there is an empty neighbor.
-- @arg data.dim The x and y dimensions of space.
-- @arg data.quantity The initial number of Agents in the model.
-- @arg data.chart A boolean value indicating whether a Chart
-- with the number of Agents along the simulation should
-- be drawn.
-- @arg data.finalTime The final simulation time.
-- @arg data.map A boolean value indicating whether a Map
-- with the spatial distribution r of Agents along the 
-- simulation should be drawn.
-- @arg data.sugarMap The spatial representation of the model.
-- The available sugarscapes are described in the data available in the package.
-- They should be used without ".sugar" extension. The default pattern is
-- "room".
-- @image sugarscape.bmp
Sugarscape = Model{
	sugarMap = Choice(filesByExtension("logo", ".sugar")),
	quantity = 10,
	finalTime = 200,
	init = function(model)
		model.cs = getSugar(model.sugarMap)

		model.cs:createNeighborhood{}

		forEachCell(model.cs, function(cell)
			cell.sugar = cell.maxSugar
		end)

		model.cs.execute = function(cs)
			forEachCell(cs, function(cell)
				cell.sugar = cell.sugar + 0.25
				if cell.sugar > cell.maxSugar then
					cell.sugar = cell.maxSugar
				end
			end)
		end

		model.agent = LogoAgent{
			init = function(agent)
				agent.sugar = 10
			end,
			execute = function(agent)
				agent.sugar = agent.sugar - 1

				local candidates = {agent:getCell()}

				forEachNeighbor(agent:getCell(), function(_, neigh)
					if neigh.sugar > candidates[1].sugar then
						candidates = {neigh}
					elseif neigh.sugar == candidates[1].sugar then
						table.insert(candidates, neigh)
					end
				end)

				local target = Random(candidates):sample()
				agent:move(target)
				target.sugar = 0
			end
		}

		model.soc = Society{
			instance = model.agent,
			quantity = model.quantity
		}

		model.env = Environment{
			model.cs,
			model.soc
		}

		model.env:createPlacement{}

		model.background = Map{
			target = model.cs,
			select = "sugar",
			min = 0,
			max = 4,
			slices = 5,
			color = "Reds"
		}

		model.map = Map{
			target = model.soc,
			background = model.background
		}

		model.timer = Timer{
			Event{action = model.cs},
			Event{action = model.soc},
			Event{action = model.map}
		}
	end
}

