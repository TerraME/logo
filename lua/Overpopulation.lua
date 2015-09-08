
--- Model where Agents die by overpopulation.
-- Each Agent beeds with a probability of 30%
-- and die if there are more than three Agents
-- in the neighborhood.
Overpopulation = LogoModel{
	quantity = 10,
	dim = 20,
	chart = true,
	finalTime = 300,
	changes = function(agent)
		if Random():number() < 0.3 then
			agent:breed()
		end

		agent:walk()
	
		if agent:countNeighbors() > 3 then
			agent:die()
		end
	end
}

