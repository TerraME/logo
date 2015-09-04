
--- Template for simple ABM Model.
function LogoModel(data)
	mandatoryTableArgument(data, "quantity", "number")
	mandatoryTableArgument(data, "changes", "function")
	optionalTableArgument(data, "dim", "number")
	optionalTableArgument(data, "init", "function")
	optionalTableArgument(data, "space", "function")
	optionalTableArgument(data, "background", "table")

	local init = data.init
	data.init = nil

	local background = data.background
	data.background = nil

	local space = data.space
	data.space = nil

	local changes = data.changes
	data.changes = nil

	data.init = function(instance)
		if space then
			instance.cs = space(instance)
		else
			instance.cs = CellularSpace{
				xdim = instance.dim,
				instance = instance.cell
			}
		end

		instance.agent = Agent{
			init = init,
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

		instance.timer = Timer{
			Event{action = function()
				instance.soc:execute()
				instance.cs:notify()
			end}
		}

		if background then
			background.target = instance.cs
			instance.background = Map(background)
		end

		instance.map = Map{
			target = instance.soc,
			background = instance.background,
			symbol = "turtle"
		}
	end

	return Model(data)
end

