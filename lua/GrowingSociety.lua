--- Model where a given Society grows, filling
-- the whole space. Agents reproduce with 20% of
-- probability if there is an empty neighbor.
-- @arg data.dim The x and y dimensions of space.
-- @arg data.quantity The initial number of Agents in the model.
-- @arg data.finalTime The final simulation time.
-- @image growing-society.bmp
GrowingSociety = Model{
	quantity = 1,
	dim = 20,
	finalTime = 60,
	random = true,
	init = function(model)
		model.cs = CellularSpace{
			xdim = model.dim
		}

		model.cs:createNeighborhood()

		model.agent = LogoAgent{
			execute = function(agent)
				if Random():number() < 0.2 then
					agent:breed()
				end

				agent:relocate()
			end
		}
		
		model.soc = Society{
			instance = model.agent,
			quantity = model.quantity
		}

		model.env = Environment{model.cs, model.soc}

		model.env:createPlacement()

		model.map = Map{
			target = model.soc,
			background = "green",
			symbol = "turtle"
		}

		model.chart = Chart{
			target = model.soc
		}

		model.timer = Timer{
			Event{action = model.soc},
			Event{action = model.map}
		}
	end
}

