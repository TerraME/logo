
--- Model where Agents die by overpopulation.
-- Each Agent breeds with a probability of 30%
-- and die if there are more than three Agents
-- in the neighborhood.
-- @arg data.dim The x and y dimensions of space.
-- @arg data.quantity The initial number of Agents in the model.
-- @arg data.finalTime The final simulation time.
-- @image overpopulation.bmp
Overpopulation = Model{
	quantity = 10,
	dim = 10,
	finalTime = 60,
	random = true,
	init = function(model)
		model.cell = Cell{
			state = function(cell)
				if cell:getAgent() then
					return "full"
				else
					return "empty"
				end
			end
		}

		model.cs = CellularSpace{
			xdim = model.dim,
			instance = model.cell
		}

		model.cs:createNeighborhood()

		model.agent = Agent{
			execute = function(agent)
				if Random{p = 0.3}:sample() then
					agent:reproduce()
				end

				agent:walkToEmpty()

				local count = 0
				forEachNeighbor(agent:getCell(), function(neigh)
					if not neigh:isEmpty() then
						count = count + 1
					end
				end)

				if count > 3 then
					agent:die()
				end
			end
		}

		model.soc = Society{
			instance = model.agent,
			quantity = model.quantity
		}

		model.chart = Chart{
			target = model.soc
		}

		model.env = Environment{model.cs, model.soc}

		model.env:createPlacement()

		model.map = Map{
			target = model.cs,
			select = "state",
			grid = true,
			color = {"green", "black"},
			value = {"empty", "full"}
		}

		model.timer = Timer{
			Event{action = model.soc},
			Event{action = model.map},
			Event{action = model.chart}
		}
	end
}

