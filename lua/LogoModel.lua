
--- Template for simple ABM Model.
function LogoModel(data)
	mandatoryTableArgument(data, "quantity", "number")
	mandatoryTableArgument(data, "changes", "function")
	mandatoryTableArgument(data, "dim", "number")
	optionalTableArgument(data, "init", "function")

	local init = data.init
	data.init = nil

	local changes = data.changes
	data.changes = nil

	data.init = function(instance)
		instance.cs = CellularSpace{
			xdim = instance.dim,
			instance = instance.cell
		}

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

		instance.map = Map{
			target = instance.soc,
			symbol = "turtle"
		}
	end

	return Model(data)
end

