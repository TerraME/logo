
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
-- @arg data.map A boolean value indicating whether a Map
-- with the spatial distribution r of Agents along the 
-- simulation should be drawn.
-- @image life-cycle.bmp
LifeCycle = LogoModel{
	quantity = 10,
	dim = 10,
	chart = true,
	finalTime = 100,
	init = function(agent)
		agent.age = 0
	end,
	changes = function(agent)
		agent.age = agent.age + 1

		if agent.age >= 15 and agent.age <= 30 and Random():number() < 0.3 then
			agent:breed()
		end

		agent:relocate()
	
		if Random():number() < 0.05 and agent.age >= 20 then
			agent:die()
		end
	end
}

