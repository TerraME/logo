
--- Model where Agents die by overpopulation.
-- Each Agent beeds with a probability of 30%
-- and die if there are more than three Agents
-- in the neighborhood.
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

