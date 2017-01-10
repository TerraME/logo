
--- A single agent moving around randomly.
-- @arg data.dim The x and y dimensions of space.
-- @arg data.quantity The initial number of Agents in the model.
-- @arg data.finalTime The final simulation time.
-- @image single-agent.bmp
SingleAgent = Model{
	quantity = 1,
	dim = 15,
	finalTime = 100,
	init = function(model)
		model.cs = CellularSpace{
			xdim = model.dim
		}

		model.cs:createNeighborhood()

		model.agent = LogoAgent{
			execute = function(self)
				self:relocate()
			end
		}

		model.soc = Society{
			instance = model.agent,
			quantity = model.quantity
		}

		model.env = Environment{model.cs, model.soc}

		model.env:createPlacement{}

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

