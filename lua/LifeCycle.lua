
--- A model where agents reproduce and die by age.
-- Each Agent starts with age zero. From age 15 until
-- 30 they have 30% of chance of reproducing if there
-- is an empty neighbor cell. Agents have 5% of
-- probability of dying each time step after age 20.
-- @arg data.dim The x and y dimensions of space.
-- @arg data.chart A boolean value indicating whether a Chart
-- with the number of Agents along the simulation should
-- be drawn.
-- @arg data.quantity The initial number of Agents in the model.
-- @arg data.finalTime The final simulation time.
-- @image life-cycle.bmp
LifeCycle = Model{
	quantity = 10,
	dim = 10,
	chart = true,
	finalTime = 100,
	random = true,
	init = function(model)
		model.agent = Agent{
			init = function(agent)
				agent.age = 0
			end,
			execute = function(agent)
				agent.age = agent.age + 1

				if agent.age >= 15 and agent.age <= 30 and Random():number() < 0.3 then
					agent:reproduce()
				end

				agent:walkToEmpty()

				if Random():number() < 0.05 and agent.age >= 20 then
					agent:die()
				end
			end
		}

		model.soc = Society{
			instance = model.agent,
			quantity = model.quantity
		}

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

		model.env = Environment{model.cs, model.soc}

		model.env:createPlacement()

		model.map = Map{
			target = model.cs,
			select = "state",
			color = {"green", "black"},
			value = {"empty", "full"}
		}

		model.chart = Chart{
			target = model.soc
		}

		model.timer = Timer{
			Event{action = model.soc},
			Event{action = model.map},
			Event{action = model.chart}
		}
	end
}

