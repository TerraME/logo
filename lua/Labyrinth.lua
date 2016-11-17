
local patterns = {}

local labyrinths = filesByExtension("logo", "labyrinth")

forEachElement(labyrinths, function(_, file)
    local _, name = file:split()
	table.insert(patterns, name)
end)

patterns.default = "room"

--- A labyrynth, where agents move randomly from
-- a given entrance until an exit point.
-- There are some available labyrynths available.
-- See the documentation of data.
-- @arg data.finalTime The final simulation time.
-- @arg data.quantity The initial number of Agents in the model.
-- @arg data.labyrinth The spatial representation of the model.
-- The available labyrinths are described in the data available in the package.
-- They should be used without ".labyrinth" extension. The default pattern is
-- "room".
-- @image labyrinth.bmp
Labyrinth = Model{
	quantity = 1,
	finalTime = 1000,
	labyrinth = Choice(patterns),
	init = function(model)
		model.cs = getLabyrinth(model.labyrinth)
		model.cs:createNeighborhood()

		model.background = Map{
			target = model.cs,
			select = "state",
			value = {"wall", "exit", "empty", "found"},
			color = {"black", "red", "white", "green"}
		}

		model.agent = Agent{
			execute = function(agent)
				local empty = {}
				local exit

				forEachNeighbor(agent:getCell(), function(_, neigh)
					if neigh.state == "exit" then
						exit = neigh
					elseif neigh.state == "empty" then
						table.insert(empty, neigh)
					end
				end)

				if exit then
					exit.state = "found"
					agent:leave() -- TODO: replace by die() in the future
					agent.execute = function() end
				else
					agent:move(Random(empty):sample())
				end
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
			background = model.background,
			symbol = "turtle"
		}

		model.timer = Timer{
			Event{action = model.soc},
			Event{action = model.map}
		}
	end
}

