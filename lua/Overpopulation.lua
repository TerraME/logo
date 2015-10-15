
--- Model where Agents die by overpopulation.
-- Each Agent beeds with a probability of 30%
-- and die if there are more than three Agents
-- in the neighborhood.
-- @arg data.dim The x and y dimensions of space.
-- @arg data.quantity The initial number of Agents in the model.
-- @arg data.chart A boolean value indicating whether a Chart
-- with the number of Agents along the simulation should
-- be drawn.
-- @arg data.finalTime The final simulation time.
-- @arg data.map A boolean value indicating whether a Map
-- with the spatial distribution r of Agents along the 
-- simulation should be drawn.
-- @image overpopulation.bmp
Overpopulation = LogoModel{
	quantity = 10,
	dim = 10,
	chart = true,
	finalTime = 60,
	changes = function(agent)
		if Random():number() < 0.3 then
			agent:breed()
		end

		agent:relocate()
	
		if agent:countNeighbors() > 3 then
			agent:die()
		end
	end
}

