
--- Template for simple ABM Model.
-- @arg data.quantity The initial number of Agents in the model.
-- @arg data.changes A function that gets an Agent and describes
-- what happens with an Agent each time step.
-- @arg data.dim The x and y dimensions of space.
-- @arg data.chart A boolean value indicating whether a Chart
-- with the number of Agents along the simulation should
-- be drawn.
-- @arg data.map A boolean value indicating whether a Map
-- with the spatial distribution r of Agents along the 
-- simulation should be drawn.
-- @arg data.init An optional function that gets an Agent and
-- (optionally) the instance and creates the initial attributes
-- of each Agent along the simulation.
-- @arg data.background A string with the color of the
-- background, or a table with some arguments to be used when
-- creating the Map to be drawn.
-- @arg data.space An optional function that creates
-- a CellularSpace to be used along the simulation. When
-- one uses this function, the argument dim is ignored.
-- @usage SingleAgent = LogoModel{
--     quantity = 1,
--     dim = 15,
--     background = "green",
--     finalTime = 100,
--     changes = function(agent)
--         agent:relocate()
-- end
-- }

function LogoModel(data)
	mandatoryTableArgument(data, "quantity", "number")
	mandatoryTableArgument(data, "changes", "function")
	optionalTableArgument(data, "dim", "number")
	defaultTableValue(data, "chart", false)
	defaultTableValue(data, "map", true)
	optionalTableArgument(data, "init", "function")
	optionalTableArgument(data, "space", "function")

	if type(data.background) == "string" then
		data.background = {color = data.background}
	end

	optionalTableArgument(data, "background", "table")

	local init = data.init
	data.init = nil

	local background = data.background
	data.background = nil

	local space = data.space
	data.space = nil

	local cell = data.cell
	data.cell = nil

	local changes = data.changes
	data.changes = nil

	data.init = function(instance)
		if not instance.cell then
			instance.cell = Cell{
				state = function(cell)
					if #cell:getAgents() == 0 then
						return "empty"
					else
						return "full"
					end
				end
			}
		end

		if space then
			instance.cs = space(instance)
		else
			instance.cs = CellularSpace{
				xdim = instance.dim,
				instance = instance.cell
			}
		end

		if not init then
			init = function() end
		end

		instance.agent = LogoAgent{
			init = function(agent) init(agent, instance) end,
			execute = changes
		}

		instance.soc = Society{
			instance = instance.agent,
			quantity = instance.quantity
		}

		instance.cs:createNeighborhood()

		instance.env = Environment{
			instance.cs,
			instance.soc
		}

		instance.env:createPlacement()

		instance.env:add(Timer{
			Event{action = function(e)
				instance.soc:execute()

				if cell then
					forEachCell(instance.cs, cell)
				end

				instance.cs:notify()
				instance.soc:notify()

				if #instance.soc == 0 then
					return false
				end
			end}
		})

		if instance.map then
			if background then
				local mbackground = {
					target = instance.cs,
					value = background.value,
					select = background.select,
					color = background.color,
					min = background.min,
					max = background.max,
					slices = background.slices
				}
				instance.background = Map(mbackground)

				instance.map = Map{
					target = instance.soc,
					background = instance.background,
					symbol = "turtle"
				}
			else
				instance.map = Map{
					target = instance.cs,
					select = "state",
					value = {"empty", "full"},
					color = {"white", "black"}
				}
			end
		end

		if instance.chart then
			instance.chart = Chart{
				target = instance.soc
			}
			instance.soc:notify()
		end
	end

	return Model(data)
end

