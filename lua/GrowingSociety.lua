
--- Model where a given Society grows, filling
-- the whole space. Agents reproduce with 20% of
-- probability if there is an empty neighbor.
-- @arg data.dim The x and y dimensions of space.
-- @arg data.chart A boolean value indicating whether a Chart
-- with the number of Agents along the simulation should
-- be drawn.
-- @arg data.quantity The initial number of Agents in the model.
-- @arg data.finalTime The final simulation time.
-- @arg data.map A boolean value indicating whether a Map
-- with the spatial distribution r of Agents along the 
-- simulation should be drawn.
-- @image growing-society.bmp
GrowingSociety = LogoModel{
	quantity = 1,
	dim = 20,
	chart = true,
	background = "green",
	finalTime = 60,
	changes = function(agent)
		if Random():number() < 0.2 then
			agent:breed()
		end

		agent:relocate()
	end
}

