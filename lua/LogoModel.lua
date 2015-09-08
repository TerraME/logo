
--- Template for simple ABM Model.
function LogoModel(data)
	mandatoryTableArgument(data, "quantity", "number")
	mandatoryTableArgument(data, "changes", "function")
	optionalTableArgument(data, "dim", "number")
	defaultTableValue(data, "chart", false)
	defaultTableValue(data, "map", true)
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

		--instance.agent = LogoAgent{
		instance.agent = Agent{
			init = init,
			execute = changes,
			emptyNeighbor = emptyNeighbor,
			breed = breed,
			countNeighbors = countNeighbors,
			walk = walk
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
				instance.soc:notify()

				if #instance.soc == 0 then
					return false
				end
			end}
		}

		if instance.map then
			if background then
				background.target = instance.cs
				instance.background = Map(background)

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

