
--- Model where Agents die by overpopulation.
-- Each Agent beeds with a probability of 30%
-- and die if there are more than three Agents
-- in the neighborhood.
-- @arg data.dim The x and y dimensions of space.
-- @arg data.quantity The initial number of Agents in the model.
-- @arg data.finalTime The final simulation time.
-- @arg data.map A boolean value indicating whether a Map
-- with the spatial distribution r of Agents along the 
-- simulation should be drawn.
-- @image overpopulation.bmp
Overpopulation = Model{
	quantity = 10,
	dim = 10,
	finalTime = 60,
	init = function(model)	
		model.cs = CellularSpace{
			xdim = model.dim
		}

		model.cs:createNeighborhood()

		model.agent = LogoAgent{
			execute = function(agent)
				if Random():number() < 0.3 then
					agent:breed()
				end

				agent:relocate()
	
				if agent:countNeighbors() > 3 then
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

		model.env = Environment{
			model.cs,
			model.soc
		}

		model.env:createPlacement()

		model.map = Map{
			target = model.soc,
			background = "green",
			symbol = "turtle"
		}

		model.timer = Timer{
			Event{action = model.soc},
			Event{action = model.map}
		}
	end
}

