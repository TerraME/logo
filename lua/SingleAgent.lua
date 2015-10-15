
--- A single agent moving around randomly.
-- @arg data.dim The x and y dimensions of space.
-- @arg data.chart A boolean value indicating whether a Chart
-- with the number of Agents along the simulation should
-- be drawn.
-- @arg data.quantity The initial number of Agents in the model.
-- @arg data.finalTime The final simulation time.
-- @arg data.map A boolean value indicating whether a Map
-- with the spatial distribution r of Agents along the 
-- simulation should be drawn.
-- @image single-agent.bmp
SingleAgent = LogoModel{
	quantity = 1,
	dim = 15,
	background = "green",
	finalTime = 100,
	changes = function(agent)
		agent:relocate()
	end
}

